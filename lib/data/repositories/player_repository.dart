import 'package:poker/data/local/app_database.dart';
import 'package:poker/data/remote/services/player_service.dart';
import 'package:poker/domains/player_entity.dart';

class PlayerRepository {
  final AppDatabase _db = AppDatabase();
  final PlayerService _playerService = PlayerService();

  Future<List<PlayerEntity>> getAllPlayers() async {
    // 优先从本地获取
    final localPlayers = await _db.getAllPlayers();
    if (localPlayers.isNotEmpty) {
      return localPlayers
          .map((player) => PlayerEntity.fromLocal(player))
          .toList();
    }

    // 本地无数据从远程获取
    final remotePlayers = await _playerService.getAllPlayers();
    final players =
        remotePlayers.map((player) => PlayerEntity.fromRemote(player)).toList();

    // 将远程数据转换为本地数据库格式并缓存
    await _db.insertOrUpdatePlayers(
      players.map((player) => player.toPlayersCompanion()).toList(),
    );

    return players;
  }
}
