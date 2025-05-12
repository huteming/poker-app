import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../../utils/score_calculator.dart';
import '../../models/db_player.dart';
import 'widgets/game_result_selector.dart';
import 'widgets/player_selector.dart';
import 'widgets/bomb_score_selector.dart';
import '../../services/game_record_service.dart';

class AddRecordPage extends StatefulWidget {
  final List<Player> gamingPlayers;

  const AddRecordPage({super.key, required this.gamingPlayers});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  final GameRecordService _gameRecordService = GameRecordService();
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
    if (selectedPlayerIds.length != 4) {
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });

      final finalScores = createGameScores(
        gameResultType,
        selectedPlayerIds,
        bombScores,
      );

      final newRecord = await _gameRecordService.insertRecord(
        playerIds: selectedPlayerIds,
        bombScores: bombScores,
        finalScores: finalScores,
        gameResultType: gameResultType,
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
