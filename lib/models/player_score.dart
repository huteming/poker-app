class PlayerScore {
  final String name;
  double winRate;
  final List<int> scores;
  final List<int> bombCounts; // 每局的炸弹数
  final List<String> gameTypes; // 每局的游戏类型
  final List<DateTime> recordTimes; // 每局的记录时间
  final List<int> recordIds; // 每局的数据库记录ID
  final String avatarText;

  PlayerScore({
    required this.name,
    required this.winRate,
    required this.scores,
    List<int>? bombCounts,
    List<String>? gameTypes,
    List<DateTime>? recordTimes,
    List<int>? recordIds,
    required this.avatarText,
  }) : bombCounts = bombCounts ?? [],
       gameTypes = gameTypes ?? [],
       recordTimes = recordTimes ?? [],
       recordIds = recordIds ?? [];

  int get totalScore => scores.fold(0, (sum, score) => sum + score);

  void addRecord(
    int score, {
    int bombCount = 0,
    String gameType = '双扣',
    DateTime? recordTime,
    int? recordId,
  }) {
    scores.add(score);
    bombCounts.add(bombCount);
    gameTypes.add(gameType);
    recordTimes.add(recordTime ?? DateTime.now());
    recordIds.add(recordId ?? 0);
  }

  void removeRecord(int index) {
    if (index >= 0 && index < scores.length) {
      scores.removeAt(index);
      bombCounts.removeAt(index);
      gameTypes.removeAt(index);
      recordTimes.removeAt(index);
      recordIds.removeAt(index);
    }
  }
}
