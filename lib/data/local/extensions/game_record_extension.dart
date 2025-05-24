// import 'package:poker/data/local/app_database.dart';

part of '../app_database.dart';

extension GameRecordExtension on GameRecord {
  // 获取玩家分数
  int getPlayerScore(int playerId) {
    if (playerId == player1Id) return player1FinalScore;
    if (playerId == player2Id) return player2FinalScore;
    if (playerId == player3Id) return player3FinalScore;
    if (playerId == player4Id) return player4FinalScore;
    return 0;
  }

  // 获取玩家炸弹分数
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

  // 转换为远程模型格式
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
}
