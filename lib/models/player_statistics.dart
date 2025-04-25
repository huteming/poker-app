import 'db_player.dart';

class PlayerStatistics {
  final Player player;
  final double winRate;
  final int totalScore;
  final int rank;

  PlayerStatistics({
    required this.player,
    required this.winRate,
    required this.totalScore,
    required this.rank,
  });

  PlayerStatistics copyWith({
    Player? player,
    double? winRate,
    int? totalScore,
    int? rank,
  }) {
    return PlayerStatistics(
      player: player ?? this.player,
      winRate: winRate ?? this.winRate,
      totalScore: totalScore ?? this.totalScore,
      rank: rank ?? this.rank,
    );
  }
}
