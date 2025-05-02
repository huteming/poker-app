import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

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
    return await http.get(Uri.parse('$_baseUrl$path'), headers: _headers);
  }

  Future<http.Response> post(String path, {Object? body}) async {
    return await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> patch(String path, {Object? body}) async {
    return await http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> delete(String path) async {
    return await http.delete(Uri.parse('$_baseUrl$path'), headers: _headers);
  }
}
