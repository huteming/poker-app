import 'package:flutter/material.dart';

import 'package:poker/services/game_record_service.dart';
import 'package:poker/models/db_player.dart';
import 'package:poker/models/db_game_record.dart';
import 'package:poker/providers/player_provider.dart';

import 'package:poker/screens/game_detail_page/game_detail_page.dart';
import 'package:poker/screens/add_record_page/add_record_page.dart';
import 'package:poker/screens/add_player_page/add_player_page.dart';

import 'widgets/score_page_loading.dart';
import 'widgets/score_table_header.dart';
import 'widgets/score_table_row.dart';
import 'widgets/score_page_empty.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final PlayerProvider _playerProvider = PlayerProvider();
  final GameRecordService _gameRecordService = GameRecordService();
  List<Player> gamingPlayers = [];
  List<DbGameRecord> records = [];
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await _loadGameRecords();
    _loadPlayers();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadGameRecords() async {
    setState(() {
      _isRefreshing = true;
    });

    final pendingRecords = await _gameRecordService.getPendingRecords();

    setState(() {
      _isRefreshing = false;
      records = pendingRecords;
    });
  }

  void _loadPlayers() {
    if (records.isEmpty) {
      return;
    }

    final competingPlayers =
        records.expand((record) => record.getAllPlayerIds()).toSet().map((
          playerId,
        ) {
          return _playerProvider.players.firstWhere((p) => p.id == playerId);
        }).toList();

    setState(() {
      gamingPlayers = competingPlayers;
    });
  }

  void _onSettleRecords() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认结算'),
          content: const Text('确定要结算当前所有记录吗？结算后将不再显示在本页面。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确认结算', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _isRefreshing = true;
    });

    await _gameRecordService.settleAllPendingRecords();

    await _loadGameRecords();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('结算成功')));
    }
  }

  void _navigateToAddRecord() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddRecordPage(gamingPlayers: gamingPlayers),
      ),
    );

    if (result == null) {
      return;
    }

    if (result['success']) {
      setState(() {
        records.insert(0, result['newRecord']);
      });
    }
  }

  void _navigateToAddPlayer() async {
    final List<Player>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddPlayerPage(gamingPlayers: gamingPlayers),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      gamingPlayers.addAll(result);
    });
  }

  void _navigateToGameDetail(BuildContext context, DbGameRecord record) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameDetailPage(record: record)),
    );

    // 检查返回结果，如果是删除操作，刷新列表
    if (result == 'deleted') {
      await _loadGameRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ScorePageLoadingView();
    }

    if (gamingPlayers.isEmpty) {
      return ScorePageEmptyView(
        onPlayersAdded: (newPlayers) {
          setState(() {
            gamingPlayers = newPlayers;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('本局积分'),
        actions: [
          _isRefreshing
              ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: '刷新列表',
                onPressed: _loadData,
              ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: '更多选项',
            onSelected: (String value) {
              switch (value) {
                case 'add_player':
                  _navigateToAddPlayer();
                  break;
                case 'settle_all':
                  _onSettleRecords();
                  break;
                // 可以添加更多选项
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'add_player',
                    child: Row(
                      children: [
                        Icon(Icons.group_add, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('添加玩家'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'settle_all',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('结算本局'),
                      ],
                    ),
                  ),
                  // 可以在此处添加更多菜单项
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          ScoreTableHeader(players: gamingPlayers, records: records),
          Expanded(
            child:
                records.isEmpty
                    ? const Center(
                      child: Text(
                        '暂无记录',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        return ScoreTableRow(
                          players: gamingPlayers,
                          record: records[index],
                          rowIndex: index,
                          onTap:
                              () => _navigateToGameDetail(
                                context,
                                records[index],
                              ),
                        );
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
                ),
                onPressed: _navigateToAddRecord,
                child: const Text(
                  '添加新记录',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
