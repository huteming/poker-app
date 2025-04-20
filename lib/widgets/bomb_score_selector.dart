import 'package:flutter/material.dart';
import 'player_avatar.dart';

class BombScoreSelector extends StatelessWidget {
  final List<String> selectedPlayers;
  final Map<String, int> bombScores;
  final Function(String, int) onScoreChanged;

  const BombScoreSelector({
    Key? key,
    required this.selectedPlayers,
    required this.bombScores,
    required this.onScoreChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedPlayers.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            selectedPlayers.map((player) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    PlayerAvatar(name: player, isSelected: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: List.generate(7, (index) {
                          final score = index + 4;
                          final isSelected = bombScores[player] == score;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => onScoreChanged(player, score),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.purple
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.purple
                                            : Colors.grey.shade300,
                                  ),
                                ),
                                child: Text(
                                  score.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    fontSize: 14,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
