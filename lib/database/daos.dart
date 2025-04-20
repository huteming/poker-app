import '../models/db_models.dart';
import 'database_manager.dart';

class PlayerDao {
  final DatabaseManager _db;

  PlayerDao(this._db);

  Future<Player> create(Player player) async {
    final id = await _db.insert(
      'INSERT INTO players (name, avatar_text) VALUES (?, ?)',
      [player.name, player.avatarText],
    );
    return player.copyWith(id: id);
  }

  Future<Player?> findById(int id) async {
    final results = await _db.query('SELECT * FROM players WHERE id = ?', [id]);
    if (results.isEmpty) return null;
    return Player.fromMap(results.first);
  }

  Future<List<Player>> findAll() async {
    final results = await _db.query('SELECT * FROM players ORDER BY name');
    return results.map((map) => Player.fromMap(map)).toList();
  }

  Future<int> update(Player player) async {
    if (player.id == null) throw Exception('Player id is required for update');
    return _db.update(
      'UPDATE players SET name = ?, avatar_text = ? WHERE id = ?',
      [player.name, player.avatarText, player.id],
    );
  }

  Future<int> delete(int id) async {
    return _db.delete('DELETE FROM players WHERE id = ?', [id]);
  }
}

class GameDao {
  final DatabaseManager _db;

  GameDao(this._db);

  Future<Game> create(Game game) async {
    final id = await _db.insert(
      'INSERT INTO games (game_type, played_at) VALUES (?, ?)',
      [game.gameType, game.playedAt.toIso8601String()],
    );
    return game.copyWith(id: id);
  }

  Future<Game?> findById(int id) async {
    final results = await _db.query('SELECT * FROM games WHERE id = ?', [id]);
    if (results.isEmpty) return null;
    return Game.fromMap(results.first);
  }

  Future<List<Game>> findAll() async {
    final results = await _db.query(
      'SELECT * FROM games ORDER BY played_at DESC',
    );
    return results.map((map) => Game.fromMap(map)).toList();
  }

  Future<List<Game>> findByPlayerId(int playerId) async {
    final results = await _db.query(
      '''
      SELECT g.* FROM games g
      JOIN player_game_records pgr ON g.id = pgr.game_id
      WHERE pgr.player_id = ?
      ORDER BY g.played_at DESC
    ''',
      [playerId],
    );
    return results.map((map) => Game.fromMap(map)).toList();
  }

  Future<int> update(Game game) async {
    if (game.id == null) throw Exception('Game id is required for update');
    return _db.update(
      'UPDATE games SET game_type = ?, played_at = ? WHERE id = ?',
      [game.gameType, game.playedAt.toIso8601String(), game.id],
    );
  }

  Future<int> delete(int id) async {
    return _db.delete('DELETE FROM games WHERE id = ?', [id]);
  }
}

class PlayerGameRecordDao {
  final DatabaseManager _db;

  PlayerGameRecordDao(this._db);

  Future<PlayerGameRecord> create(PlayerGameRecord record) async {
    final id = await _db.insert(
      'INSERT INTO player_game_records (game_id, player_id, score, bomb_score, is_winner) VALUES (?, ?, ?, ?, ?)',
      [
        record.gameId,
        record.playerId,
        record.score,
        record.bombScore,
        record.isWinner ? 1 : 0,
      ],
    );
    return record.copyWith(id: id);
  }

  Future<List<PlayerGameRecord>> findByGameId(int gameId) async {
    final results = await _db.query(
      'SELECT * FROM player_game_records WHERE game_id = ?',
      [gameId],
    );
    return results.map((map) => PlayerGameRecord.fromMap(map)).toList();
  }

  Future<List<PlayerGameRecord>> findByPlayerId(int playerId) async {
    final results = await _db.query(
      'SELECT * FROM player_game_records WHERE player_id = ? ORDER BY created_at DESC',
      [playerId],
    );
    return results.map((map) => PlayerGameRecord.fromMap(map)).toList();
  }

  Future<int> update(PlayerGameRecord record) async {
    if (record.id == null) throw Exception('Record id is required for update');
    return _db.update(
      'UPDATE player_game_records SET score = ?, bomb_score = ?, is_winner = ? WHERE id = ?',
      [record.score, record.bombScore, record.isWinner ? 1 : 0, record.id],
    );
  }

  Future<int> delete(int id) async {
    return _db.delete('DELETE FROM player_game_records WHERE id = ?', [id]);
  }

  Future<List<Map<String, dynamic>>> getPlayerStats(int playerId) async {
    return _db.query(
      '''
      SELECT 
        COUNT(*) as total_games,
        SUM(CASE WHEN is_winner THEN 1 ELSE 0 END) as wins,
        SUM(score) as total_score,
        SUM(bomb_score) as total_bomb_score
      FROM player_game_records
      WHERE player_id = ?
    ''',
      [playerId],
    );
  }
}
