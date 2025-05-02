import 'package:flutter/material.dart';
import '../../models/player_statistics.dart';
import '../history_page.dart';
import '../player_detail_page.dart';
import '../../services/game_record_service.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayerListPage> {
  final GameRecordService _gameRecordService = GameRecordService();
  bool _isLoading = true;
  List<PlayerStatistics> _playerStats = [];

  @override
  void initState() {
    super.initState();
    _loadPlayerStatistics();
  }

  Future<void> _loadPlayerStatistics() async {
    setState(() {
      _isLoading = true;
    });

    final allStats = await _gameRecordService.getAllPlayerStatistics();

    setState(() {
      _playerStats = allStats;
      _isLoading = false;
    });
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
    final playerName = stat.playerName;
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
                  playerName,
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
                      playerName,
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
                        // 胜率
                        Text(
                          '${stat.winRate}%',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 排名
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
