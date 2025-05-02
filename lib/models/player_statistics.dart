class PlayerStatistics {
  final int playerId;
  final String playerName;
  final int totalGames;
  final int wins;
  final int totalScore;
  final double winRate;
  final int rank;

  PlayerStatistics({
    required this.playerId,
    required this.playerName,
    required this.totalGames,
    required this.wins,
    required this.totalScore,
    required this.winRate,
    required this.rank,
  });

  PlayerStatistics copyWith({
    int? playerId,
    String? playerName,
    int? totalGames,
    int? wins,
    int? totalScore,
    double? winRate,
    int? rank,
  }) {
    return PlayerStatistics(
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      totalGames: totalGames ?? this.totalGames,
      wins: wins ?? this.wins,
      totalScore: totalScore ?? this.totalScore,
      winRate: winRate ?? this.winRate,
      rank: rank ?? this.rank,
    );
  }
}
