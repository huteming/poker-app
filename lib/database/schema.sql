-- 玩家表
CREATE TABLE players (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    avatar_text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 游戏表
CREATE TABLE games (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_type TEXT NOT NULL,
    played_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 玩家游戏记录表
CREATE TABLE player_game_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    score INTEGER NOT NULL,
    bomb_score INTEGER,
    is_winner BOOLEAN NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE
);

-- 创建索引
CREATE INDEX idx_games_played_at ON games(played_at);
CREATE INDEX idx_player_records_game_id ON player_game_records(game_id);
CREATE INDEX idx_player_records_player_id ON player_game_records(player_id);

-- 创建触发器来更新 updated_at
CREATE TRIGGER update_players_timestamp 
    AFTER UPDATE ON players
    FOR EACH ROW
    BEGIN
        UPDATE players SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER update_games_timestamp 
    AFTER UPDATE ON games
    FOR EACH ROW
    BEGIN
        UPDATE games SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

CREATE TRIGGER update_player_records_timestamp 
    AFTER UPDATE ON player_game_records
    FOR EACH ROW
    BEGIN
        UPDATE player_game_records SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END; 