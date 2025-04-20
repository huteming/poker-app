import '../models/player.dart';

class PlayerService {
  // 模拟玩家数据
  final List<Player> _mockPlayers = [
    Player(
      id: '1',
      name: '张三',
      avatarText: '张',
      createdAt: DateTime(2024, 1, 1),
    ),
    Player(
      id: '2',
      name: '李四',
      avatarText: '李',
      createdAt: DateTime(2024, 1, 2),
    ),
    Player(
      id: '3',
      name: '王五',
      avatarText: '王',
      createdAt: DateTime(2024, 1, 3),
    ),
    Player(
      id: '4',
      name: '赵六',
      avatarText: '赵',
      createdAt: DateTime(2024, 1, 4),
    ),
    Player(
      id: '5',
      name: '钱七',
      avatarText: '钱',
      createdAt: DateTime(2024, 1, 5),
    ),
    Player(
      id: '6',
      name: '孙八',
      avatarText: '孙',
      createdAt: DateTime(2024, 1, 6),
    ),
  ];

  // 获取所有玩家
  Future<List<Player>> getAllPlayers() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockPlayers;
  }

  // 根据ID获取玩家
  Future<Player?> getPlayerById(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockPlayers.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }
}
