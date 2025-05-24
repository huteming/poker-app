import 'package:flutter/material.dart';
import 'package:poker/domains/player_entity.dart';
import 'widgets/player_selection_list.dart';

class AddPlayerPage extends StatefulWidget {
  final List<PlayerEntity> gamingPlayers;

  const AddPlayerPage({super.key, this.gamingPlayers = const []});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  List<PlayerEntity> newPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择玩家')),
      body: Column(
        children: [
          Expanded(
            child: PlayerSelectionList(
              gamingPlayers: widget.gamingPlayers,
              newPlayers: newPlayers,
              onPlayersSelected: (sselectedPlayers) {
                setState(() {
                  newPlayers = sselectedPlayers;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    newPlayers.isEmpty
                        ? null
                        : () {
                          Navigator.of(context).pop(newPlayers);
                        },
                child: Text(
                  newPlayers.isEmpty
                      ? '请选择玩家'
                      : '确认添加 ${newPlayers.length} 位玩家',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
