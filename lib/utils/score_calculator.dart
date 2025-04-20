import 'dart:math' as math;

// 胜负类型基础分
// 0: 平扣; 1: 单扣; 2: 双扣
const List<int> winTypeScore = [5, 10, 20];

// 炸弹系数
const List<int> bombMultiplier = [1, 1, 1, 1, 1, 2, 4, 8, 16, 16, 16];

// 炸弹积分
const List<int> bombScore = [0, 0, 0, 0, 0, 0, 10, 20, 40, 80, 160];

/// 计算一局游戏的积分
///
/// [winType] 胜负类型 (0: 平扣, 1: 单扣, 2: 双扣)
/// [player1Bomb] 到 [player4Bomb] 分别是四个玩家的炸弹数
/// 返回一个包含四个玩家积分的列表，顺序与输入顺序相同
/// 前两个是赢家，后两个是输家
List<int> calculateGameScore(
  int winType,
  int player1Bomb,
  int player2Bomb,
  int player3Bomb,
  int player4Bomb,
) {
  // 获取最大炸弹数作为系数
  final multiplier = bombMultiplier[math.max(player1Bomb, player2Bomb)];

  // 计算基础分数
  final baseScore = winTypeScore[winType] * multiplier;

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

/// 获取胜负类型对应的索引
int getWinTypeIndex(String winType) {
  switch (winType) {
    case '平扣':
      return 0;
    case '单扣':
      return 1;
    case '双扣':
      return 2;
    default:
      throw ArgumentError('未知的胜负类型: $winType');
  }
}

/// 创建游戏记录的得分信息
///
/// [winType] 胜负类型字符串 ('平扣', '单扣', '双扣')
/// [players] 玩家列表，前两个为赢家，后两个为输家
/// [bombScores] 炸弹分数Map，key为玩家名字，value为炸弹数
/// 返回一个包含四个玩家最终得分的Map，key为玩家名字
Map<String, int> createGameScores(
  String winType,
  List<String> players,
  Map<String, int> bombScores,
) {
  if (players.length != 4) {
    throw ArgumentError('玩家数量必须为4人');
  }

  final winTypeIdx = getWinTypeIndex(winType);
  final scores = calculateGameScore(
    winTypeIdx,
    bombScores[players[0]] ?? 0,
    bombScores[players[1]] ?? 0,
    bombScores[players[2]] ?? 0,
    bombScores[players[3]] ?? 0,
  );

  return {
    players[0]: scores[0],
    players[1]: scores[1],
    players[2]: scores[2],
    players[3]: scores[3],
  };
}
