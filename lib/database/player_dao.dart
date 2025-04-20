import 'dart:developer';

import '../models/db_player.dart';
import 'database_manager.dart';

class PlayerDao {
  static final PlayerDao _instance = PlayerDao._internal();
  factory PlayerDao() => _instance;
  PlayerDao._internal();

  final DatabaseManager _db = DatabaseManager();

  // 缓存相关
  List<Player>? _cachedPlayers;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  Future<List<Player>> findAll() async {
    if (isCacheValid()) {
      return _cachedPlayers!;
    }

    try {
      final res = await _db.execute('SELECT * FROM players ORDER BY name');
      final List<dynamic> results = res['results'] ?? [];

      _cachedPlayers = results.map((map) => Player.fromMap(map)).toList();
      _lastCacheTime = DateTime.now();
      return _cachedPlayers!;
    } catch (e) {
      log('获取玩家列表失败，详细错误: $e');
      log('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  bool isCacheValid() {
    return _cachedPlayers != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
