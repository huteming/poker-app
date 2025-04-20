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
    return Dismissible(
      key: ValueKey('record_$rowIndex'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('确认删除'),
              content: const Text('确定要删除这条记录吗？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('删除', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        onDelete?.call(rowIndex);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Material(
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
      ),
    );
  }
}
