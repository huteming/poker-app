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
      // 首先检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，可能需要执行数据库迁移');
        return [];
      }

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
      return [];
    }
  }

  Future<int> insertRecord(
    String gameType,
    List<String> playerIds,
    Map<String, int> scores,
    Map<String, int> bombScores,
  ) async {
    try {
      // 检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，无法插入记录');
        return 0;
      }

      if (playerIds.length != 4) {
        log('插入记录失败: 需要正好4名玩家');
        return 0;
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
      return 0;
    }
  }

  Future<bool> deleteRecord(int id) async {
    try {
      // 检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，无法删除记录');
        return false;
      }

      await _db.execute('DELETE FROM game_records WHERE id = ?', [id]);

      // 删除后清除缓存
      _cachedRecords = null;
      return true;
    } catch (e) {
      log('删除游戏记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      return false;
    }
  }

  Future<int> settleAllPendingRecords() async {
    try {
      // 检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，无法结算记录');
        return 0;
      }

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
      return 0;
    }
  }

  Future<List<DbGameRecord>> getPlayerRecords(String playerName) async {
    try {
      // 检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，无法获取玩家记录');
        return [];
      }

      // 查询包含该玩家的所有游戏记录
      final res = await _db.execute(
        '''
        SELECT * FROM game_records 
        WHERE 
          player1_id = ? OR 
          player2_id = ? OR 
          player3_id = ? OR 
          player4_id = ?
        ORDER BY created_at DESC
        ''',
        [playerName, playerName, playerName, playerName],
      );
      final List<dynamic> results = res['results'] ?? [];

      return results.map((map) => DbGameRecord.fromMap(map)).toList();
    } catch (e) {
      log('获取玩家对局记录失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      return [];
    }
  }

  Future<Map<String, dynamic>> getPlayerStatistics(String playerName) async {
    try {
      // 检查表是否存在
      final tableExists = await _db.tableExists('game_records');
      if (!tableExists) {
        log('游戏记录表不存在，无法获取玩家统计信息');
        return {
          'totalGames': 0,
          'wins': 0,
          'winRate': 0.0,
          'totalScore': 0,
          'totalBombScore': 0,
        };
      }

      // 查询包含该玩家的所有游戏记录（包括已结算和未结算的）
      final res = await _db.execute(
        '''
        SELECT 
          COUNT(*) as total_games,
          SUM(CASE 
            WHEN (player1_id = ? AND player1_final_score > 0) OR
                 (player2_id = ? AND player2_final_score > 0) OR
                 (player3_id = ? AND player3_final_score > 0) OR
                 (player4_id = ? AND player4_final_score > 0)
            THEN 1 ELSE 0 END) as wins,
          SUM(CASE 
            WHEN player1_id = ? THEN player1_final_score
            WHEN player2_id = ? THEN player2_final_score
            WHEN player3_id = ? THEN player3_final_score
            WHEN player4_id = ? THEN player4_final_score
            ELSE 0 END) as total_score,
          SUM(CASE 
            WHEN player1_id = ? THEN player1_bomb_score
            WHEN player2_id = ? THEN player2_bomb_score
            WHEN player3_id = ? THEN player3_bomb_score
            WHEN player4_id = ? THEN player4_bomb_score
            ELSE 0 END) as total_bomb_score
        FROM game_records 
        WHERE 
          player1_id = ? OR 
          player2_id = ? OR 
          player3_id = ? OR 
          player4_id = ?
        ''',
        [
          playerName, playerName, playerName, playerName, // 胜场计算
          playerName, playerName, playerName, playerName, // 总分计算
          playerName, playerName, playerName, playerName, // 炸弹分计算
          playerName, playerName, playerName, playerName, // WHERE 条件
        ],
      );

      final List<dynamic> results = res['results'] ?? [];

      if (results.isEmpty) {
        return {
          'totalGames': 0,
          'wins': 0,
          'winRate': 0.0,
          'totalScore': 0,
          'totalBombScore': 0,
        };
      }

      final data = results[0];
      final int totalGames = data['total_games'] ?? 0;
      final int wins = data['wins'] ?? 0;
      final double winRate = totalGames > 0 ? wins / totalGames : 0.0;
      final int totalScore = data['total_score'] ?? 0;
      final int totalBombScore = data['total_bomb_score'] ?? 0;

      return {
        'totalGames': totalGames,
        'wins': wins,
        'winRate': winRate,
        'totalScore': totalScore,
        'totalBombScore': totalBombScore,
      };
    } catch (e) {
      log('获取玩家统计信息失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      return {
        'totalGames': 0,
        'wins': 0,
        'winRate': 0.0,
        'totalScore': 0,
        'totalBombScore': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAllPlayersStatistics() async {
    try {
      // 获取所有玩家
      final playersRes = await _db.execute('SELECT DISTINCT name FROM players');
      final List<dynamic> playersResults = playersRes['results'] ?? [];

      final List<Map<String, dynamic>> result = [];

      // 为每个玩家计算统计信息
      for (var player in playersResults) {
        final playerName = player['name'];
        if (playerName == null) continue;

        final stats = await getPlayerStatistics(playerName);
        result.add({'playerName': playerName, ...stats});
      }

      // 按总分排序
      result.sort(
        (a, b) => (b['totalScore'] as int).compareTo(a['totalScore'] as int),
      );

      // 添加排名
      for (int i = 0; i < result.length; i++) {
        result[i]['rank'] = i + 1;
      }

      return result;
    } catch (e) {
      log('获取所有玩家统计信息失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      return [];
    }
  }

  bool isCacheValid() {
    return _cachedRecords != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
