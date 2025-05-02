import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:poker/models/db_game_record.dart';
import 'package:poker/models/player_statistics.dart';
import 'base_service.dart';

class GameRecordService extends BaseService {
  static final GameRecordService _instance = GameRecordService._internal();
  factory GameRecordService() => _instance;
  GameRecordService._internal();

  final log = Logger('GameRecordService');

  Future<List<DbGameRecord>> getPendingRecords() async {
    try {
      final response = await get('/game-records/pending');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        final records = data.map((map) => DbGameRecord.fromMap(map)).toList();
        log.info('获取待结算游戏记录: ${records.length}条');
        return records;
      } else {
        log.warning('获取待结算游戏记录失败，状态码: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log.warning('获取待结算游戏记录时发生错误: $e');
      return [];
    }
  }

  Future<int> insertRecord({
    required List<int> playerIds,
    required Map<int, int> bombScores,
    required List<int> finalScores,
    required String gameResultType,
  }) async {
    try {
      final response = await post(
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

      if (response.statusCode == 201) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(responseBody);
        return data['id'] as int;
      } else {
        log.warning('插入游戏记录失败，状态码: ${response.statusCode}');
        throw Exception('插入游戏记录失败');
      }
    } catch (e) {
      log.warning('插入游戏记录时发生错误: $e');
      rethrow;
    }
  }

  Future<bool> deleteRecord(int recordId) async {
    try {
      final response = await delete('/game-records/$recordId');

      if (response.statusCode == 200) {
        log.info('成功删除游戏记录: $recordId');
        return true;
      } else {
        log.warning('删除游戏记录失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log.warning('删除游戏记录时发生错误: $e');
      return false;
    }
  }

  Future<bool> settleAllPendingRecords() async {
    try {
      final response = await patch('/game-records/settle-all');

      if (response.statusCode == 200) {
        log.info('成功结算所有待结算游戏记录');
        return true;
      } else {
        log.warning('结算所有待结算游戏记录失败，状态码: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log.warning('结算所有待结算游戏记录时发生错误: $e');
      return false;
    }
  }

  Future<List<PlayerStatistics>> getAllPlayerStatistics() async {
    try {
      final response = await get('/game-records/player-stats');
      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        final stats =
            data
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

        log.info('获取所有玩家统计信息: ${stats.length}条');
        return stats;
      } else {
        log.warning('获取玩家统计信息失败，状态码: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log.warning('获取玩家统计信息时发生错误: $e');
      return [];
    }
  }
}
