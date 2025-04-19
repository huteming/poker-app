import 'package:flutter/material.dart';
import '../models/player_score.dart';

class PlayerScoreCard extends StatelessWidget {
  final PlayerScore player;

  const PlayerScoreCard({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 头像和名字
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Text(
            player.avatarText,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
        ),
        const SizedBox(height: 4),

        // 胜率
        Text(
          '${(player.winRate * 100).toInt()}%',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 积分列表
        ...player.scores.map((score) {
          final isPositive = score > 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              (isPositive ? '+' : '') + score.toString(),
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
