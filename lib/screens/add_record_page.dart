import 'package:flutter/material.dart';
import '../widgets/player_avatar.dart';
import '../widgets/score_type_selector.dart';
import '../widgets/player_selector.dart';
import '../widgets/bomb_score_selector.dart';
import '../utils/score_calculator.dart';
import '../models/player_score.dart';
import '../models/db_player.dart';
import '../database/game_record_dao.dart';

class AddRecordPage extends StatefulWidget {
  final List<dynamic> players;

  const AddRecordPage({Key? key, required this.players}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final List<String> selectedPlayers = [];
  final Map<String, int> bombScores = {};
  String selectedScoreType = '双扣';
  final GameRecordDao _gameRecordDao = GameRecordDao();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

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

  Future<void> _handleSubmit() async {
    if (selectedPlayers.length != 4) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final scores = createGameScores(
        selectedScoreType,
        selectedPlayers,
        bombScores,
      );

      // 直接保存到数据库
      await _gameRecordDao.insertRecord(
        selectedScoreType,
        selectedPlayers,
        scores,
        bombScores,
      );

      // 返回成功结果
      if (mounted) {
        Navigator.of(context).pop({'success': true});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('保存记录失败：$e')));
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 提取所有玩家名称
    final playerNames =
        widget.players
            .map((p) {
              if (p is PlayerScore) {
                return p.name;
              } else if (p is Player) {
                return p.name;
              }
              return '';
            })
            .where((name) => name.isNotEmpty)
            .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('添加新记录'),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
              ),
            )
          else
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
              players: playerNames,
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
