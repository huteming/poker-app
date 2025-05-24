import 'package:drift/drift.dart';
import 'package:poker/data/local/app_database.dart';

class PlayerEntity {
  final int id;
  final String name;
  final String avatar;
  final DateTime createdAt;

  PlayerEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  factory PlayerEntity.create({
    int? id,
    required String name,
    String? avatar,
    DateTime? createdAt,
  }) {
    return PlayerEntity(
      id: id ?? DateTime.now().millisecondsSinceEpoch,
      name: name,
      avatar: avatar ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  factory PlayerEntity.fromLocal(Player player) {
    return PlayerEntity(
      id: player.id,
      name: player.name,
      avatar: player.avatar ?? '',
      createdAt: player.createdAt,
    );
  }

  factory PlayerEntity.fromRemote(dynamic player) {
    return PlayerEntity(
      id: player['id'],
      name: player['name'],
      avatar: player['avatar'] ?? '',
      createdAt: DateTime.parse(player['created_at']),
    );
  }

  PlayersCompanion toPlayersCompanion() {
    return PlayersCompanion.insert(
      name: name,
      avatar: Value(avatar),
      createdAt: Value(createdAt),
      lastSyncAt: Value(DateTime.now()),
    );
  }
}
