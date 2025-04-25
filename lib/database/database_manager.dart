import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';
import 'game_record_migration.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  final String _baseUrl = 'https://api.cloudflare.com/client/v4/accounts';

  // 检查表是否存在
  Future<bool> tableExists(String tableName) async {
    try {
      final result = await execute(
        '''
        SELECT name FROM sqlite_master 
        WHERE type='table' AND name=?
      ''',
        [tableName],
      );
      return (result['results'] as List).isNotEmpty;
    } catch (e) {
      log('检查表是否存在失败: $e');
      return false;
    }
  }

  // 获取表结构
  Future<List<Map<String, dynamic>>> getTableStructure(String tableName) async {
    try {
      final result = await execute('''
        PRAGMA table_info($tableName)
      ''');
      return (result['results'] as List).cast<Map<String, dynamic>>();
    } catch (e) {
      log('获取表结构失败: $e');
      return [];
    }
  }

  // 初始化数据库
  Future<void> initialize() async {
    try {
      final exists = await tableExists('game_records');
      if (!exists) {
        await GameRecordMigration.createTable(this);
        await GameRecordMigration.createIndexes(this);
        log('创建新表成功');
      } else {
        await _migrateTable();
        log('表迁移成功');
      }
      await _verifyTableStructure();
      log('数据库初始化成功');
    } catch (e) {
      log('数据库初始化失败: $e');
      rethrow;
    }
  }

  // 迁移表结构
  Future<void> _migrateTable() async {
    try {
      final columns = await getTableStructure('game_records');
      final columnNames = columns.map((c) => c['name'] as String).toSet();

      // 删除不需要的列
      if (columnNames.contains('winner1_id')) {
        await execute('ALTER TABLE game_records DROP COLUMN winner1_id');
      }
      if (columnNames.contains('winner2_id')) {
        await execute('ALTER TABLE game_records DROP COLUMN winner2_id');
      }
      if (columnNames.contains('winning_team')) {
        await execute('ALTER TABLE game_records DROP COLUMN winning_team');
      }

      // 添加缺失的列
      if (!columnNames.contains('player1_id')) {
        await execute(
          'ALTER TABLE game_records ADD COLUMN player1_id TEXT NOT NULL DEFAULT ""',
        );
      }
      if (!columnNames.contains('player2_id')) {
        await execute(
          'ALTER TABLE game_records ADD COLUMN player2_id TEXT NOT NULL DEFAULT ""',
        );
      }
      if (!columnNames.contains('player3_id')) {
        await execute(
          'ALTER TABLE game_records ADD COLUMN player3_id TEXT NOT NULL DEFAULT ""',
        );
      }
      if (!columnNames.contains('player4_id')) {
        await execute(
          'ALTER TABLE game_records ADD COLUMN player4_id TEXT NOT NULL DEFAULT ""',
        );
      }

      // 创建缺失的索引
      await execute('''
        CREATE INDEX IF NOT EXISTS idx_game_records_player1_id ON game_records(player1_id);
        CREATE INDEX IF NOT EXISTS idx_game_records_player2_id ON game_records(player2_id);
        CREATE INDEX IF NOT EXISTS idx_game_records_player3_id ON game_records(player3_id);
        CREATE INDEX IF NOT EXISTS idx_game_records_player4_id ON game_records(player4_id);
      ''');

      log('表迁移完成');
    } catch (e) {
      log('表迁移失败: $e');
      rethrow;
    }
  }

  // 验证表结构
  Future<void> _verifyTableStructure() async {
    try {
      final result = await execute('''
        PRAGMA table_info(game_records)
      ''');

      if (result['results'] == null || (result['results'] as List).isEmpty) {
        throw Exception('表结构验证失败：无法获取表信息');
      }

      final columns = result['results'] as List;
      log('表结构验证成功，共 ${columns.length} 个字段');

      // 打印表结构信息
      for (var column in columns) {
        log(
          '字段: ${column['name']}, 类型: ${column['type']}, 非空: ${column['notnull'] == 1}',
        );
      }
    } catch (e) {
      log('表结构验证失败: $e');
      rethrow;
    }
  }

  // 测试数据库连接
  Future<bool> testConnection() async {
    try {
      final result = await execute('SELECT 1');
      return result['success'] == true;
    } catch (e) {
      log('数据库连接测试失败: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> execute(
    String sql, [
    List<dynamic>? params,
  ]) async {
    try {
      final url =
          '$_baseUrl/${DatabaseConfig.accountId}/d1/database/${DatabaseConfig.databaseId}/query';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${DatabaseConfig.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'sql': sql, 'params': params ?? []}),
      );

      if (response.statusCode != 200) {
        throw Exception('Database query failed: ${response.body}');
      }

      final responseJson = jsonDecode(response.body);
      if (!responseJson['success']) {
        throw Exception('Database query failed: ${responseJson['errors']}');
      }

      // Cloudflare D1 的响应格式是 result[0].results
      final result = responseJson['result'][0];

      return result;
    } catch (e) {
      log('数据库查询失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }
}
