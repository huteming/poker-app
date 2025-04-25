import 'package:flutter/material.dart';
import '../models/game_record.dart';
import '../widgets/player_avatar.dart';
import '../models/db_game_record.dart';
import '../database/player_dao.dart';
import '../models/db_player.dart';
import '../database/game_record_dao.dart';

class GameDetailPage extends StatefulWidget {
  final GameRecord record;
  final int? recordId; // 数据库记录ID

  const GameDetailPage({Key? key, required this.record, this.recordId})
    : super(key: key);

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final PlayerDao _playerDao = PlayerDao();
  final GameRecordDao _gameRecordDao = GameRecordDao();
  List<Player> _players = [];
  bool _isLoading = true;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final players = await _playerDao.findAll();
      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 处理错误
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载玩家失败: $e')));
      }
    }
  }

  // 删除记录
  Future<void> _deleteRecord() async {
    // 如果有回调函数，优先使用它（这是在 score_page 中传入的，已修复）
    if (widget.record.onDelete != null) {
      widget.record.onDelete!();
      Navigator.of(context).pop('deleted');
      return;
    }

    // 如果没有回调但有 recordId，则使用 recordId 直接删除
    if (widget.recordId != null) {
      setState(() {
        _isDeleting = true;
      });

      try {
        await _gameRecordDao.deleteRecord(widget.recordId!);

        // 返回删除成功的结果
        Navigator.of(context).pop('deleted');

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('记录已成功删除')));
        }
      } catch (e) {
        setState(() {
          _isDeleting = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('删除记录失败: $e')));
        }
      }
    } else {
      // 没有 recordId 也没有回调，无法删除
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('无法删除记录：缺少记录ID')));
    }
  }

  // 获取玩家头像
  String _getPlayerAvatar(String playerId) {
    final player = _players.firstWhere(
      (p) => p.name == playerId,
      orElse:
          () =>
              Player(id: 0, name: playerId, avatar: playerId[0].toUpperCase()),
    );
    return player.avatar;
  }

  Widget _buildPlayerList(String title, List<PlayerGameRecord> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        ...players
            .map(
              (player) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    PlayerAvatar(
                      name: player.name,
                      isSelected: false,
                      avatarText: _getPlayerAvatar(player.name),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      (player.score >= 0 ? '+' : '') + player.score.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: player.score >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '炸弹：${player.bombScore?.toString() ?? '无'}分',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('第${widget.record.roundNumber}局详情')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('第${widget.record.roundNumber}局详情'),
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
              _buildPlayerList('胜方', widget.record.winners),
              const SizedBox(height: 32),
              _buildPlayerList('负方', widget.record.losers),
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
                      widget.record.gameType,
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
                '记录时间：${widget.record.playedAt.toString().substring(0, 16)}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
