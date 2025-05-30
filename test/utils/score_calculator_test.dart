import 'package:flutter_test/flutter_test.dart';
import 'package:poker/utils/score_calculator.dart';

void main() {
  group('calculateGameScore', () {
    test('双扣无炸弹的情况', () {
      final scores = calculateGameScore(
        'DOUBLE_WIN',
        0, // player1Bomb
        0, // player2Bomb
        0, // player3Bomb
        0, // player4Bomb
      );

      expect(scores, [20, 20, -20, -20]); // 双赢基础分20，赢家各得20，输家各扣20
    });

    test('单扣无炸弹的情况', () {
      final scores = calculateGameScore(
        'SINGLE_WIN',
        0, // player1Bomb
        0, // player2Bomb
        0, // player3Bomb
        0, // player4Bomb
      );

      expect(scores, [10, 10, -10, -10]); // 单赢基础分10，赢家各得10，输家各扣10
    });

    test('平扣无炸弹的情况', () {
      final scores = calculateGameScore(
        'DRAW',
        0, // player1Bomb
        0, // player2Bomb
        0, // player3Bomb
        0, // player4Bomb
      );

      expect(scores, [5, 5, -5, -5]); // 平局基础分5，赢家各得5，输家各扣5
    });

    test('双扣有炸弹的情况', () {
      final scores = calculateGameScore(
        'DOUBLE_WIN',
        6, // player1Bomb (2个炸弹)
        0, // player2Bomb (1个炸弹)
        0, // player3Bomb (无炸弹)
        0, // player4Bomb (无炸弹)
      );

      // 基础分20 * 炸弹系数2 = 80
      // player1: 80 + (10 * 3) - 0 - 0 - 0 = 110
      // player2: 80 + (0 * 3) - 10 - 0 - 0 = 70
      // player3: -80 + (0 * 3) - 10 - 0 - 0 = -90
      // player4: -80 + (0 * 3) - 10 - 0 - 0 = -90
      expect(scores, [110, 70, -90, -90]);
    });

    test('多个炸弹的情况', () {
      final scores = calculateGameScore(
        'SINGLE_WIN',
        8, // player1Bomb (3个炸弹)
        6, // player2Bomb (2个炸弹)
        7, // player3Bomb (1个炸弹)
        6, // player4Bomb (无炸弹)
      );

      // player1: 160 + (40 * 3) - 10 - 20 - 10 = 240
      // player2: 160 + (10 * 3) - 40 - 20 - 10 = 120
      // player3: -160 + (20 * 3) - 40 - 10 - 10 = -160
      // player4: -160 + (10 * 3) - 40 - 10 - 20 = -200
      expect(scores, [240, 120, -160, -200]);
    });
  });

  group('createGameScores', () {
    test('创建游戏得分 - 无炸弹', () {
      final playerIds = [1, 2, 3, 4]; // 1,2为赢家，3,4为输家
      final bombs = {1: 0, 2: 0, 3: 0, 4: 0};

      final scores = createGameScores('DOUBLE_WIN', playerIds, bombs);
      expect(scores, [20, 20, -20, -20]);
    });

    test('创建游戏得分 - 有炸弹', () {
      final playerIds = [1, 2, 3, 4]; // 1,2为赢家，3,4为输家
      final bombs = {
        1: 6, // 2个炸弹
        2: 0, // 1个炸弹
        3: 0, // 无炸弹
        4: 0, // 无炸弹
      };

      final scores = createGameScores('DOUBLE_WIN', playerIds, bombs);
      expect(scores, [110, 70, -90, -90]);
    });

    test('创建游戏得分 - 流局', () {
      final playerIds = [1, 2, 3, 4];
      final bombs = {1: 8, 2: 6, 3: 7, 4: 6};

      final scores = createGameScores('STALEMATE', playerIds, bombs);
      expect(scores, [80, -40, 0, -40]);
    });

    test('创建游戏得分 - 玩家顺序不同', () {
      final playerIds = [4, 3, 2, 1]; // 4,3为赢家，2,1为输家
      final bombs = {1: 0, 2: 0, 3: 0, 4: 6};

      final scores = createGameScores('DOUBLE_WIN', playerIds, bombs);
      // 注意：分数顺序与playerIds顺序对应
      expect(scores, [110, 70, -90, -90]);
    });
  });
}
