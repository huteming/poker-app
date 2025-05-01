import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:poker/models/db_player.dart';
import 'base_service.dart';

class PlayerService extends BaseService {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final log = Logger('PlayerService');

  // 缓存相关
  List<Player>? _cachedPlayers;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(days: 1);

  Future<List<Player>> getAllPlayers() async {
    if (!isCacheValid()) {
      return _getAllPlayersFromServer();
    }
    return _cachedPlayers!;
  }

  Future<List<Player>> _getAllPlayersFromServer() async {
    try {
      final response = await get('/players');

      if (response.statusCode == 200) {
        final String responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(responseBody);
        _cachedPlayers = data.map((map) => Player.fromMap(map)).toList();
        _lastCacheTime = DateTime.now();
        log.info('已从服务器加载玩家列表: ${_cachedPlayers!.length}个玩家');
        return _cachedPlayers!;
      } else {
        log.warning('获取玩家列表失败，状态码: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log.warning('获取玩家列表时发生错误: $e');
      return [];
    }
  }

  // 检查缓存是否有效
  bool isCacheValid() {
    return _cachedPlayers != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
