import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../config/database_config.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();

  final String _baseUrl = 'https://api.cloudflare.com/client/v4/accounts';

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
