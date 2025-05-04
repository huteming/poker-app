import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _devBaseUrl = 'http://127.0.0.1:8787/poker/v1';
  static const String _prodBaseUrl = 'https://api.huteming.fun/poker/v1';

  static String get baseUrl {
    if (kDebugMode) {
      return _devBaseUrl;
    } else {
      return _prodBaseUrl;
    }
  }

  // 可以在这里添加其他环境相关的配置
  static const String apiToken = '1234567890';
}
