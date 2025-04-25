import 'package:flutter/material.dart';
import '../../add_player_page.dart';
import '../../../models/db_player.dart';
import '../../../models/player_score.dart';

/// 显示无玩家/记录状态的视图组件
class ScorePageEmptyView extends StatelessWidget {
  final Function(List<PlayerScore>) onPlayersAdded;

  const ScorePageEmptyView({super.key, required this.onPlayersAdded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本局积分')),
      body: _buildEmptyState(context),
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
              final List<Player>? result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddPlayerPage()),
              );
              if (result != null) {
                final playerScores =
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

                onPlayersAdded(playerScores);
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
}
