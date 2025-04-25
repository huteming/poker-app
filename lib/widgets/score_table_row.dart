import 'package:flutter/material.dart';
import '../models/player_score.dart';

class ScoreTableRow extends StatelessWidget {
  final List<PlayerScore> players;
  final int rowIndex;
  final VoidCallback onTap;
  final Function(int)? onDelete;

  const ScoreTableRow({
    Key? key,
    required this.players,
    required this.rowIndex,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  String _formatScore(int score) {
    return score >= 0 ? '+$score' : '$score';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children:
                players.map((player) {
                  if (player.scores.isEmpty ||
                      rowIndex >= player.scores.length) {
                    return const Expanded(
                      child: Text(
                        '-',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  final score = player.scores[rowIndex];
                  return Expanded(
                    child: Text(
                      _formatScore(score),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: score >= 0 ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}
