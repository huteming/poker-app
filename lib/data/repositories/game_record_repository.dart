import 'package:poker/data/local/app_database.dart';
import 'package:poker/data/remote/services/game_record_service.dart';
import 'package:poker/domains/game_record_entity.dart';

class GameRecordRepository {
  final AppDatabase _db = AppDatabase();
  final GameRecordService _gameRecordService = GameRecordService();

  Future<List<GameRecordEntity>> getPendingRecords() async {
    // 优先从本地获取
    final localRecords = await _db.getPendingGameRecords();
    if (localRecords.isNotEmpty) {
      return localRecords
          .map((record) => GameRecordEntity.fromLocal(record))
          .toList();
    }

    // 本地无数据从远程获取
    final remoteRecords = await _gameRecordService.getPendingRecords();
    final records =
        remoteRecords
            .map((record) => GameRecordEntity.fromRemote(record))
            .toList();

    // 将远程数据转换为本地数据库格式并缓存
    await _db.insertGameRecords(
      records.map((record) => record.toGameRecordsCompanion()).toList(),
    );

    return records;
  }

  /// 插入新的游戏记录
  Future<GameRecordEntity> insertRecord(GameRecordEntity entity) async {
    try {
      // 1. 先保存到本地数据库
      final localId = await _db.insertGameRecord(
        entity.toGameRecordsCompanion(),
      );

      // 2. 尝试从本地数据库获取记录
      final localRecord = await _db.getGameRecordById(localId);

      if (localRecord == null) {
        throw Exception('插入游戏记录失败');
      }

      // 3. 尝试同步到远程服务器
      _gameRecordService.insertRecord(entity.toGameRecordCreateDto());

      return GameRecordEntity.fromLocal(localRecord);
    } catch (e) {
      throw Exception('Failed to insert game record: $e');
    }
  }
}
