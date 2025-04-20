class GameRecord {
  final int roundNumber;
  final DateTime playedAt;
  final String gameType;
  final List<PlayerGameRecord> winners;
  final List<PlayerGameRecord> losers;
  final Function()? onDelete;

  GameRecord({
    required this.roundNumber,
    required this.playedAt,
    required this.gameType,
    required this.winners,
    required this.losers,
    this.onDelete,
  });
}

class PlayerGameRecord {
  final String name;
  final int score;
  final int? bombScore; // null 表示"无"

  PlayerGameRecord({required this.name, required this.score, this.bombScore});
}
