import 'package:flutter/material.dart';
import 'package:poker/domains/game_record_entity.dart';
import 'package:poker/domains/player_entity.dart';

class ScoreTableHeader extends StatelessWidget {
  final List<PlayerEntity> players;
  final List<GameRecordEntity> records;

  const ScoreTableHeader({
    super.key,
    required this.players,
    required this.records,
  });

  calcPlayerStat(PlayerEntity player) {
    var totalScore = 0;
    var winCount = 0;
    var loseCount = 0;

    for (var record in records) {
      totalScore += record.getPlayerScore(player.id);
      if (record.isWin(player.id) == 1) {
        winCount++;
      } else if (record.isWin(player.id) == -1) {
        loseCount++;
      }
    }

    String winRate;
    if (winCount + loseCount == 0) {
      winRate = '0%';
    } else {
      winRate = '${(winCount / (winCount + loseCount) * 100).toInt()}%';
    }

    return {'totalScore': totalScore, 'winRate': winRate};
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
              final stat = calcPlayerStat(player);

              return Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stat['totalScore']}',
                      style: TextStyle(
                        color:
                            stat['totalScore'] >= 0 ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat['winRate'],
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
