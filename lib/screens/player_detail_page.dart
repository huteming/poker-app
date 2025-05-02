import 'package:flutter/material.dart';
import '../models/db_game_record.dart';
import '../models/player_statistics.dart';
import '../database/game_record_dao.dart';

class PlayerDetailPage extends StatefulWidget {
  final PlayerStatistics playerStats;

  const PlayerDetailPage({super.key, required this.playerStats});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  final GameRecordDao _gameRecordDao = GameRecordDao();
  List<DbGameRecord> _records = [];
  bool _isLoading = true;
  Map<String, dynamic>? _playerStats;

  @override
  void initState() {
    super.initState();
    _loadPlayerGames();
  }

  Future<void> _loadPlayerGames() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 获取玩家的所有对局记录
      final records = await _gameRecordDao.getPlayerRecords(
        widget.playerStats.playerName,
      );

      // 获取玩家最新的统计信息
      final Map<String, dynamic> playerStats = await _gameRecordDao
          .getPlayerStatistics(widget.playerStats.playerName);

      setState(() {
        _records = records;
        _isLoading = false;

        // 更新统计信息
        _playerStats ??= playerStats;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text('加载对局记录失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerName = widget.playerStats.playerName;
    final stats = widget.playerStats;

    return Scaffold(
      appBar: AppBar(title: Text('${playerName}的对局记录')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildPlayerHeader(stats),
                  const Divider(height: 1),
                  Expanded(
                    child:
                        _records.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                              itemCount: _records.length,
                              itemBuilder: (context, index) {
                                final record = _records[index];
                                return _buildGameRecord(record, playerName);
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildPlayerHeader(PlayerStatistics stats) {
    final playerName = stats.playerName;
    final isPositiveScore = stats.totalScore >= 0;

    // 使用最新统计数据（如果有）
    final totalGames = _playerStats?['totalGames'] ?? 0;
    final totalBombScore = _playerStats?['totalBombScore'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal.shade200,
                child: Text(
                  playerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playerName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatItem(
                          '胜率',
                          '${(stats.winRate * 100).toInt()}%',
                          Icons.trending_up,
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          '排名',
                          '#${stats.rank}',
                          Icons.leaderboard,
                        ),
                        const SizedBox(width: 16),
                        _buildStatItem(
                          '总积分',
                          isPositiveScore
                              ? '+${stats.totalScore}'
                              : '${stats.totalScore}',
                          Icons.score,
                          valueColor:
                              isPositiveScore ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailStatItem('总对局', '$totalGames', Icons.casino),
              _buildDetailStatItem(
                '炸弹分',
                '+$totalBombScore',
                Icons.local_fire_department,
                valueColor: Colors.orange,
              ),
              _buildDetailStatItem('加入时间', '0000-00-00', Icons.date_range),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailStatItem(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_esports, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '暂无对局记录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '该玩家还没有参与任何对局',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildGameRecord(DbGameRecord record, String playerName) {
    final score = 0;
    final bombScore = 0;
    final isWin = score > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.remarks ?? '常规记分',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '0000-00-00',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isWin ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                      color: isWin ? Colors.amber : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isWin ? '获胜' : '失败',
                      style: TextStyle(
                        color: isWin ? Colors.amber[700] : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  score >= 0 ? '+$score' : '$score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: score >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (bombScore > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '炸弹分: +$bombScore',
                    style: const TextStyle(color: Colors.orange, fontSize: 14),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String avatar) {
    final colors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.purple.shade300,
      Colors.orange.shade300,
      Colors.pink.shade300,
      Colors.teal.shade300,
    ];

    return colors[avatar.hashCode % colors.length];
  }
}
