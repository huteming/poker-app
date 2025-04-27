import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

class DatabaseConfig {
  static String get accountId => dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  static String get apiToken => dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';
  static String get databaseId => dotenv.env['CLOUDFLARE_DATABASE_ID'] ?? '';

  static bool get isValid {
    return accountId.isNotEmpty && apiToken.isNotEmpty && databaseId.isNotEmpty;
  }

  static bool validate() {
    final log = Logger('DatabaseConfig');

    if (isValid) {
      log.info('数据库配置验证成功');
      return true;
    }

    final message = '''
        Cloudflare configuration is missing. Please check your .env file:
        - CLOUDFLARE_ACCOUNT_ID: ${accountId.isEmpty ? 'missing' : 'set'}
        - CLOUDFLARE_API_TOKEN: ${apiToken.isEmpty ? 'missing' : 'set'}
        - CLOUDFLARE_DATABASE_ID: ${databaseId.isEmpty ? 'missing' : 'set'}
      ''';
    log.warning('数据库配置验证失败: $message');
    return false;
  }
}
