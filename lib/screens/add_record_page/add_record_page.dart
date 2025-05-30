import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:poker/data/repositories/game_record_repository.dart';
import 'package:poker/domains/game_record_entity.dart';
import 'package:poker/domains/player_entity.dart';

import 'widgets/game_result_selector.dart';
import 'widgets/player_selector.dart';
import 'widgets/bomb_score_selector.dart';

import '../../utils/score_calculator.dart';

class AddRecordPage extends StatefulWidget {
  final List<PlayerEntity> gamingPlayers;

  const AddRecordPage({super.key, required this.gamingPlayers});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final GameRecordRepository _gameRecordRepository = GameRecordRepository();

  final Logger log = Logger('AddRecordPage');

  List<int> selectedPlayerIds = [];
  Map<int, int> bombScores = {};
  // DOUBLE_WIN, SINGLE_WIN, DRAW
  String gameResultType = 'DOUBLE_WIN';
  bool _isSubmitting = false;

  void _onSelectedPlayerIdsChange(List<int> newSelectedPlayerIds) {
    setState(() {
      selectedPlayerIds = newSelectedPlayerIds;

      final Map<int, int> newBombScores = {};
      for (var playerId in selectedPlayerIds) {
        newBombScores[playerId] = bombScores[playerId] ?? 4;
      }

      bombScores = newBombScores;
    });
  }

  void _onBombScoreChange(int playerId, int score) {
    setState(() {
      bombScores[playerId] = score;
    });
  }

  Future<void> _onSubmit() async {
    try {
      setState(() {
        _isSubmitting = true;
      });

      final finalScores = createGameScores(
        gameResultType,
        selectedPlayerIds,
        bombScores,
      );

      final newRecord = await _gameRecordRepository.insertRecord(
        GameRecordEntity.create(
          player1Id: selectedPlayerIds[0],
          player2Id: selectedPlayerIds[1],
          player3Id: selectedPlayerIds[2],
          player4Id: selectedPlayerIds[3],
          player1BombScore: bombScores[selectedPlayerIds[0]] ?? 4,
          player2BombScore: bombScores[selectedPlayerIds[1]] ?? 4,
          player3BombScore: bombScores[selectedPlayerIds[2]] ?? 4,
          player4BombScore: bombScores[selectedPlayerIds[3]] ?? 4,
          player1FinalScore: finalScores[0],
          player2FinalScore: finalScores[1],
          player3FinalScore: finalScores[2],
          player4FinalScore: finalScores[3],
          gameResultType: gameResultType,
        ),
      );

      if (mounted) {
        Navigator.of(context).pop({'success': true, 'newRecord': newRecord});
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
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
              onPressed: _onSubmit,
              child: Text(
                '确认提交',
                style: TextStyle(
                  color:
                      selectedPlayerIds.length == 4
                          ? Colors.purple
                          : Colors.grey,
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
              players: widget.gamingPlayers,
              selectedPlayerIds: selectedPlayerIds,
              onChanged: _onSelectedPlayerIdsChange,
            ),
            if (selectedPlayerIds.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  '选择炸弹积分',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              BombScoreSelector(
                selectedPlayerIds: selectedPlayerIds,
                bombScores: bombScores,
                onChanged: _onBombScoreChange,
              ),
            ],
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '胜负类型',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            GameResultSelector(
              gameResultType: gameResultType,
              onGameResultTypeChanged: (type) {
                setState(() {
                  gameResultType = type;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
