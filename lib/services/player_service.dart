import 'package:logging/logging.dart';
import 'package:poker/models/db_player.dart';
import 'package:poker/utils/api_client.dart';

class PlayerService extends ApiClient {
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
    final response = await get<List<dynamic>>('/players');

    _cachedPlayers = response.data.map((map) => Player.fromMap(map)).toList();
    _lastCacheTime = DateTime.now();
    log.info('已从服务器加载玩家列表: ${_cachedPlayers!.length}个玩家');

    return _cachedPlayers!;
  }

  // 检查缓存是否有效
  bool isCacheValid() {
    return _cachedPlayers != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration;
  }
}
