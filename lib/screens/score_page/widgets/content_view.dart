import 'package:flutter/material.dart';
import '../../../models/player_score.dart';
import '../../../widgets/score_table_header.dart';
import '../../../widgets/score_table_row.dart';

/// 显示积分列表的主视图组件
class ScorePageContentView extends StatelessWidget {
  final List<PlayerScore> players;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final VoidCallback onAddRecord;
  final VoidCallback onNavigateToPlayersPage;
  final VoidCallback onNavigateToAddPlayer;
  final VoidCallback onSettleAll;
  final Function(int) onShowGameDetail;
  final Function(int) onDeleteRecord;

  const ScorePageContentView({
    super.key,
    required this.players,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onAddRecord,
    required this.onNavigateToPlayersPage,
    required this.onNavigateToAddPlayer,
    required this.onSettleAll,
    required this.onShowGameDetail,
    required this.onDeleteRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('本局积分'),
        actions: [
          isRefreshing
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
                onPressed: onRefresh,
              ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: '更多选项',
            onSelected: (String value) {
              switch (value) {
                case 'add_player':
                  onNavigateToAddPlayer();
                  break;
                case 'settle_all':
                  onSettleAll();
                  break;
                case 'view_players':
                  onNavigateToPlayersPage();
                  break;
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
                    value: 'view_players',
                    child: Row(
                      children: [
                        Icon(Icons.people, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('玩家列表'),
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
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          ScoreTableHeader(players: players),
          Expanded(
            child:
                players.first.scores.isEmpty
                    ? const Center(
                      child: Text(
                        '暂无记录',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: players.first.scores.length,
                      itemBuilder: (context, index) {
                        // 倒序显示记录
                        final reverseIndex =
                            players.first.scores.length - 1 - index;
                        return ScoreTableRow(
                          players: players,
                          rowIndex: reverseIndex,
                          onTap: () => onShowGameDetail(index),
                          onDelete: onDeleteRecord,
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
                onPressed: onAddRecord,
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
