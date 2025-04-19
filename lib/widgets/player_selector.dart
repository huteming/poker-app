import 'package:flutter/material.dart';
import 'player_avatar.dart';

class PlayerSelector extends StatelessWidget {
  final List<String> players;
  final List<String> selectedPlayers;
  final Function(List<String>) onSelectionChanged;

  const PlayerSelector({
    Key? key,
    required this.players,
    required this.selectedPlayers,
    required this.onSelectionChanged,
  }) : super(key: key);

  void _handleTap(String player) {
    final newSelected = List<String>.from(selectedPlayers);
    if (selectedPlayers.contains(player)) {
      newSelected.remove(player);
    } else if (selectedPlayers.length < 4) {
      newSelected.add(player);
    }
    onSelectionChanged(newSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children:
            players.map((player) {
              final isSelected = selectedPlayers.contains(player);
              final selectedIndex = selectedPlayers.indexOf(player);
              final isWinner = selectedIndex < 2;

              return GestureDetector(
                onTap: () => _handleTap(player),
                child: PlayerAvatar(
                  name: player,
                  isSelected: isSelected,
                  isWinner: isSelected && isWinner,
                  selectedIndex: selectedIndex + 1,
                ),
              );
            }).toList(),
      ),
    );
  }
}
