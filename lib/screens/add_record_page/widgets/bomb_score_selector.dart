import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/player_avatar.dart';
import '../../../../providers/player_provider.dart';

class BombScoreSelector extends StatelessWidget {
  final List<int> selectedPlayerIds;
  final Map<int, int> bombScores;
  final Function(int, int) onChanged;

  const BombScoreSelector({
    super.key,
    required this.selectedPlayerIds,
    required this.bombScores,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedPlayerIds.isEmpty) {
      return const SizedBox.shrink();
    }

    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    final players =
        selectedPlayerIds
            .map((playerId) => playerProvider.findPlayerById(playerId))
            .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            players.map((player) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    PlayerAvatar(name: player.name, isSelected: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: List.generate(7, (index) {
                          final score = index + 4;
                          final isSelected = bombScores[player.id] == score;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => onChanged(player.id, score),
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
