class PlayerScore {
  final String name;
  double winRate;
  final List<int> scores;
  final List<int> bombCounts; // 每局的炸弹数
  final List<String> gameTypes; // 每局的游戏类型
  final String avatarText;

  PlayerScore({
    required this.name,
    required this.winRate,
    required this.scores,
    List<int>? bombCounts,
    List<String>? gameTypes,
    required this.avatarText,
  }) : this.bombCounts = bombCounts ?? [],
       this.gameTypes = gameTypes ?? [];

  int get totalScore => scores.fold(0, (sum, score) => sum + score);

  void addRecord(int score, {int bombCount = 0, String gameType = '双扣'}) {
    scores.add(score);
    bombCounts.add(bombCount);
    gameTypes.add(gameType);
  }
}
