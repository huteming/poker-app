import 'package:flutter/material.dart';
import '../widgets/player_avatar.dart';
import '../widgets/score_type_selector.dart';
import '../widgets/player_selector.dart';
import '../widgets/bomb_score_selector.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final List<String> players = ['张', '李', '王', '赵', '钱', '孙'];
  final List<String> selectedPlayers = [];
  final Map<String, int> bombScores = {};
  String selectedScoreType = '常规胜负';

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
            onPressed:
                selectedPlayers.length == 4
                    ? () {
                      // TODO: 处理提交逻辑
                      Navigator.of(context).pop();
                    }
                    : null,
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
              players: players,
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
