import 'package:flutter/material.dart';
import 'package:poker/models/db_player.dart';
import '../../../models/db_game_record.dart';

class Score {
  final String score;
  final Color color;

  Score({required this.score, required this.color});
}

class ScoreTableRow extends StatelessWidget {
  final List<Player> players;
  final DbGameRecord record;
  final int rowIndex;
  final VoidCallback onTap;

  const ScoreTableRow({
    super.key,
    required this.players,
    required this.record,
    required this.rowIndex,
    required this.onTap,
  });

  Score _formatScore(int? score) {
    if (score == null) {
      return Score(score: '-', color: Colors.grey);
    }
    if (score > 0) {
      return Score(score: '$score', color: Colors.green);
    }
    return Score(score: '$score', color: Colors.red);
  }

  Score _getScore(Player player) {
    if (record.player1Id == player.id) {
      return _formatScore(record.player1FinalScore);
    }
    if (record.player2Id == player.id) {
      return _formatScore(record.player2FinalScore);
    }
    if (record.player3Id == player.id) {
      return _formatScore(record.player3FinalScore);
    }
    if (record.player4Id == player.id) {
      return _formatScore(record.player4FinalScore);
    }
    return _formatScore(null);
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
                  final score = _getScore(player);

                  return Expanded(
                    child: Text(
                      score.score,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: score.color,
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
