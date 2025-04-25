import 'database_manager.dart';

class GameRecordMigration {
  static Future<void> createTable(DatabaseManager db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_id TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        
        player1_bomb_score INTEGER NOT NULL DEFAULT 0,
        player2_bomb_score INTEGER NOT NULL DEFAULT 0,
        player3_bomb_score INTEGER NOT NULL DEFAULT 0,
        player4_bomb_score INTEGER NOT NULL DEFAULT 0,
        
        game_result_type TEXT NOT NULL CHECK(game_result_type IN ('DOUBLE_WIN', 'SINGLE_WIN', 'DRAW')),
        
        player1_final_score INTEGER NOT NULL,
        player2_final_score INTEGER NOT NULL,
        player3_final_score INTEGER NOT NULL,
        player4_final_score INTEGER NOT NULL,
        
        settlement_status TEXT NOT NULL CHECK(settlement_status IN ('PENDING', 'COMPLETED', 'DISPUTED')),
        
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        remarks TEXT,
        
        winner1_id TEXT,
        winner2_id TEXT,
        winning_team TEXT CHECK(winning_team IN ('TEAM_A', 'TEAM_B'))
      )
    ''');
  }

  static Future<void> createIndexes(DatabaseManager db) async {
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_game_records_game_id ON game_records(game_id);
      CREATE INDEX IF NOT EXISTS idx_game_records_created_at ON game_records(created_at);
      CREATE INDEX IF NOT EXISTS idx_game_records_settlement_status ON game_records(settlement_status);
    ''');
  }
}
