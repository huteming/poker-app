// ignore_for_file: non_constant_identifier_names

import 'package:drift/drift.dart';
import 'package:poker/data/local/app_database.dart';

class GameRecordEntity {
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
  // PENDING, SETTLED
  final String settlementStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final String remarks;

  GameRecordEntity({
    required this.id,
    required this.player1Id,
    required this.player2Id,
    required this.player3Id,
    required this.player4Id,
    required this.player1BombScore,
    required this.player2BombScore,
    required this.player3BombScore,
    required this.player4BombScore,
    required this.player1FinalScore,
    required this.player2FinalScore,
    required this.player3FinalScore,
    required this.player4FinalScore,
    required this.gameResultType,
    required this.settlementStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.remarks,
  });

  factory GameRecordEntity.create({
    required int player1Id,
    required int player2Id,
    required int player3Id,
    required int player4Id,
    required int player1BombScore,
    required int player2BombScore,
    required int player3BombScore,
    required int player4BombScore,
    required int player1FinalScore,
    required int player2FinalScore,
    required int player3FinalScore,
    required int player4FinalScore,
    required String gameResultType,
  }) {
    return GameRecordEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      player1Id: player1Id,
      player2Id: player2Id,
      player3Id: player3Id,
      player4Id: player4Id,
      player1BombScore: player1BombScore,
      player2BombScore: player2BombScore,
      player3BombScore: player3BombScore,
      player4BombScore: player4BombScore,
      player1FinalScore: player1FinalScore,
      player2FinalScore: player2FinalScore,
      player3FinalScore: player3FinalScore,
      player4FinalScore: player4FinalScore,
      gameResultType: gameResultType,
      settlementStatus: 'PENDING',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      remarks: '',
    );
  }

  factory GameRecordEntity.fromLocal(GameRecord record) {
    return GameRecordEntity(
      id: record.id,
      player1Id: record.player1Id,
      player2Id: record.player2Id,
      player3Id: record.player3Id,
      player4Id: record.player4Id,
      player1BombScore: record.player1BombScore,
      player2BombScore: record.player2BombScore,
      player3BombScore: record.player3BombScore,
      player4BombScore: record.player4BombScore,
      player1FinalScore: record.player1FinalScore,
      player2FinalScore: record.player2FinalScore,
      player3FinalScore: record.player3FinalScore,
      player4FinalScore: record.player4FinalScore,
      gameResultType: record.gameResultType,
      settlementStatus: record.settlementStatus,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      remarks: record.remarks ?? '',
    );
  }

  factory GameRecordEntity.fromRemote(Map<String, dynamic> map) {
    return GameRecordEntity(
      id: map['id'],
      player1Id: map['player1_id'],
      player2Id: map['player2_id'],
      player3Id: map['player3_id'],
      player4Id: map['player4_id'],
      player1BombScore: map['player1_bomb_score'],
      player2BombScore: map['player2_bomb_score'],
      player3BombScore: map['player3_bomb_score'],
      player4BombScore: map['player4_bomb_score'],
      player1FinalScore: map['player1_final_score'],
      player2FinalScore: map['player2_final_score'],
      player3FinalScore: map['player3_final_score'],
      player4FinalScore: map['player4_final_score'],
      gameResultType: map['game_result_type'],
      settlementStatus: map['settlement_status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      remarks: map['remarks'] ?? '',
    );
  }

  GameRecordsCompanion toGameRecordsCompanion() {
    return GameRecordsCompanion.insert(
      player1Id: player1Id,
      player2Id: player2Id,
      player3Id: player3Id,
      player4Id: player4Id,
      player1BombScore: player1BombScore,
      player2BombScore: player2BombScore,
      player3BombScore: player3BombScore,
      player4BombScore: player4BombScore,
      player1FinalScore: player1FinalScore,
      player2FinalScore: player2FinalScore,
      player3FinalScore: player3FinalScore,
      player4FinalScore: player4FinalScore,
      gameResultType: gameResultType,
      settlementStatus: settlementStatus,
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      remarks: Value(remarks),
    );
  }

  GameRecordCreateDto toGameRecordCreateDto() {
    return GameRecordCreateDto(
      player1_id: player1Id,
      player2_id: player2Id,
      player3_id: player3Id,
      player4_id: player4Id,
      player1_bomb_score: player1BombScore,
      player2_bomb_score: player2BombScore,
      player3_bomb_score: player3BombScore,
      player4_bomb_score: player4BombScore,
      player1_final_score: player1FinalScore,
      player2_final_score: player2FinalScore,
      player3_final_score: player3FinalScore,
      player4_final_score: player4FinalScore,
      game_result_type: gameResultType,
    );
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
    if (gameResultType == 'STALEMATE') return '流局';
    return '';
  }

  // 获取玩家胜利状态
  int isWinner(int playerId) {
    if (gameResultType == 'STALEMATE') return 0;
    if (playerId == player1Id) return 1;
    if (playerId == player2Id) return 1;
    if (playerId == player3Id) return -1;
    if (playerId == player4Id) return -1;
    return 0;
  }
}

class GameRecordCreateDto {
  final int player1_id;
  final int player2_id;
  final int player3_id;
  final int player4_id;
  final int player1_bomb_score;
  final int player2_bomb_score;
  final int player3_bomb_score;
  final int player4_bomb_score;
  final int player1_final_score;
  final int player2_final_score;
  final int player3_final_score;
  final int player4_final_score;
  final String game_result_type;

  GameRecordCreateDto({
    required this.player1_id,
    required this.player2_id,
    required this.player3_id,
    required this.player4_id,
    required this.player1_bomb_score,
    required this.player2_bomb_score,
    required this.player3_bomb_score,
    required this.player4_bomb_score,
    required this.player1_final_score,
    required this.player2_final_score,
    required this.player3_final_score,
    required this.player4_final_score,
    required this.game_result_type,
  });

  Map<String, dynamic> toJson() {
    return {
      'player1_id': player1_id,
      'player2_id': player2_id,
      'player3_id': player3_id,
      'player4_id': player4_id,
      'player1_bomb_score': player1_bomb_score,
      'player2_bomb_score': player2_bomb_score,
      'player3_bomb_score': player3_bomb_score,
      'player4_bomb_score': player4_bomb_score,
      'player1_final_score': player1_final_score,
      'player2_final_score': player2_final_score,
      'player3_final_score': player3_final_score,
      'player4_final_score': player4_final_score,
      'game_result_type': game_result_type,
    };
  }
}
