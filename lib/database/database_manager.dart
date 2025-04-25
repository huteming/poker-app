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

  // 初始化数据库
  Future<void> initialize() async {
    try {
      await GameRecordMigration.createTable(this);
      await GameRecordMigration.createIndexes(this);
      await _verifyTableStructure();
      log('数据库初始化成功');
    } catch (e) {
      log('数据库初始化失败: $e');
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
