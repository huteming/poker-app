import 'database_service.dart';

class DatabaseMigrationService {
  static final DatabaseMigrationService _instance =
      DatabaseMigrationService._internal();
  factory DatabaseMigrationService() => _instance;
  DatabaseMigrationService._internal();

  final DatabaseService _databaseService = DatabaseService();

  Future<void> initialize() async {
    try {
      // 检查数据库连接
      final isConnected = await _databaseService.testConnection();
      if (!isConnected) {
        throw Exception('数据库连接失败');
      }

      // 创建版本控制表
      await _createVersionTable();

      // 获取当前版本
      final currentVersion = await _getCurrentVersion();

      // 执行迁移
      await _migrate(currentVersion);

      print('数据库初始化成功，当前版本: $currentVersion');
    } catch (e) {
      print('数据库初始化失败: $e');
      rethrow;
    }
  }

  Future<void> _createVersionTable() async {
    await _databaseService.executeQuery('''
      CREATE TABLE IF NOT EXISTS db_version (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        version INTEGER NOT NULL,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<int> _getCurrentVersion() async {
    final result = await _databaseService.executeQuery(
      'SELECT version FROM db_version ORDER BY id DESC LIMIT 1',
    );

    final List<dynamic> results = result['results'] ?? [];
    if (results.isEmpty) {
      // 如果没有版本记录，插入初始版本 1
      await _databaseService.executeQuery(
        'INSERT INTO db_version (version) VALUES (?)',
        [1],
      );
      return 1;
    }

    return results[0]['version'] as int;
  }

  Future<void> _migrate(int currentVersion) async {
    // 根据当前版本执行相应的迁移
    switch (currentVersion) {
      case 1:
        await _migrateToV1();
        break;
      // 未来可以添加更多版本的迁移
      // case 2:
      //   await _migrateToV2();
      //   break;
    }
  }

  Future<void> _migrateToV1() async {
    // 创建初始表结构
    await _databaseService.executeQuery('''
      CREATE TABLE IF NOT EXISTS players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        avatar TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await _databaseService.executeQuery('''
      CREATE TABLE IF NOT EXISTS game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_type TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await _databaseService.executeQuery('''
      CREATE TABLE IF NOT EXISTS player_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        game_record_id INTEGER NOT NULL,
        score INTEGER NOT NULL,
        bomb_count INTEGER DEFAULT 0,
        FOREIGN KEY (player_id) REFERENCES players (id),
        FOREIGN KEY (game_record_id) REFERENCES game_records (id)
      )
    ''');
  }
}
