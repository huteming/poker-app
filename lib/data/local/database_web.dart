import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

LazyDatabase createDriftDatabase() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      DriftWebStorage.indexedDb('poker_app.db'),
      logStatements: true, // 开发时可以打开日志
    );
  });
}
