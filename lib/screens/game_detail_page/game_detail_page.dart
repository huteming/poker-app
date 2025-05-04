import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/db_game_record.dart';
import '../../models/db_player.dart';
import '../../providers/player_provider.dart';
import 'widgets/player_detail_row.dart';
import '../../services/game_record_service.dart';

class GameDetailPage extends StatefulWidget {
  final DbGameRecord record;

  const GameDetailPage({super.key, required this.record});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final GameRecordService _gameRecordService = GameRecordService();
  late PlayerProvider _playerProvider;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _playerProvider = Provider.of<PlayerProvider>(context, listen: false);
  }

  Player get _player1 =>
      _playerProvider.findPlayerById(widget.record.player1Id);
  Player get _player2 =>
      _playerProvider.findPlayerById(widget.record.player2Id);
  Player get _player3 =>
      _playerProvider.findPlayerById(widget.record.player3Id);
  Player get _player4 =>
      _playerProvider.findPlayerById(widget.record.player4Id);

  Future<void> _deleteRecord() async {
    setState(() {
      _isDeleting = true;
    });

    final int id = widget.record.id;
    final success = await _gameRecordService.deleteRecord(id);

    setState(() {
      _isDeleting = false;
    });

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除记录失败')));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('删除记录成功')));

    Navigator.of(context).pop({'success': true, 'id': id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
        actions: [
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('确认删除'),
                        content: const Text('确定要删除这条记录吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _deleteRecord();
                            },
                            child: const Text(
                              '删除',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('删除记录', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '胜方',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  PlayerDetailRow(
                    player: _player1,
                    finalScore: widget.record.player1FinalScore,
                    bombScore: widget.record.player1BombScore,
                  ),
                  PlayerDetailRow(
                    player: _player2,
                    finalScore: widget.record.player2FinalScore,
                    bombScore: widget.record.player2BombScore,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '败方',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  PlayerDetailRow(
                    player: _player3,
                    finalScore: widget.record.player3FinalScore,
                    bombScore: widget.record.player3BombScore,
                  ),
                  PlayerDetailRow(
                    player: _player4,
                    finalScore: widget.record.player4FinalScore,
                    bombScore: widget.record.player4BombScore,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    '胜负类型',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.record.getGameResultTypeText(),
                      style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '记录时间：${widget.record.createdAt.toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
