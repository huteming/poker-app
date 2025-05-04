import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:poker/models/db_error.dart';

abstract class BaseService {
  final log = Logger('BaseService');
  // final String _baseUrl = 'https://api.huteming.fun/poker/v1';
  final String _baseUrl = 'http://127.0.0.1:8787/poker/v1';
  final String _token = '1234567890';

  String get baseUrl => _baseUrl;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
    'Accept-Charset': 'utf-8',
  };

  Future<http.Response> get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
    if (!_isSuccessfulResponse(response)) {
      throw Exception('请求失败，状态码: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> post(String path, {Object? body}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
    if (!_isSuccessfulResponse(response)) {
      final errorResponse = ErrorResponse.fromJson(json.decode(response.body));
      throw Exception(errorResponse.error);
    }
    return response;
  }

  Future<http.Response> patch(String path, {Object? body}) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
    if (!_isSuccessfulResponse(response)) {
      throw Exception('请求失败，状态码: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
    if (!_isSuccessfulResponse(response)) {
      throw Exception('请求失败，状态码: ${response.statusCode}');
    }
    return response;
  }

  bool _isSuccessfulResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
