import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../models/db_player.dart';
import '../database/player_dao.dart';

/// 玩家状态管理，类似于Vue的Pinia store
class PlayerProvider with ChangeNotifier {
  List<Player> _players = [];
  bool _isLoading = false;
  String? _error;
  final PlayerDao _playerDao = PlayerDao();
  bool _initialized = false;

  // 获取器
  List<Player> get players => _players;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasPlayers => _players.isNotEmpty;
  bool get isInitialized => _initialized;

  // 构造函数，初始化时自动加载玩家列表
  PlayerProvider() {
    loadPlayers();
  }

  // 加载玩家列表
  Future<void> loadPlayers({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final players = await _playerDao.findAll(forceRefresh: forceRefresh);
      _players = players;
      _error = null;
      _initialized = true;
    } catch (e) {
      _error = e.toString();
      log('加载玩家列表失败: $e');
      // 如果数据库未初始化，我们不抛出异常，而是返回空列表
      _players = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 刷新玩家列表
  Future<void> refreshPlayers() async {
    return loadPlayers(forceRefresh: true);
  }

  // 添加玩家后刷新列表
  Future<void> addPlayer(Player player) async {
    // 这里假设有个添加玩家的方法，实际根据您的DAO实现
    // await _playerDao.insertPlayer(player);
    return refreshPlayers();
  }

  // 根据ID查找玩家
  Player? findPlayerById(int id) {
    try {
      return _players.firstWhere((player) => player.id == id);
    } catch (e) {
      return null;
    }
  }

  // 根据名称查找玩家
  Player? findPlayerByName(String name) {
    try {
      return _players.firstWhere((player) => player.name == name);
    } catch (e) {
      return null;
    }
  }
}
