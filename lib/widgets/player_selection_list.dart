import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerSelectionList extends StatefulWidget {
  final List<Player> selectedPlayers;
  final Function(List<Player>) onPlayersSelected;

  const PlayerSelectionList({
    Key? key,
    required this.selectedPlayers,
    required this.onPlayersSelected,
  }) : super(key: key);

  @override
  State<PlayerSelectionList> createState() => _PlayerSelectionListState();
}

class _PlayerSelectionListState extends State<PlayerSelectionList> {
  final PlayerService _playerService = PlayerService();
  List<Player> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final players = await _playerService.getAllPlayers();
      setState(() {
        _players = players;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载玩家列表失败: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _togglePlayer(Player player) {
    final newSelectedPlayers = List<Player>.from(widget.selectedPlayers);
    if (newSelectedPlayers.contains(player)) {
      newSelectedPlayers.remove(player);
    } else {
      newSelectedPlayers.add(player);
    }
    widget.onPlayersSelected(newSelectedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_players.isEmpty) {
      return const Center(
        child: Text(
          '没有找到相关玩家',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _players.length,
      itemBuilder: (context, index) {
        final player = _players[index];
        final isSelected = widget.selectedPlayers.contains(player);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _togglePlayer(player),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.purple.withOpacity(0.1)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.purple : Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          isSelected ? Colors.purple : Colors.grey[300],
                      child: Text(
                        player.avatarText,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.purple : Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.purple : Colors.grey[400],
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
