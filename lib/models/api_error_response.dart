import 'package:http/http.dart' as http;

class ApiErrorResponse {
  final http.Response? response;
  final String? message;

  ApiErrorResponse({this.response, this.message});

  http.BaseRequest get request {
    return response?.request ?? http.Request('GET', Uri.parse(''));
  }

  String get customMessage {
    return 'api 请求失败 {method: ${request.method}, url: ${request.url}, statusCode: ${response?.statusCode}, message: ${response?.body}} ';
  }

  @override
  String toString() {
    return message ?? customMessage;
  }
}
