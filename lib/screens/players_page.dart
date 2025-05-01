import 'package:flutter/material.dart';
import '../database/player_dao.dart';
import '../database/game_record_dao.dart';
import '../models/player_statistics.dart';
import 'history_page.dart';
import 'player_detail_page.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({super.key});

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final PlayerDao _playerDao = PlayerDao();
  bool _isLoading = true;
  List<PlayerStatistics> _playerStats = [];

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 获取所有玩家
      final players = await _playerDao.findAll();

      // 获取所有玩家的统计信息
      final GameRecordDao gameRecordDao = GameRecordDao();
      final allStats = await gameRecordDao.getAllPlayersStatistics();

      // 将玩家信息和统计信息结合
      final playerStats = <PlayerStatistics>[];

      for (final player in players) {
        // 查找该玩家的统计信息
        final statItem = allStats.firstWhere(
          (stat) => stat['playerName'] == player.name,
          orElse:
              () => {
                'playerName': player.name,
                'totalGames': 0,
                'wins': 0,
                'winRate': 0.0,
                'totalScore': 0,
                'totalBombScore': 0,
                'rank': allStats.length + 1,
              },
        );

        playerStats.add(
          PlayerStatistics(
            player: player,
            winRate: statItem['winRate'] as double,
            totalScore: statItem['totalScore'] as int,
            rank: statItem['rank'] as int,
          ),
        );
      }

      // 按排名排序
      playerStats.sort((a, b) => a.rank.compareTo(b.rank));

      setState(() {
        _playerStats = playerStats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('加载玩家失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('玩家列表')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('玩家列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: '查询历史',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body:
          _playerStats.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _playerStats.length,
                itemBuilder: (context, index) {
                  final stat = _playerStats[index];
                  return _buildPlayerCard(stat);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
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
        ],
      ),
    );
  }

  Widget _buildPlayerCard(PlayerStatistics stat) {
    final player = stat.player;
    final isPositiveScore = stat.totalScore >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerDetailPage(playerStats: stat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.teal.shade200,
                child: Text(
                  player.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 玩家信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(stat.winRate * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '排名 ${stat.rank}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 积分
              Text(
                isPositiveScore ? '+${stat.totalScore}' : '${stat.totalScore}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPositiveScore ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '总积分',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
