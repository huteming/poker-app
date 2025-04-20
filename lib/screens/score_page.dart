import 'package:flutter/material.dart';
import '../models/player.dart';
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

  void _showGameDetail(BuildContext context, int displayIndex) {
    // 由于显示是倒序的，需要将显示索引转换为实际的数据索引
    final dataIndex = players.first.scores.length - 1 - displayIndex;

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
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameDetailPage(record: record)),
    );
  }

  void _addNewRecord() async {
    if (players.isEmpty) return;

    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddRecordPage(players: players)),
    );

    if (result != null && result is Map<String, dynamic>) {
      final scores = result['scores'] as Map<String, int>;
      final bombScores = result['bombScores'] as Map<String, int>;
      final gameType = result['gameType'] as String;
      final recordTime = result['recordTime'] as DateTime;

      setState(() {
        // 更新每个玩家的分数记录
        for (var player in players) {
          if (scores.containsKey(player.name)) {
            player.addRecord(
              scores[player.name]!,
              bombCount: bombScores[player.name] ?? 0,
              gameType: gameType,
              recordTime: recordTime,
            );
          }
        }

        // 更新胜率
        for (var player in players) {
          if (player.scores.isNotEmpty) {
            final winCount = player.scores.where((score) => score > 0).length;
            player.winRate = winCount / player.scores.length;
          }
        }
      });
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
                              avatarText: player.avatarText,
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
    if (players.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('本局积分')),
        body: _buildEmptyState(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('本局积分'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
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
                              avatarText: player.avatarText,
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
