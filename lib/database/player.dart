import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'player.g.dart';

// 1. 定义 Player 表
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatar => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}

// 2. 定义数据库
@DriftDatabase(tables: [Players])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
}

// 3. 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
