import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:poker/models/db_player.dart';
import 'package:poker/models/player_score.dart';
import 'package:poker/models/game_record.dart';
import 'package:poker/models/db_game_record.dart';
import 'package:poker/widgets/score_table_row.dart';
import 'package:poker/widgets/score_table_header.dart';
import 'package:poker/screens/add_record_page.dart';
import 'package:poker/screens/add_player_page.dart';
import 'package:poker/screens/game_detail_page.dart';
import 'package:poker/screens/players_page.dart';
import 'package:poker/database/game_record_dao.dart';
import 'package:poker/providers/player_provider.dart';
import 'widgets/loading_view.dart';
import 'widgets/empty_view.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<PlayerScore> players = [];
  final GameRecordDao _gameRecordDao = GameRecordDao();
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

    // 从Provider获取玩家列表，不再需要单独加载
    await _loadGameRecords();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadGameRecords() async {
    // 获取游戏记录，DAO 层会处理错误并返回空列表
    final records = await _gameRecordDao.getPendingRecords();

    setState(() {
      _processRecords(records);
    });
  }

  Future<void> _refreshRecords() async {
    // 先标记为正在刷新，但不显示全屏加载
    setState(() {
      _isRefreshing = true;
    });

    // 刷新数据，DAO 层会处理错误
    final records = await _gameRecordDao.getPendingRecords();

    // 使用Provider刷新玩家数据
    await Provider.of<PlayerProvider>(context, listen: false).refreshPlayers();

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _processRecords(records);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('刷新成功'), duration: Duration(seconds: 1)),
      );
    }
  }

  void _processRecords(List<DbGameRecord> records) {
    if (records.isEmpty) {
      players = [];
      _isLoading = false;
      return;
    }

    // 从Provider获取玩家列表
    final allPlayers =
        Provider.of<PlayerProvider>(context, listen: false).players;

    // 收集所有参与游戏的玩家ID
    final playerIds = <String>{};
    for (var record in records) {
      playerIds.addAll(record.getAllPlayerIds());
    }

    // 为每个玩家创建得分记录
    final playerScores = <PlayerScore>[];
    for (var playerId in playerIds) {
      // 从Provider查找玩家信息
      final player = allPlayers.firstWhere(
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

    // 标记为正在加载
    setState(() {
      _isRefreshing = true;
    });

    // 删除记录，DAO 层处理错误并返回结果
    final success = await _gameRecordDao.deleteRecord(recordId);

    // 刷新数据
    await _loadGameRecords();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success ? '记录已成功删除' : '删除记录失败')));
    }
  }

  void _addNewRecord() async {
    // 从Provider获取玩家列表
    final allPlayers =
        Provider.of<PlayerProvider>(context, listen: false).players;

    if (players.isEmpty && allPlayers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先添加玩家')));
      return;
    }

    final playerList =
        players.isEmpty
            ? allPlayers
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
          final allPlayers =
              Provider.of<PlayerProvider>(context, listen: false).players;

          // 确保有4个玩家
          while (playerIds.length < 4 && allPlayers.length > playerIds.length) {
            playerIds.add(allPlayers[playerIds.length].name);
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

  void _navigateToAddPlayer() async {
    final List<Player>? result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddPlayerPage()));
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
                    recordIds: [],
                  ),
                )
                .toList();
      });
    }
  }

  Future<void> _settleAllRecords() async {
    // 显示确认对话框
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认结算'),
          content: const Text('确定要结算当前所有记录吗？结算后将不再显示在本页面。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确认结算', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isRefreshing = true;
    });

    // 结算记录，DAO 层处理错误并返回结果
    final settledCount = await _gameRecordDao.settleAllPendingRecords();

    // 刷新数据
    await _loadGameRecords();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            settledCount > 0 ? '成功结算 $settledCount 条记录' : '没有记录需要结算',
          ),
        ),
      );
    }
  }

  void _navigateToPlayersPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PlayersPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ScorePageLoadingView();
    }

    if (players.isEmpty) {
      return ScorePageEmptyView(
        onPlayersAdded: (playerScores) {
          setState(() {
            players = playerScores;
          });
        },
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: '更多选项',
            onSelected: (String value) {
              switch (value) {
                case 'add_player':
                  _navigateToAddPlayer();
                  break;
                case 'settle_all':
                  _settleAllRecords();
                  break;
                case 'view_players':
                  _navigateToPlayersPage();
                  break;
                // 可以添加更多选项
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'add_player',
                    child: Row(
                      children: [
                        Icon(Icons.group_add, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('添加玩家'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'view_players',
                    child: Row(
                      children: [
                        Icon(Icons.people, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('玩家列表'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settle_all',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('结算本局'),
                      ],
                    ),
                  ),
                  // 可以在此处添加更多菜单项
                ],
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
