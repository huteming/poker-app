import 'package:flutter/material.dart';
import 'package:poker/domains/player_entity.dart';
import '../../../../widgets/player_avatar.dart';

class PlayerSelector extends StatelessWidget {
  final List<PlayerEntity> players;
  final List<int> selectedPlayerIds;
  final Function(List<int>) onChanged;

  const PlayerSelector({
    super.key,
    required this.players,
    required this.selectedPlayerIds,
    required this.onChanged,
  });

  void _onSelectPlayer(int playerId) {
    final newSelected = List<int>.from(selectedPlayerIds);

    if (selectedPlayerIds.contains(playerId)) {
      newSelected.remove(playerId);
    } else if (selectedPlayerIds.length < 4) {
      newSelected.add(playerId);
    }

    onChanged(newSelected);
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
              final isSelected = selectedPlayerIds.any((id) => id == player.id);
              final selectedIndex = selectedPlayerIds.indexOf(player.id);
              final isWinner = selectedIndex < 2;

              return GestureDetector(
                onTap: () => _onSelectPlayer(player.id),
                child: PlayerAvatar(
                  name: player.name,
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
