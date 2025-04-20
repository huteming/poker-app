class Player {
  final int? id;
  final String name;
  final String avatarText;
  final DateTime createdAt;
  final DateTime updatedAt;

  Player({
    this.id,
    required this.name,
    required this.avatarText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Player copyWith({
    int? id,
    String? name,
    String? avatarText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarText: avatarText ?? this.avatarText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar_text': avatarText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      avatarText: map['avatar_text'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class Game {
  final int? id;
  final String gameType;
  final DateTime playedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    this.id,
    required this.gameType,
    required this.playedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Game copyWith({
    int? id,
    String? gameType,
    DateTime? playedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      gameType: gameType ?? this.gameType,
      playedAt: playedAt ?? this.playedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_type': gameType,
      'played_at': playedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      gameType: map['game_type'],
      playedAt: DateTime.parse(map['played_at']),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

class PlayerGameRecord {
  final int? id;
  final int gameId;
  final int playerId;
  final int score;
  final int? bombScore;
  final bool isWinner;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerGameRecord({
    this.id,
    required this.gameId,
    required this.playerId,
    required this.score,
    this.bombScore,
    required this.isWinner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  PlayerGameRecord copyWith({
    int? id,
    int? gameId,
    int? playerId,
    int? score,
    int? bombScore,
    bool? isWinner,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerGameRecord(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      score: score ?? this.score,
      bombScore: bombScore ?? this.bombScore,
      isWinner: isWinner ?? this.isWinner,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'player_id': playerId,
      'score': score,
      'bomb_score': bombScore,
      'is_winner': isWinner ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PlayerGameRecord.fromMap(Map<String, dynamic> map) {
    return PlayerGameRecord(
      id: map['id'],
      gameId: map['game_id'],
      playerId: map['player_id'],
      score: map['score'],
      bombScore: map['bomb_score'],
      isWinner: map['is_winner'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
