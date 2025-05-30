import 'dart:math' as math;

// 胜负类型基础分
const Map<String, int> gameResultScore = {
  'DOUBLE_WIN': 20,
  'SINGLE_WIN': 10,
  'DRAW': 5,
  'STALEMATE': 0,
};

// 炸弹系数
const List<int> bombMultiplier = [1, 1, 1, 1, 1, 2, 4, 8, 16, 16, 16];

// 炸弹积分
const List<int> bombScore = [0, 0, 0, 0, 0, 0, 10, 20, 40, 80, 160];

/// 计算一局游戏的积分
///
/// [gameScore] 胜负基础分
/// [player1Bomb] 到 [player4Bomb] 分别是四个玩家的炸弹数
/// 返回一个包含四个玩家积分的列表，顺序与输入顺序相同
/// 前两个是赢家，后两个是输家
List<int> calculateGameScore(
  String gameResultType,
  int player1Bomb,
  int player2Bomb,
  int player3Bomb,
  int player4Bomb,
) {
  // 获取最大炸弹数作为系数
  final multiplier = bombMultiplier[math.max(player1Bomb, player2Bomb)];

  // 计算基础分数
  final baseScore = gameResultScore[gameResultType]! * multiplier;

  // 计算每个玩家的积分
  final player1Score =
      baseScore +
      bombScore[player1Bomb] * 3 -
      bombScore[player2Bomb] -
      bombScore[player3Bomb] -
      bombScore[player4Bomb];

  final player2Score =
      baseScore +
      bombScore[player2Bomb] * 3 -
      bombScore[player1Bomb] -
      bombScore[player3Bomb] -
      bombScore[player4Bomb];

  final player3Score =
      -baseScore +
      bombScore[player3Bomb] * 3 -
      bombScore[player1Bomb] -
      bombScore[player2Bomb] -
      bombScore[player4Bomb];

  final player4Score =
      -baseScore +
      bombScore[player4Bomb] * 3 -
      bombScore[player1Bomb] -
      bombScore[player2Bomb] -
      bombScore[player3Bomb];

  return [player1Score, player2Score, player3Score, player4Score];
}

/// 创建游戏记录的得分信息
///
/// [gameResultType] 胜负类型字符串
/// [playerIds] 玩家列表，前两个为赢家，后两个为输家
/// [bombScores] 炸弹分数Map，key为玩家名字，value为炸弹数
/// 返回一个包含四个玩家最终得分的Map，key为玩家名字
List<int> createGameScores(
  String gameResultType,
  List<int> playerIds,
  Map<int, int> bombs,
) {
  final scores = calculateGameScore(
    gameResultType,
    bombs[playerIds[0]] ?? 0,
    bombs[playerIds[1]] ?? 0,
    bombs[playerIds[2]] ?? 0,
    bombs[playerIds[3]] ?? 0,
  );

  return scores;
}
