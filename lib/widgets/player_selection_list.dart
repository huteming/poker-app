import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerSelectionList extends StatefulWidget {
  final String searchQuery;
  final List<Player> selectedPlayers;
  final Function(List<Player>) onPlayersSelected;

  const PlayerSelectionList({
    Key? key,
    required this.searchQuery,
    required this.selectedPlayers,
    required this.onPlayersSelected,
  }) : super(key: key);

  @override
  State<PlayerSelectionList> createState() => _PlayerSelectionListState();
}

class _PlayerSelectionListState extends State<PlayerSelectionList> {
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
    // 模拟所有玩家数据
    final allPlayers = [
      Player(name: '张三', avatarText: '张'),
      Player(name: '李四', avatarText: '李'),
      Player(name: '王五', avatarText: '王'),
      Player(name: '赵六', avatarText: '赵'),
      Player(name: '钱七', avatarText: '钱'),
      Player(name: '孙八', avatarText: '孙'),
      Player(name: '周九', avatarText: '周'),
      Player(name: '吴十', avatarText: '吴'),
      Player(name: '郑十一', avatarText: '郑'),
      Player(name: '王十二', avatarText: '王'),
    ];

    // 过滤玩家列表
    final filteredPlayers =
        allPlayers.where((player) {
          return player.name.contains(widget.searchQuery) ||
              player.avatarText.contains(widget.searchQuery);
        }).toList();

    if (filteredPlayers.isEmpty) {
      return const Center(
        child: Text(
          '没有找到相关玩家',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final player = filteredPlayers[index];
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
