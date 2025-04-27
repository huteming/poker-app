class DbGameRecord {
  final int id;

  final int player1Id;
  final int player2Id;
  final int player3Id;
  final int player4Id;

  final int player1BombScore;
  final int player2BombScore;
  final int player3BombScore;
  final int player4BombScore;

  final int player1FinalScore;
  final int player2FinalScore;
  final int player3FinalScore;
  final int player4FinalScore;

  // DOUBLE_WIN, SINGLE_WIN, DRAW
  final String gameResultType;
  // PENDING, COMPLETED
  final String settlementStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final String? remarks;

  DbGameRecord({
    required this.id,
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
      createdAt: DateTime.parse(map['created_at'] as String),
      player1Id: map['player1_id'] as int,
      player2Id: map['player2_id'] as int,
      player3Id: map['player3_id'] as int,
      player4Id: map['player4_id'] as int,
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
  int getPlayerScore(int playerId) {
    if (playerId == player1Id) return player1FinalScore;
    if (playerId == player2Id) return player2FinalScore;
    if (playerId == player3Id) return player3FinalScore;
    if (playerId == player4Id) return player4FinalScore;
    return 0;
  }

  // 辅助方法，获取玩家炸弹分数
  int getPlayerBombScore(int playerId) {
    if (playerId == player1Id) return player1BombScore;
    if (playerId == player2Id) return player2BombScore;
    if (playerId == player3Id) return player3BombScore;
    if (playerId == player4Id) return player4BombScore;
    return 0;
  }

  // 获取所有玩家ID
  List<int> getAllPlayerIds() {
    return [player1Id, player2Id, player3Id, player4Id];
  }

  // 获取胜负类型文字
  String getGameResultTypeText() {
    if (gameResultType == 'DOUBLE_WIN') return '双扣';
    if (gameResultType == 'SINGLE_WIN') return '单扣';
    if (gameResultType == 'DRAW') return '平扣';
    return '';
  }

  // 获取玩家胜利状态
  int isWin(int playerId) {
    if (playerId == player1Id) return 1;
    if (playerId == player2Id) return 1;
    if (playerId == player3Id) return -1;
    if (playerId == player4Id) return -1;
    return 0;
  }
}
