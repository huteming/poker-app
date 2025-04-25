import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/db_player.dart';
import '../models/player_score.dart';
import '../models/game_record.dart';
import '../models/db_game_record.dart';
import '../widgets/score_table_row.dart';
import '../widgets/score_table_header.dart';
import 'add_record_page.dart';
import 'add_player_page.dart';
import 'game_detail_page.dart';
import '../database/game_record_dao.dart';
import '../database/player_dao.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<PlayerScore> players = [];
  List<Player> _allPlayers = [];
  final GameRecordDao _gameRecordDao = GameRecordDao();
  final PlayerDao _playerDao = PlayerDao();
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 首先加载所有玩家
      await _loadPlayers();

      // 然后加载游戏记录
      await _loadGameRecords();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 处理错误
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载数据失败: $e')));
    }
  }

  Future<void> _loadPlayers() async {
    try {
      _allPlayers = await _playerDao.findAll();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载玩家失败: $e')));
      throw e; // 重新抛出异常以便上层处理
    }
  }

  Future<void> _loadGameRecords() async {
    try {
      final records = await _gameRecordDao.getPendingRecords();
      setState(() {
        _processRecords(records);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 处理错误
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载游戏记录失败: $e')));
    }
  }

  Future<void> _refreshRecords() async {
    // 先标记为正在刷新，但不显示全屏加载
    setState(() {
      _isRefreshing = true;
    });

    try {
      final records = await _gameRecordDao.getPendingRecords();

      // 删除缓存强制刷新
      await _loadPlayers();

      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _processRecords(records);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('刷新成功'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('刷新失败: $e')));
      }
    }
  }

  void _processRecords(List<DbGameRecord> records) {
    if (records.isEmpty) {
      players = [];
      _isLoading = false;
      return;
    }

    // 收集所有参与游戏的玩家ID
    final playerIds = <String>{};
    for (var record in records) {
      playerIds.addAll(record.getAllPlayerIds());
    }

    // 为每个玩家创建得分记录
    final playerScores = <PlayerScore>[];
    for (var playerId in playerIds) {
      // 查找玩家信息
      final player = _allPlayers.firstWhere(
        (p) => p.name == playerId,
        orElse:
            () => Player(
              id: 0,
              name: playerId,
              avatar: playerId[0].toUpperCase(),
            ),
      );

      final scores = <int>[];
      final bombCounts = <int>[];
      final recordTimes = <DateTime>[];
      final gameTypes = <String>[];
      final recordIds = <int>[]; // 添加记录ID列表

      // 遍历每条记录查找该玩家的得分
      for (var record in records) {
        if (record.getAllPlayerIds().contains(playerId)) {
          scores.add(record.getPlayerScore(playerId));
          bombCounts.add(record.getPlayerBombScore(playerId));
          recordTimes.add(record.createdAt);
          gameTypes.add(record.remarks ?? '常规记分');
          recordIds.add(record.id); // 存储记录ID
        }
      }

      // 计算胜率
      final winCount = scores.where((score) => score > 0).length;
      final winRate = scores.isNotEmpty ? winCount / scores.length : 0.0;

      playerScores.add(
        PlayerScore(
          name: player.name,
          winRate: winRate,
          scores: scores,
          bombCounts: bombCounts,
          recordTimes: recordTimes,
          gameTypes: gameTypes,
          recordIds: recordIds, // 添加记录ID
          avatarText: player.avatar,
        ),
      );
    }

    players = playerScores;
    _isLoading = false;
  }

  void _showGameDetail(BuildContext context, int displayIndex) async {
    // 由于显示是倒序的，需要将显示索引转换为实际的数据索引
    final dataIndex = players.first.scores.length - 1 - displayIndex;

    // 直接使用记录ID
    final recordId = players[0].recordIds[dataIndex];

    try {
      final record = GameRecord(
        roundNumber: displayIndex + 1,
        playedAt: players[0].recordTimes[dataIndex],
        gameType: players[0].gameTypes[dataIndex],
        winners: [
          PlayerGameRecord(
            name: players[0].name,
            score: players[0].scores[dataIndex],
            bombScore: players[0].bombCounts[dataIndex],
          ),
          PlayerGameRecord(
            name: players[1].name,
            score: players[1].scores[dataIndex],
            bombScore: players[1].bombCounts[dataIndex],
          ),
        ],
        losers: [
          PlayerGameRecord(
            name: players[2].name,
            score: players[2].scores[dataIndex],
            bombScore: players[2].bombCounts[dataIndex],
          ),
          PlayerGameRecord(
            name: players[3].name,
            score: players[3].scores[dataIndex],
            bombScore: players[3].bombCounts[dataIndex],
          ),
        ],
        onDelete: () => _deleteRecord(displayIndex),
      );

      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => GameDetailPage(record: record, recordId: recordId),
        ),
      );

      // 检查返回结果，如果是删除操作，刷新列表
      if (result == 'deleted') {
        await _loadGameRecords();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('加载游戏详情失败: $e')));
    }
  }

  void _deleteRecord(int displayIndex) async {
    // 由于显示是倒序的，需要将显示索引转换为实际的数据索引
    final dataIndex = players.first.scores.length - 1 - displayIndex;

    // 直接使用存储的记录ID
    final recordId = players[0].recordIds[dataIndex];

    try {
      // 直接使用ID删除记录，无需再查询
      await _gameRecordDao.deleteRecord(recordId);

      // 刷新数据
      await _loadGameRecords();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('记录已成功删除')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除记录失败: $e')));
    }
  }

  void _addNewRecord() async {
    if (players.isEmpty && _allPlayers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加玩家')));
      return;
    }

    final playerList =
        players.isEmpty
            ? _allPlayers
                .map(
                  (player) => PlayerScore(
                    name: player.name,
                    winRate: 0.0,
                    scores: [],
                    bombCounts: [],
                    avatarText: player.avatar,
                    recordTimes: [],
                    gameTypes: [],
                    recordIds: [], // 添加记录ID列表
                  ),
                )
                .toList()
            : players;

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddRecordPage(players: playerList),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      if (result.containsKey('success') && result['success'] == true) {
        // 记录已在 AddRecordPage 中保存到数据库，直接刷新数据
        await _loadGameRecords();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('记录已成功保存')));
      } else if (result.containsKey('scores')) {
        // 兼容旧的返回格式（如果有）
        final scores = result['scores'] as Map<String, int>;
        final bombScores = result['bombScores'] as Map<String, int>;
        final gameType = result['gameType'] as String;
        final recordTime = result['recordTime'] as DateTime;

        try {
          // 准备玩家列表和得分数据
          final playerIds = scores.keys.toList();

          // 确保有4个玩家
          while (playerIds.length < 4) {
            playerIds.add(_allPlayers[playerIds.length].name);
          }

          // 保存记录到数据库
          await _gameRecordDao.insertRecord(
            gameType,
            playerIds,
            scores,
            bombScores,
          );

          // 刷新数据
          await _loadGameRecords();

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('记录已成功保存')));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('保存记录失败: $e')));
        }
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '暂无玩家',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请先添加玩家开始游戏',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final List<Player>? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPlayerPage()),
              );
              if (result != null) {
                setState(() {
                  players =
                      result
                          .map(
                            (player) => PlayerScore(
                              name: player.name,
                              winRate: 0.0,
                              scores: [],
                              bombCounts: [],
                              avatarText: player.avatar,
                              recordTimes: [],
                              gameTypes: [],
                              recordIds: [], // 添加记录ID列表
                            ),
                          )
                          .toList();
                });
              }
            },
            child: const Text(
              '添加玩家',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('本局积分')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (players.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('本局积分'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '刷新列表',
              onPressed: _refreshRecords,
            ),
          ],
        ),
        body: _buildEmptyState(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('本局积分'),
        actions: [
          _isRefreshing
              ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: '刷新列表',
                onPressed: _refreshRecords,
              ),
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: '添加玩家',
            onPressed: () async {
              final List<Player>? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPlayerPage()),
              );
              if (result != null) {
                setState(() {
                  players =
                      result
                          .map(
                            (player) => PlayerScore(
                              name: player.name,
                              winRate: 0.0,
                              scores: [],
                              bombCounts: [],
                              avatarText: player.avatar,
                              recordTimes: [],
                              gameTypes: [],
                              recordIds: [], // 添加记录ID列表
                            ),
                          )
                          .toList();
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ScoreTableHeader(players: players),
          Expanded(
            child:
                players.first.scores.isEmpty
                    ? const Center(
                      child: Text(
                        '暂无记录',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: players.first.scores.length,
                      itemBuilder: (context, index) {
                        // 倒序显示记录
                        final reverseIndex =
                            players.first.scores.length - 1 - index;
                        return ScoreTableRow(
                          players: players,
                          rowIndex: reverseIndex,
                          onTap: () => _showGameDetail(context, index),
                          onDelete: _deleteRecord,
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _addNewRecord,
                child: const Text(
                  '添加新记录',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
