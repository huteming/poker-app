import 'package:flutter/foundation.dart';
import 'package:poker/models/db_player.dart';
import 'package:poker/services/player_service.dart';

/// 玩家状态管理，类似于Vue的Pinia store
class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  List<Player> _players = [];
  bool _isLoading = false;
  String? _error;

  // 获取器
  List<Player> get players => _players;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPlayers => _players.isNotEmpty;

  // 构造函数，初始化时自动加载玩家列表
  PlayerProvider() {
    loadPlayers();
  }

  // 加载玩家列表
  Future<void> loadPlayers() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final players = await _playerService.getAllPlayers();

    _players = players;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  // 根据ID查找玩家
  Player findPlayerById(int id) {
    return _players.firstWhere((player) => player.id == id);
  }

  // 根据名称查找玩家
  Player findPlayerByName(String name) {
    return _players.firstWhere((player) => player.name == name);
  }
}
