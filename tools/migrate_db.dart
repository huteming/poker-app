import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// 数据库迁移工具
///
/// 使用方法: dart tools/migrate_db.dart
void main() async {
  // 确保工作目录正确，加载.env文件
  final currentDir = Directory.current.path;
  if (!File('$currentDir/.env').existsSync()) {
    if (File('$currentDir/../.env').existsSync()) {
      // 如果是在tools目录下运行
      Directory.current = Directory('$currentDir/..');
    } else {
      print('错误: 找不到.env文件，请确保在项目根目录或tools目录下运行此脚本');
      exit(1);
    }
  }

  print('准备执行数据库迁移...');

  // 手动加载环境变量
  final envFile = File('.env');
  final envVars = {};

  if (envFile.existsSync()) {
    final lines = await envFile.readAsLines();
    for (final line in lines) {
      if (line.trim().isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        envVars[key] = value;
      }
    }
    print('已加载环境变量: ${envVars.keys.join(', ')}');
  } else {
    print('错误: 找不到.env文件');
    exit(1);
  }

  // 验证数据库配置
  final requiredVars = ['CF_ACCOUNT_ID', 'CF_API_TOKEN', 'CF_DATABASE_ID'];
  for (final key in requiredVars) {
    if (!envVars.containsKey(key) || envVars[key]!.isEmpty) {
      print('错误: 环境变量 $key 未定义或为空');
      exit(1);
    }
  }

  try {
    print('验证数据库配置...');

    // 执行数据库迁移
    await _initializeDatabase(
      accountId: envVars['CF_ACCOUNT_ID']!,
      apiToken: envVars['CF_API_TOKEN']!,
      databaseId: envVars['CF_DATABASE_ID']!,
    );

    print('数据库迁移成功完成！');
    exit(0);
  } catch (e) {
    print('数据库迁移失败: $e');
    exit(1);
  }
}

Future<void> _initializeDatabase({
  required String accountId,
  required String apiToken,
  required String databaseId,
}) async {
  final baseUrl = 'https://api.cloudflare.com/client/v4/accounts';

  // 测试连接
  print('测试数据库连接...');
  final testResult = await _executeQuery(
    baseUrl: baseUrl,
    accountId: accountId,
    apiToken: apiToken,
    databaseId: databaseId,
    sql: 'SELECT 1',
  );

  if (!testResult['success']) {
    throw 'Connection test failed: ${testResult['errors']}';
  }
  print('数据库连接测试成功');

  // 检查game_records表是否存在
  print('检查game_records表是否存在...');
  final tableCheck = await _executeQuery(
    baseUrl: baseUrl,
    accountId: accountId,
    apiToken: apiToken,
    databaseId: databaseId,
    sql:
        "SELECT name FROM sqlite_master WHERE type='table' AND name='game_records'",
  );

  final tableExists = (tableCheck['results'] as List).isNotEmpty;

  if (!tableExists) {
    print('创建game_records表...');
    await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: '''
      CREATE TABLE IF NOT EXISTS game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        player1_id TEXT NOT NULL DEFAULT "",
        player2_id TEXT NOT NULL DEFAULT "",
        player3_id TEXT NOT NULL DEFAULT "",
        player4_id TEXT NOT NULL DEFAULT "",
        player1_bomb_score INTEGER NOT NULL DEFAULT 0,
        player2_bomb_score INTEGER NOT NULL DEFAULT 0,
        player3_bomb_score INTEGER NOT NULL DEFAULT 0,
        player4_bomb_score INTEGER NOT NULL DEFAULT 0,
        game_result_type TEXT NOT NULL,
        player1_final_score INTEGER NOT NULL DEFAULT 0,
        player2_final_score INTEGER NOT NULL DEFAULT 0,
        player3_final_score INTEGER NOT NULL DEFAULT 0,
        player4_final_score INTEGER NOT NULL DEFAULT 0,
        settlement_status TEXT NOT NULL DEFAULT 'PENDING',
        updated_at TEXT,
        remarks TEXT
      )
      ''',
    );

    print('创建索引...');
    await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: '''
      CREATE INDEX IF NOT EXISTS idx_game_records_player1_id ON game_records(player1_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player2_id ON game_records(player2_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player3_id ON game_records(player3_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player4_id ON game_records(player4_id);
      ''',
    );

    print('创建players表...');
    await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: '''
      CREATE TABLE IF NOT EXISTS players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        avatar TEXT NOT NULL DEFAULT "",
        created_at TEXT NOT NULL,
        updated_at TEXT
      )
      ''',
    );

    print('创建players表索引...');
    await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: 'CREATE INDEX IF NOT EXISTS idx_players_name ON players(name)',
    );
  } else {
    print('表已存在，验证并更新表结构...');

    // 检查表结构
    final columns = await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: 'PRAGMA table_info(game_records)',
    );

    final columnNames =
        (columns['results'] as List).map((c) => c['name'] as String).toSet();

    // 添加缺失的列
    final requiredColumns = [
      'player1_id',
      'player2_id',
      'player3_id',
      'player4_id',
    ];

    for (final column in requiredColumns) {
      if (!columnNames.contains(column)) {
        print('添加缺失的列: $column');
        await _executeQuery(
          baseUrl: baseUrl,
          accountId: accountId,
          apiToken: apiToken,
          databaseId: databaseId,
          sql:
              'ALTER TABLE game_records ADD COLUMN $column TEXT NOT NULL DEFAULT ""',
        );
      }
    }

    // 确保索引存在
    print('确保索引存在...');
    await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql: '''
      CREATE INDEX IF NOT EXISTS idx_game_records_player1_id ON game_records(player1_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player2_id ON game_records(player2_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player3_id ON game_records(player3_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_player4_id ON game_records(player4_id);
      ''',
    );

    // 确保players表存在
    final playersTableCheck = await _executeQuery(
      baseUrl: baseUrl,
      accountId: accountId,
      apiToken: apiToken,
      databaseId: databaseId,
      sql:
          "SELECT name FROM sqlite_master WHERE type='table' AND name='players'",
    );

    if ((playersTableCheck['results'] as List).isEmpty) {
      print('创建players表...');
      await _executeQuery(
        baseUrl: baseUrl,
        accountId: accountId,
        apiToken: apiToken,
        databaseId: databaseId,
        sql: '''
        CREATE TABLE IF NOT EXISTS players (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          avatar TEXT NOT NULL DEFAULT "",
          created_at TEXT NOT NULL,
          updated_at TEXT
        );
        CREATE INDEX IF NOT EXISTS idx_players_name ON players(name);
        ''',
      );
    }
  }
}

Future<Map<String, dynamic>> _executeQuery({
  required String baseUrl,
  required String accountId,
  required String apiToken,
  required String databaseId,
  required String sql,
  List<dynamic>? params,
}) async {
  final url = '$baseUrl/$accountId/d1/database/$databaseId/query';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'sql': sql, 'params': params ?? []}),
    );

    if (response.statusCode != 200) {
      print('数据库查询失败: HTTP ${response.statusCode}');
      print('响应内容: ${response.body}');
      return {'success': false, 'errors': response.body};
    }

    final responseJson = jsonDecode(response.body);
    if (!responseJson['success']) {
      return {'success': false, 'errors': responseJson['errors']};
    }

    final result = responseJson['result'][0];
    result['success'] = true;
    return result;
  } catch (e) {
    print('数据库查询异常: $e');
    return {'success': false, 'errors': e.toString()};
  }
}
