import 'package:flutter/foundation.dart';
import 'package:poker/data/local/app_database.dart';
import 'package:poker/data/repositories/player_repository.dart';
import 'package:poker/domains/player_entity.dart';

/// 玩家状态管理，类似于Vue的Pinia store
class PlayerProvider with ChangeNotifier {
  final PlayerRepository _playerRepository = PlayerRepository();

  List<PlayerEntity> _players = [];
  bool _isLoading = false;
  String? _error;

  // 获取器
  List<PlayerEntity> get players => _players;
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

    final players = await _playerRepository.getAllPlayers();

    _players = players;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  // 根据ID查找玩家
  PlayerEntity findPlayerById(int id) {
    return _players.firstWhere((player) => player.id == id);
  }

  // 根据名称查找玩家
  PlayerEntity findPlayerByName(String name) {
    return _players.firstWhere((player) => player.name == name);
  }
}
