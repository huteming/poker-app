import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseManager {
  final String accountId;
  final String apiToken;
  final String databaseId;
  final String baseUrl = 'https://api.cloudflare.com/client/v4';

  DatabaseManager({
    required this.accountId,
    required this.apiToken,
    required this.databaseId,
  });

  Future<Map<String, dynamic>> execute(
    String sql, [
    List<dynamic>? params,
  ]) async {
    final response = await http.post(
      Uri.parse('$baseUrl/accounts/$accountId/d1/database/$databaseId/query'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({'sql': sql, 'params': params}),
    );

    if (response.statusCode != 200) {
      throw Exception('Database error: ${response.body}');
    }

    final result = json.decode(response.body);
    if (result['success'] != true) {
      throw Exception('Database error: ${result['errors']}');
    }

    return result['result'][0];
  }

  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<dynamic>? params,
  ]) async {
    final result = await execute(sql, params);
    return List<Map<String, dynamic>>.from(result['results']);
  }

  Future<int> insert(String sql, [List<dynamic>? params]) async {
    final result = await execute(sql, params);
    return result['last_row_id'];
  }

  Future<int> update(String sql, [List<dynamic>? params]) async {
    final result = await execute(sql, params);
    return result['changes'];
  }

  Future<int> delete(String sql, [List<dynamic>? params]) async {
    return update(sql, params);
  }
}
