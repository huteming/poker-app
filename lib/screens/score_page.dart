import 'package:flutter/material.dart';
import '../models/player_score.dart';
import '../models/game_record.dart';
import '../widgets/score_table_row.dart';
import '../widgets/score_table_header.dart';
import 'add_record_page.dart';
import 'add_player_page.dart';
import 'game_detail_page.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  List<PlayerScore> players = [];

  void _showGameDetail(BuildContext context, int roundNumber) {
    // 模拟数据，实际应该从数据源获取
    final record = GameRecord(
      roundNumber: roundNumber,
      playedAt: DateTime(2024, 2, 28, 14, 30),
      gameType: '春天',
      winners: [
        PlayerGameRecord(name: '张', score: 120, bombScore: 9),
        PlayerGameRecord(name: '李', score: 120, bombScore: 6),
      ],
      losers: [
        PlayerGameRecord(name: '王', score: -120, bombScore: 7),
        PlayerGameRecord(name: '赵', score: -120, bombScore: null),
      ],
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameDetailPage(record: record)),
    );
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
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPlayerPage()),
              );
              if (result != null) {
                // 模拟选择玩家后的积分数据
                setState(() {
                  players = [
                    PlayerScore(
                      name: '张三',
                      winRate: 0.60,
                      scores: [140, -80, 100],
                      avatarText: '张',
                    ),
                    PlayerScore(
                      name: '李四',
                      winRate: 0.55,
                      scores: [140, -80, 100],
                      avatarText: '李',
                    ),
                    PlayerScore(
                      name: '王五',
                      winRate: 0.48,
                      scores: [-140, 80, -100],
                      avatarText: '王',
                    ),
                  ];
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
    if (players.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('本局积分')),
        body: _buildEmptyState(context),
      );
    }

    // 获取记录数量
    final recordCount = players.first.scores.length;

    return Scaffold(
      appBar: AppBar(title: const Text('本局积分')),
      body: Column(
        children: [
          ScoreTableHeader(players: players),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: recordCount,
              itemBuilder: (context, index) {
                return ScoreTableRow(
                  players: players,
                  rowIndex: index,
                  onTap: () => _showGameDetail(context, index + 1),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddPlayerPage(),
                        ),
                      );
                      if (result != null) {
                        // 模拟选择玩家后的积分数据
                        setState(() {
                          players = [
                            PlayerScore(
                              name: '张三',
                              winRate: 0.60,
                              scores: [140, -80, 100],
                              avatarText: '张',
                            ),
                            PlayerScore(
                              name: '李四',
                              winRate: 0.55,
                              scores: [140, -80, 100],
                              avatarText: '李',
                            ),
                            PlayerScore(
                              name: '王五',
                              winRate: 0.48,
                              scores: [-140, 80, -100],
                              avatarText: '王',
                            ),
                          ];
                        });
                      }
                    },
                    child: const Text(
                      '新增玩家',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddRecordPage(),
                        ),
                      );
                    },
                    child: const Text(
                      '添加新记录',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
