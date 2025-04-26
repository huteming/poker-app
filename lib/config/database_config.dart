import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseConfig {
  static String get accountId => dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  static String get apiToken => dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';
  static String get databaseId => dotenv.env['CLOUDFLARE_DATABASE_ID'] ?? '';

  static bool get isValid {
    return accountId.isNotEmpty && apiToken.isNotEmpty && databaseId.isNotEmpty;
  }

  static void validate() {
    if (isValid) {
      log('数据库配置验证成功');
      return;
    }

    final message = '''
        Cloudflare configuration is missing. Please check your .env file:
        - CLOUDFLARE_ACCOUNT_ID: ${accountId.isEmpty ? 'missing' : 'set'}
        - CLOUDFLARE_API_TOKEN: ${apiToken.isEmpty ? 'missing' : 'set'}
        - CLOUDFLARE_DATABASE_ID: ${databaseId.isEmpty ? 'missing' : 'set'}
      ''';
    log('数据库配置验证失败: $message');
  }
}
