import 'package:logging/logging.dart';
import 'package:poker/data/local/app_database.dart';
import 'package:poker/data/remote/services/player_service.dart';
import 'package:poker/domains/player_entity.dart';
import 'dart:async';

class PlayerRepository {
  final AppDatabase _db = AppDatabase();
  final PlayerService _playerService = PlayerService();
  final _logger = Logger('PlayerRepository');

  // 添加 StreamController 用于通知数据更新
  final _playersController = StreamController<List<PlayerEntity>>.broadcast();

  // 对外暴露 Stream
  Stream<List<PlayerEntity>> get playersStream => _playersController.stream;

  Future<List<PlayerEntity>> getAllPlayers() async {
    final remoteFetcher = _fetchAndCacheRemoteData();
    final localPlayers = await _fetchLocalPlayers();

    if (localPlayers.isEmpty) {
      return remoteFetcher;
    }

    remoteFetcher.then((players) {
      _playersController.add(players);
    });

    return localPlayers;
  }

  Future<List<PlayerEntity>> _fetchAndCacheRemoteData() async {
    final players = await _fetchRemotePlayers();
    await _cachePlayers(players);
    return players;
  }

  Future<List<PlayerEntity>> _fetchLocalPlayers() async {
    final localPlayers = await _db.getAllPlayers();

    if (localPlayers.isEmpty) {
      return [];
    }

    return localPlayers
        .map((player) => PlayerEntity.fromLocal(player))
        .toList();
  }

  Future<List<PlayerEntity>> _fetchRemotePlayers() async {
    final remotePlayers = await _playerService.getAllPlayers();
    return remotePlayers
        .map((player) => PlayerEntity.fromRemote(player))
        .toList();
  }

  Future<void> _cachePlayers(List<PlayerEntity> players) async {
    await _db.insertOrUpdatePlayers(
      players.map((player) => player.toPlayersCompanion()).toList(),
    );
  }

  // 添加关闭方法，防止内存泄漏
  void dispose() {
    _playersController.close();
  }
}
