import 'package:logging/logging.dart';
import 'package:poker/models/db_player.dart' as model;
import 'package:poker/utils/api_client.dart';
import 'package:poker/models/api_error_response.dart';
import 'package:poker/utils/message.dart';
import 'package:poker/database/player.dart' as db;
import 'package:drift/drift.dart' show Value;

class PlayerService extends ApiClient {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final log = Logger('PlayerService');
  final _message = Message();
  final _database = db.AppDatabase();

  // 获取所有玩家，优先从本地获取
  Future<List<model.Player>> getAllPlayers() async {
    final localPlayers = await _database.getAllPlayers();
    if (localPlayers.isNotEmpty) {
      if (await _database.needsSync()) {
        _syncWithServer();
      }

      return localPlayers
          .map(
            (p) => model.Player(
              id: p.id,
              name: p.name,
              avatar: p.avatar,
              createdAt: p.createdAt,
            ),
          )
          .toList();
    }
    return _getAllPlayersFromServer();
  }

  // 从服务器获取玩家列表
  Future<List<model.Player>> _getAllPlayersFromServer() async {
    try {
      final response = await get<List<dynamic>>('/players');
      final players =
          response.data.map((map) => model.Player.fromMap(map)).toList();

      // 保存到本地数据库
      await _savePlayersToLocal(players);

      log.info('已从服务器加载玩家列表: ${players.length}个玩家');
      return players;
    } on ApiErrorResponse catch (e) {
      _message.showError('从服务器加载玩家列表失败: ${e.message}');
      return [];
    }
  }

  // 在后台同步数据
  Future<void> _syncWithServer() async {
    try {
      final response = await get<List<dynamic>>('/players');
      final players =
          response.data.map((map) => model.Player.fromMap(map)).toList();

      // 保存到本地数据库
      await _savePlayersToLocal(players);

      log.info('已同步玩家列表: ${players.length}个玩家');
    } catch (e) {
      log.warning('同步玩家列表失败: $e');
    }
  }

  // 保存玩家列表到本地数据库
  Future<void> _savePlayersToLocal(List<model.Player> players) async {
    final companions =
        players
            .map(
              (p) => db.PlayersCompanion(
                id: Value(p.id),
                name: Value(p.name),
                avatar: Value(p.avatar),
                createdAt: Value(p.createdAt),
              ),
            )
            .toList();

    await _database.insertOrUpdatePlayers(companions);
    await _database.updateLastSyncTime();
  }
}
