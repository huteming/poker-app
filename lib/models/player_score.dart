class PlayerScore {
  final String name;
  final double winRate;
  final List<int> scores;
  final String avatarText;

  PlayerScore({
    required this.name,
    required this.winRate,
    required this.scores,
    required this.avatarText,
  });

  int get totalScore => scores.fold(0, (sum, score) => sum + score);
}
