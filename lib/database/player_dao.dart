import 'package:logging/logging.dart';

import '../models/db_player.dart';
import 'database_manager.dart';

class PlayerDao {
  static final PlayerDao _instance = PlayerDao._internal();
  factory PlayerDao() => _instance;
  PlayerDao._internal();

  final DatabaseManager _db = DatabaseManager();
  final log = Logger('PlayerDao');

  // 缓存相关
  List<Player>? _cachedPlayers;
  DateTime? _lastCacheTime;
  // 将缓存有效期增加到30分钟，因为玩家列表变化不频繁
  static const Duration _cacheExpiration = Duration(days: 1);

  Future<List<Player>> findAll({bool forceRefresh = false}) async {
    // 如果强制刷新或缓存失效，则从数据库获取
    if (forceRefresh || !isCacheValid()) {
      return _fetchFromDatabase();
    }
    return _cachedPlayers!;
  }

  // 从数据库获取玩家列表并更新缓存
  Future<List<Player>> _fetchFromDatabase() async {
    try {
      final res = await _db.execute('SELECT * FROM players ORDER BY name');
      final List<dynamic> results = res['results'] ?? [];

      _cachedPlayers = results.map((map) => Player.fromMap(map)).toList();
      _lastCacheTime = DateTime.now();
      log.info('已从数据库加载玩家列表: ${_cachedPlayers!.length}个玩家');
      return _cachedPlayers!;
    } catch (e) {
      log.warning('获取玩家列表失败，详细错误: $e');
      log.warning('错误堆栈: ${StackTrace.current}');
      return [];
    }
  }

  // 强制刷新缓存
  Future<List<Player>> refreshCache() async {
    return findAll(forceRefresh: true);
  }

  // 检查缓存是否有效
  bool isCacheValid() {
    return _cachedPlayers != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
