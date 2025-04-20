import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final String _baseUrl = 'https://api.cloudflare.com/client/v4/accounts';

  // 测试数据库连接
  Future<bool> testConnection() async {
    try {
      final result = await executeQuery('SELECT 1');
      return result['success'] == true;
    } catch (e) {
      print('数据库连接测试失败: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> executeQuery(
    String sql, [
    List<dynamic>? params,
  ]) async {
    try {
      print('执行 SQL 查询: $sql');
      print('参数: $params');

      final url =
          '$_baseUrl/${DatabaseConfig.accountId}/d1/database/${DatabaseConfig.databaseId}/query';
      print('请求 URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${DatabaseConfig.apiToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'sql': sql, 'params': params ?? []}),
      );

      print('响应状态码: ${response.statusCode}');
      print('响应内容: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Database query failed: ${response.body}');
      }

      final responseJson = jsonDecode(response.body);
      if (!responseJson['success']) {
        throw Exception('Database query failed: ${responseJson['errors']}');
      }

      // Cloudflare D1 的响应格式是 result[0].results
      final result = responseJson['result'][0];
      print('解析后的响应: $result');

      return result;
    } catch (e) {
      print('数据库查询失败，详细错误: $e');
      print('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  // 创建表
  Future<void> createTables() async {
    try {
      // 玩家表
      await executeQuery('''
        CREATE TABLE IF NOT EXISTS players (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          avatar TEXT,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // 游戏记录表
      await executeQuery('''
        CREATE TABLE IF NOT EXISTS game_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          game_type TEXT NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // 玩家得分表
      await executeQuery('''
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

      print('表创建成功');
    } catch (e) {
      print('创建表失败: $e');
      rethrow;
    }
  }
}
