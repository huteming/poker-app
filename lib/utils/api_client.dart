import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poker/config/app_config.dart';
import 'package:poker/models/api_response.dart';
import 'package:poker/models/api_error_response.dart';

abstract class ApiClient {
  String get _baseUrl => AppConfig.baseUrl;
  final String _token = AppConfig.apiToken;

  String get baseUrl => _baseUrl;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
    'Accept-Charset': 'utf-8',
  };

  Future<ApiResponse<T>> get<T>(String path) async {
    return _handleRequest<T>(
      () => http.get(Uri.parse('$_baseUrl$path'), headers: _headers),
    );
  }

  Future<ApiResponse<T>> post<T>(String path, {Object? body}) async {
    return _handleRequest<T>(
      () => http.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  Future<ApiResponse<T>> patch<T>(String path, {Object? body}) async {
    return _handleRequest<T>(
      () => http.patch(
        Uri.parse('$_baseUrl$path'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      ),
    );
  }

  Future<ApiResponse<T>> delete<T>(String path) async {
    return _handleRequest<T>(
      () => http.delete(Uri.parse('$_baseUrl$path'), headers: _headers),
    );
  }

  Future<ApiResponse<T>> _handleRequest<T>(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();

      if (!_isSuccessfulResponse(response)) {
        throw ApiErrorResponse(response: response);
      }

      final String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);

      return ApiResponse(data: data as T);
    } catch (e) {
      if (e is ApiErrorResponse) {
        rethrow;
      }
      throw ApiErrorResponse(message: '网络请求异常: $e');
    }
  }

  bool _isSuccessfulResponse(http.Response response) {
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
