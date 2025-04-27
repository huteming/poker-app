import 'package:flutter/material.dart';
import '../../../models/db_player.dart';
import '../../../widgets/player_avatar.dart';

class PlayerDetailRow extends StatelessWidget {
  final Player player;
  final int finalScore;
  final int bombScore;

  const PlayerDetailRow({
    super.key,
    required this.player,
    required this.finalScore,
    required this.bombScore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          PlayerAvatar(
            name: player.name,
            isSelected: false,
            avatarText: player.avatar,
          ),
          const SizedBox(width: 16),
          Text(
            (finalScore >= 0 ? '+' : '') + finalScore.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: finalScore >= 0 ? Colors.green : Colors.red,
            ),
          ),
          const Spacer(),
          Text(
            '炸弹：${bombScore.toString()}分',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
