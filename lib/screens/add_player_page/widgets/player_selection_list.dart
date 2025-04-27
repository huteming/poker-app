import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/db_player.dart';
import '../../../providers/player_provider.dart';

class PlayerSelectionList extends StatefulWidget {
  final List<Player> newPlayers;
  final List<Player> gamingPlayers;
  final Function(List<Player>) onPlayersSelected;

  const PlayerSelectionList({
    super.key,
    required this.gamingPlayers,
    required this.newPlayers,
    required this.onPlayersSelected,
  });

  @override
  State<PlayerSelectionList> createState() => _PlayerSelectionListState();
}

class _PlayerSelectionListState extends State<PlayerSelectionList> {
  void _togglePlayer(Player player) {
    final newSelectedPlayers = List<Player>.from(widget.newPlayers);
    if (newSelectedPlayers.contains(player)) {
      newSelectedPlayers.remove(player);
    } else {
      newSelectedPlayers.add(player);
    }
    widget.onPlayersSelected(newSelectedPlayers);
  }

  bool _isSelected(Player player) {
    return widget.newPlayers.any((element) => element.id == player.id);
  }

  bool _isDisabled(Player player) {
    return widget.gamingPlayers.any((element) => element.id == player.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        if (playerProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final players = playerProvider.players;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            final isSelected = _isSelected(player);
            final isDisabled = _isDisabled(player);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isDisabled ? null : () => _togglePlayer(player),
                  borderRadius: BorderRadius.circular(12),
                  child: Opacity(
                    opacity: isDisabled ? 0.5 : 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDisabled
                                ? Colors.grey[200]
                                : (isSelected
                                    ? Color.fromARGB(26, 156, 39, 176)
                                    : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isDisabled
                                  ? Colors.grey[400]!
                                  : (isSelected
                                      ? Colors.purple
                                      : Colors.grey[200]!),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                isDisabled
                                    ? Colors.grey[400]
                                    : (isSelected
                                        ? Colors.purple
                                        : Colors.grey[300]),
                            child: Text(
                              player.avatar,
                              style: TextStyle(
                                color:
                                    isDisabled
                                        ? Colors.grey[600]
                                        : (isSelected
                                            ? Colors.white
                                            : Colors.black),
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              player.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                color:
                                    isDisabled
                                        ? Colors.grey[600]
                                        : (isSelected
                                            ? Colors.purple
                                            : Colors.black),
                              ),
                            ),
                          ),
                          Icon(
                            isDisabled
                                ? Icons.block
                                : (isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined),
                            color:
                                isDisabled
                                    ? Colors.grey[400]
                                    : (isSelected
                                        ? Colors.purple
                                        : Colors.grey[400]),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
