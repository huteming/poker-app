import 'package:flutter/material.dart';
import '../widgets/player_avatar.dart';
import '../widgets/score_type_selector.dart';
import '../widgets/player_selector.dart';
import '../widgets/bomb_score_selector.dart';
import '../utils/score_calculator.dart';
import '../models/player_score.dart';

class AddRecordPage extends StatefulWidget {
  final List<PlayerScore> players;

  const AddRecordPage({Key? key, required this.players}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final List<String> selectedPlayers = [];
  final Map<String, int> bombScores = {};
  String selectedScoreType = '双扣';

  void _handlePlayerSelection(List<String> selected) {
    setState(() {
      // 移除不再选中的玩家的炸弹分数
      bombScores.removeWhere((player, _) => !selected.contains(player));
      selectedPlayers.clear();
      selectedPlayers.addAll(selected);
    });
  }

  void _handleBombScoreChange(String player, int score) {
    setState(() {
      bombScores[player] = score;
    });
  }

  void _handleSubmit() {
    if (selectedPlayers.length != 4) return;

    try {
      final scores = createGameScores(
        selectedScoreType,
        selectedPlayers,
        bombScores,
      );

      // 返回完整的记录信息
      Navigator.of(context).pop({
        'scores': scores,
        'bombScores': bombScores,
        'gameType': selectedScoreType,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('计算积分时出错：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('添加新记录'),
        actions: [
          TextButton(
            onPressed: selectedPlayers.length == 4 ? _handleSubmit : null,
            child: Text(
              '确认提交',
              style: TextStyle(
                color:
                    selectedPlayers.length == 4 ? Colors.purple : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '选择4名玩家（前2人为赢家）',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            PlayerSelector(
              players: widget.players.map((p) => p.name).toList(),
              selectedPlayers: selectedPlayers,
              onSelectionChanged: _handlePlayerSelection,
            ),
            if (selectedPlayers.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  '选择炸弹积分',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              BombScoreSelector(
                selectedPlayers: selectedPlayers,
                bombScores: bombScores,
                onScoreChanged: _handleBombScoreChange,
              ),
            ],
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '胜负类型',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            ScoreTypeSelector(
              selectedType: selectedScoreType,
              onTypeChanged: (type) {
                setState(() {
                  selectedScoreType = type;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
