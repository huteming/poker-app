import 'package:flutter/material.dart';
import '../models/game_record.dart';
import '../widgets/player_avatar.dart';

class GameDetailPage extends StatelessWidget {
  final GameRecord record;

  const GameDetailPage({Key? key, required this.record}) : super(key: key);

  Widget _buildPlayerList(String title, List<PlayerGameRecord> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ...players
            .map(
              (player) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    PlayerAvatar(name: player.name, isSelected: false),
                    const SizedBox(width: 16),
                    Text(
                      (player.score >= 0 ? '+' : '') + player.score.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: player.score >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '炸弹：${player.bombScore?.toString() ?? '无'}分',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第${record.roundNumber}局详情'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('确认删除'),
                      content: const Text('确定要删除这条记录吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            // 执行删除操作
                            if (record.onDelete != null) {
                              record.onDelete!();
                            }
                          },
                          child: const Text(
                            '删除',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );
            },
            child: const Text('删除记录', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlayerList('胜方', record.winners),
              const SizedBox(height: 32),
              _buildPlayerList('负方', record.losers),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    '胜负类型',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      record.gameType,
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '记录时间：${record.playedAt.toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
