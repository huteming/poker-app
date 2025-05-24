import 'package:logging/logging.dart';
import 'package:poker/domains/game_record_entity.dart';
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

  Future<List<dynamic>> getPendingRecords() async {
    try {
      final response = await get<List<dynamic>>('/game-records/pending');
      final records = response.data;

      _log.info('获取待结算游戏记录: ${records.length}条');

      return records;
    } on ApiErrorResponse catch (e) {
      _message.showError('获取待结算记录失败: ${e.message}');
      return [];
    }
  }

  Future<GameRecordEntity> insertRecord(GameRecordCreateDto dto) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/game-records',
        body: dto,
      );

      _message.showSuccess('记录已成功保存');

      final newRecord = GameRecordEntity.fromRemote(response.data);
      return newRecord;
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
