import 'package:flutter/material.dart';
import '../models/player.dart';
import '../widgets/player_selection_list.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({Key? key}) : super(key: key);

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  List<Player> selectedPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择玩家')),
      body: Column(
        children: [
          Expanded(
            child: PlayerSelectionList(
              selectedPlayers: selectedPlayers,
              onPlayersSelected: (players) {
                setState(() {
                  selectedPlayers = players;
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
                    selectedPlayers.isEmpty
                        ? null
                        : () {
                          Navigator.of(context).pop(selectedPlayers);
                        },
                child: Text(
                  selectedPlayers.isEmpty
                      ? '请选择玩家'
                      : '确认添加 ${selectedPlayers.length} 位玩家',
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
