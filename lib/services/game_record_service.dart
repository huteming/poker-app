import 'package:logging/logging.dart';
import 'package:poker/models/db_game_record.dart';
import 'package:poker/models/player_statistics.dart';
import 'package:poker/utils/message.dart';
import 'package:poker/utils/api_client.dart';
import 'package:poker/models/api_error_response.dart';

class GameRecordService extends ApiClient {
  static final GameRecordService _instance = GameRecordService._internal();
  factory GameRecordService() => _instance;
  GameRecordService._internal();

  final _log = Logger('GameRecordService');
  final _message = Message();

  Future<List<DbGameRecord>> getPendingRecords() async {
    try {
      final response = await get<List<dynamic>>('/game-records/pending');
      final records =
          response.data.map((map) => DbGameRecord.fromMap(map)).toList();
      _log.info('获取待结算游戏记录: ${records.length}条');

      return records;
    } on ApiErrorResponse catch (e) {
      _message.showError('获取待结算记录失败: ${e.message}');
      return [];
    }
  }

  Future<DbGameRecord> insertRecord({
    required List<int> playerIds,
    required Map<int, int> bombScores,
    required List<int> finalScores,
    required String gameResultType,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/game-records',
        body: {
          'player1_id': playerIds[0],
          'player2_id': playerIds[1],
          'player3_id': playerIds[2],
          'player4_id': playerIds[3],
          'player1_bomb_score': bombScores[playerIds[0]],
          'player2_bomb_score': bombScores[playerIds[1]],
          'player3_bomb_score': bombScores[playerIds[2]],
          'player4_bomb_score': bombScores[playerIds[3]],
          'player1_final_score': finalScores[0],
          'player2_final_score': finalScores[1],
          'player3_final_score': finalScores[2],
          'player4_final_score': finalScores[3],
          'game_result_type': gameResultType,
        },
      );

      _message.showSuccess('记录已成功保存');

      final record = DbGameRecord.fromMap(response.data);
      return record;
    } on ApiErrorResponse catch (e) {
      _message.showError('保存记录失败: ${e.message}');
      rethrow;
    }
  }

  Future<bool> deleteRecord(int recordId) async {
    try {
      final response = await delete('/game-records/$recordId');
      return response.data;
    } on ApiErrorResponse catch (e) {
      _message.showError('删除记录失败: ${e.message}');
      rethrow;
    }
  }

  Future<bool> settleAllPendingRecords() async {
    try {
      final response = await patch('/game-records/settle-all');
      return response.data;
    } on ApiErrorResponse catch (e) {
      _message.showError('结算所有记录失败: ${e.message}');
      rethrow;
    }
  }

  Future<List<PlayerStatistics>> getAllPlayerStatistics() async {
    try {
      final response = await get<List<dynamic>>('/game-records/player-stats');
      final stats =
          response.data
              .map(
                (map) => PlayerStatistics(
                  playerId: map['player_id'],
                  playerName: map['player_name'],
                  totalGames: map['total_games'],
                  wins: map['wins'],
                  totalScore: map['total_score'],
                  winRate: (map['win_rate'] as num).toDouble(),
                  rank: map['rank'],
                ),
              )
              .toList();

      _log.info('获取所有玩家统计信息: ${stats.length}条');
      return stats;
    } on ApiErrorResponse catch (e) {
      _message.showError('获取所有玩家统计信息失败: ${e.message}');
      return [];
    }
  }
}
