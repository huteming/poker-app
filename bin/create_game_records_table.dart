// bin/create_game_records_table.dart

import 'package:logging/logging.dart';
import 'package:poker/config/database_config.dart';
import 'package:poker/database/database_manager.dart';
import 'package:poker/utils/setup_log.dart';

void main() {
  setupLog();
  createDatabaseTables();
}

Future<void> createDatabaseTables() async {
  final log = Logger('createDatabaseTables');

  try {
    DatabaseConfig.validate();

    final dbManager = DatabaseManager();

    // 检查数据库连接
    final connected = await dbManager.testConnection();
    if (connected) {
      log.info('数据库连接成功');
    } else {
      log.severe('数据库连接失败，请检查配置');
      return;
    }

    // 检查表是否已存在
    final tableExists = await dbManager.tableExists('game_records');

    if (tableExists) {
      log.info('game_records 表已存在, 跳过创建');
      return;
    }

    // 创建表
    await dbManager.execute('''
      CREATE TABLE game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

        player1_id INTEGER NOT NULL,
        player2_id INTEGER NOT NULL,
        player3_id INTEGER NOT NULL,
        player4_id INTEGER NOT NULL,

        player1_bomb_score INTEGER NOT NULL DEFAULT 0,
        player2_bomb_score INTEGER NOT NULL DEFAULT 0,
        player3_bomb_score INTEGER NOT NULL DEFAULT 0,
        player4_bomb_score INTEGER NOT NULL DEFAULT 0,

        player1_final_score INTEGER NOT NULL,
        player2_final_score INTEGER NOT NULL,
        player3_final_score INTEGER NOT NULL,
        player4_final_score INTEGER NOT NULL,

        game_result_type TEXT NOT NULL CHECK(game_result_type IN ('DOUBLE_WIN', 'SINGLE_WIN', 'DRAW')),
        settlement_status TEXT NOT NULL CHECK(settlement_status IN ('PENDING', 'COMPLETED', 'DISPUTED')),

        remarks TEXT
      )
    ''');

    // 创建索引
    await dbManager.execute('''
      CREATE INDEX idx_game_records_created_at ON game_records(created_at);
      CREATE INDEX idx_game_records_settlement_status ON game_records(settlement_status);
      CREATE INDEX idx_game_records_player1_id ON game_records(player1_id);
      CREATE INDEX idx_game_records_player2_id ON game_records(player2_id);
      CREATE INDEX idx_game_records_player3_id ON game_records(player3_id);
      CREATE INDEX idx_game_records_player4_id ON game_records(player4_id);
    ''');

    log.info('game_records 表创建成功');

    // 验证表结构
    final columns = await dbManager.getTableStructure('game_records');
    log.info('表结构验证，共${columns.length}个字段:');

    for (var column in columns) {
      log.info('- ${column['name']} (${column['type']})');
    }

    log.info('脚本执行完毕');
  } catch (e, stackTrace) {
    log.severe('创建表失败: $e');
    log.severe('错误堆栈: $stackTrace');
  }
}
