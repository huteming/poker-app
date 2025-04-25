class DbGameRecord {
  final int id;
  final String gameId;
  final DateTime createdAt;
  final String player1Id;
  final String player2Id;
  final String player3Id;
  final String player4Id;
  final int player1BombScore;
  final int player2BombScore;
  final int player3BombScore;
  final int player4BombScore;
  final String gameResultType;
  final int player1FinalScore;
  final int player2FinalScore;
  final int player3FinalScore;
  final int player4FinalScore;
  final String settlementStatus;
  final DateTime updatedAt;
  final String? remarks;

  DbGameRecord({
    required this.id,
    required this.gameId,
    required this.createdAt,
    required this.player1Id,
    required this.player2Id,
    required this.player3Id,
    required this.player4Id,
    required this.player1BombScore,
    required this.player2BombScore,
    required this.player3BombScore,
    required this.player4BombScore,
    required this.gameResultType,
    required this.player1FinalScore,
    required this.player2FinalScore,
    required this.player3FinalScore,
    required this.player4FinalScore,
    required this.settlementStatus,
    required this.updatedAt,
    this.remarks,
  });

  factory DbGameRecord.fromMap(Map<String, dynamic> map) {
    return DbGameRecord(
      id: map['id'] as int,
      gameId: map['game_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      player1Id: map['player1_id'] as String,
      player2Id: map['player2_id'] as String,
      player3Id: map['player3_id'] as String,
      player4Id: map['player4_id'] as String,
      player1BombScore: map['player1_bomb_score'] as int,
      player2BombScore: map['player2_bomb_score'] as int,
      player3BombScore: map['player3_bomb_score'] as int,
      player4BombScore: map['player4_bomb_score'] as int,
      gameResultType: map['game_result_type'] as String,
      player1FinalScore: map['player1_final_score'] as int,
      player2FinalScore: map['player2_final_score'] as int,
      player3FinalScore: map['player3_final_score'] as int,
      player4FinalScore: map['player4_final_score'] as int,
      settlementStatus: map['settlement_status'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'created_at': createdAt.toIso8601String(),
      'player1_id': player1Id,
      'player2_id': player2Id,
      'player3_id': player3Id,
      'player4_id': player4Id,
      'player1_bomb_score': player1BombScore,
      'player2_bomb_score': player2BombScore,
      'player3_bomb_score': player3BombScore,
      'player4_bomb_score': player4BombScore,
      'game_result_type': gameResultType,
      'player1_final_score': player1FinalScore,
      'player2_final_score': player2FinalScore,
      'player3_final_score': player3FinalScore,
      'player4_final_score': player4FinalScore,
      'settlement_status': settlementStatus,
      'updated_at': updatedAt.toIso8601String(),
      'remarks': remarks,
    };
  }

  // 辅助方法，获取玩家分数
  int getPlayerScore(String playerId) {
    if (playerId == player1Id) return player1FinalScore;
    if (playerId == player2Id) return player2FinalScore;
    if (playerId == player3Id) return player3FinalScore;
    if (playerId == player4Id) return player4FinalScore;
    return 0;
  }

  // 辅助方法，获取玩家炸弹分数
  int getPlayerBombScore(String playerId) {
    if (playerId == player1Id) return player1BombScore;
    if (playerId == player2Id) return player2BombScore;
    if (playerId == player3Id) return player3BombScore;
    if (playerId == player4Id) return player4BombScore;
    return 0;
  }

  // 获取所有玩家ID
  List<String> getAllPlayerIds() {
    return [player1Id, player2Id, player3Id, player4Id];
  }

  // 获取赢家ID
  List<String> getWinnerIds() {
    final winners = <String>[];
    if (player1FinalScore > 0) winners.add(player1Id);
    if (player2FinalScore > 0) winners.add(player2Id);
    if (player3FinalScore > 0) winners.add(player3Id);
    if (player4FinalScore > 0) winners.add(player4Id);
    return winners;
  }

  // 获取输家ID
  List<String> getLoserIds() {
    final losers = <String>[];
    if (player1FinalScore <= 0) losers.add(player1Id);
    if (player2FinalScore <= 0) losers.add(player2Id);
    if (player3FinalScore <= 0) losers.add(player3Id);
    if (player4FinalScore <= 0) losers.add(player4Id);
    return losers;
  }
}
