import 'package:flutter/material.dart';
import '../models/player_score.dart';

class ScoreTableHeader extends StatelessWidget {
  final List<PlayerScore> players;

  const ScoreTableHeader({Key? key, required this.players}) : super(key: key);

  Color _getAvatarColor(String name) {
    switch (name) {
      case '钱':
        return Colors.amber;
      case '孙':
        return Colors.pink;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children:
            players.map((player) {
              return Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: _getAvatarColor(player.name),
                      child: Text(
                        player.avatarText,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(player.winRate * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}
