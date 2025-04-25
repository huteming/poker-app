import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';

import '../models/db_game_record.dart';
import 'database_manager.dart';

class GameRecordDao {
  static final GameRecordDao _instance = GameRecordDao._internal();
  factory GameRecordDao() => _instance;
  GameRecordDao._internal();

  final DatabaseManager _db = DatabaseManager();
  final _uuid = Uuid();

  // 缓存相关
  List<DbGameRecord>? _cachedRecords;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  Future<List<DbGameRecord>> getPendingRecords() async {
    if (isCacheValid()) {
      return _cachedRecords!;
    }

    try {
      final res = await _db.execute(
        'SELECT * FROM game_records WHERE settlement_status = "PENDING" ORDER BY created_at DESC',
      );
      final List<dynamic> results = res['results'] ?? [];

      _cachedRecords = results.map((map) => DbGameRecord.fromMap(map)).toList();
      _lastCacheTime = DateTime.now();
      return _cachedRecords!;
    } catch (e) {
      log('获取游戏记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<int> insertRecord(
    String gameType,
    List<String> playerIds,
    Map<String, int> scores,
    Map<String, int> bombScores,
  ) async {
    try {
      if (playerIds.length != 4) {
        throw ArgumentError('需要正好4名玩家');
      }

      final now = DateTime.now();

      // 确定游戏结果类型
      String gameResultType;
      int winnerCount = scores.values.where((score) => score > 0).length;
      if (winnerCount == 2) {
        gameResultType = 'DOUBLE_WIN';
      } else if (winnerCount == 1) {
        gameResultType = 'SINGLE_WIN';
      } else {
        gameResultType = 'DRAW';
      }

      final res = await _db.execute(
        '''
        INSERT INTO game_records (
          game_id, created_at, 
          player1_id, player2_id, player3_id, player4_id,
          player1_bomb_score, player2_bomb_score, player3_bomb_score, player4_bomb_score,
          game_result_type,
          player1_final_score, player2_final_score, player3_final_score, player4_final_score,
          settlement_status, updated_at, remarks
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          _uuid.v4(),
          now.toIso8601String(),
          playerIds[0],
          playerIds[1],
          playerIds[2],
          playerIds[3],
          bombScores[playerIds[0]] ?? 0,
          bombScores[playerIds[1]] ?? 0,
          bombScores[playerIds[2]] ?? 0,
          bombScores[playerIds[3]] ?? 0,
          gameResultType,
          scores[playerIds[0]] ?? 0,
          scores[playerIds[1]] ?? 0,
          scores[playerIds[2]] ?? 0,
          scores[playerIds[3]] ?? 0,
          'PENDING',
          now.toIso8601String(),
          '${gameType}游戏',
        ],
      );

      // 插入后清除缓存
      _cachedRecords = null;

      return res['lastInsertRowId'] ?? 0;
    } catch (e) {
      log('插入游戏记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await _db.execute('DELETE FROM game_records WHERE id = ?', [id]);

      // 删除后清除缓存
      _cachedRecords = null;
    } catch (e) {
      log('删除游戏记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<int> settleAllPendingRecords() async {
    try {
      final now = DateTime.now();
      final res = await _db.execute(
        '''
        UPDATE game_records 
        SET settlement_status = 'COMPLETED', updated_at = ? 
        WHERE settlement_status = 'PENDING'
        ''',
        [now.toIso8601String()],
      );

      // 更新后清除缓存
      _cachedRecords = null;

      return res['rowsAffected'] ?? 0;
    } catch (e) {
      log('结算游戏记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  bool isCacheValid() {
    return _cachedRecords != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
