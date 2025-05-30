import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'app_database.g.dart';

part './extensions/game_record_extension.dart';

// 1. 定义 Player 表
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatar => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}

// 定义 GameRecords 表
class GameRecords extends Table {
  IntColumn get id => integer().autoIncrement()();

  // 玩家ID
  IntColumn get player1Id => integer()();
  IntColumn get player2Id => integer()();
  IntColumn get player3Id => integer()();
  IntColumn get player4Id => integer()();

  // 炸弹分数
  IntColumn get player1BombScore => integer()();
  IntColumn get player2BombScore => integer()();
  IntColumn get player3BombScore => integer()();
  IntColumn get player4BombScore => integer()();

  // 最终分数
  IntColumn get player1FinalScore => integer()();
  IntColumn get player2FinalScore => integer()();
  IntColumn get player3FinalScore => integer()();
  IntColumn get player4FinalScore => integer()();

  // 游戏结果类型和结算状态
  TextColumn get gameResultType => text()(); // DOUBLE_WIN, SINGLE_WIN, DRAW
  TextColumn get settlementStatus => text()(); // PENDING, SETTLED

  // 时间戳和备注
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get remarks => text().nullable()();
}

// 2. 定义数据库
@DriftDatabase(tables: [Players, GameRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onCreate: (Migrator m) {
  //       return m.createAll();
  //     },
  //     onUpgrade: (Migrator m, int from, int to) async {
  //       if (from < 2) {
  //         // 从版本1升级到版本2时，创建 game_records 表
  //         await m.createTable(gameRecords);
  //       }
  //     },
  //   );
  // }

  // 插入或更新玩家
  Future<void> insertOrUpdatePlayer(PlayersCompanion player) async {
    await into(players).insertOnConflictUpdate(player);
  }

  // 批量插入或更新玩家
  Future<void> insertOrUpdatePlayers(List<PlayersCompanion> playersList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(players, playersList);
    });
  }

  // 获取所有玩家
  Future<List<Player>> getAllPlayers() => select(players).get();

  // 根据 id 获取玩家
  Future<Player?> getPlayerById(int id) =>
      (select(players)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // 更新最后同步时间
  Future<void> updateLastSyncTime() async {
    await (update(players)..where(
      (tbl) => tbl.id.isNotNull(),
    )).write(PlayersCompanion(lastSyncAt: Value(DateTime.now())));
  }

  // 获取最后同步时间
  Future<DateTime?> getLastSyncTime() async {
    final query =
        select(players)
          ..orderBy([(t) => OrderingTerm.desc(t.lastSyncAt)])
          ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.lastSyncAt;
  }

  // 检查是否需要同步
  Future<bool> needsSync() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;
    return DateTime.now().difference(lastSync).inHours >= 1;
  }

  // GameRecords 相关方法
  // 插入游戏记录
  Future<int> insertGameRecord(GameRecordsCompanion record) async {
    return await into(gameRecords).insert(record);
  }

  // 批量插入游戏记录
  Future<void> insertGameRecords(List<GameRecordsCompanion> records) async {
    await batch((batch) {
      batch.insertAll(gameRecords, records);
    });
  }

  // 获取所有游戏记录
  Future<List<GameRecord>> getAllGameRecords() => select(gameRecords).get();

  // 根据ID获取游戏记录
  Future<GameRecord?> getGameRecordById(int id) =>
      (select(gameRecords)
        ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // 获取玩家的所有游戏记录
  Future<List<GameRecord>> getPlayerGameRecords(int playerId) {
    return (select(gameRecords)..where(
      (tbl) =>
          tbl.player1Id.equals(playerId) |
          tbl.player2Id.equals(playerId) |
          tbl.player3Id.equals(playerId) |
          tbl.player4Id.equals(playerId),
    )).get();
  }

  // 更新游戏记录
  Future<bool> updateGameRecord(GameRecordsCompanion record) async {
    return await (update(gameRecords)
          ..where((tbl) => tbl.id.equals(record.id.value))).write(record) >
        0;
  }

  // 删除游戏记录
  Future<bool> deleteGameRecord(int id) async {
    return await (delete(gameRecords)..where((tbl) => tbl.id.equals(id))).go() >
        0;
  }

  // 获取未结算的游戏记录
  Future<List<GameRecord>> getPendingGameRecords() =>
      (select(gameRecords)
        ..where((tbl) => tbl.settlementStatus.equals('PENDING'))).get();

  // 更新游戏记录结算状态
  Future<void> updateGameRecordSettlementStatus(int id, String status) async {
    await (update(gameRecords)..where((tbl) => tbl.id.equals(id))).write(
      GameRecordsCompanion(
        settlementStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 结算所有未结算的游戏记录
  Future<void> settleAllPendingRecords() async {
    final pendingRecords = await getPendingGameRecords();
    if (pendingRecords.isEmpty) return;

    await batch((batch) {
      for (final record in pendingRecords) {
        batch.update(
          gameRecords,
          GameRecordsCompanion(
            settlementStatus: const Value('SETTLED'),
            updatedAt: Value(DateTime.now()),
          ),
          where: (tbl) => tbl.id.equals(record.id),
        );
      }
    });
  }
}

// 3. 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
