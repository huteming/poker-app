import 'package:characters/characters.dart';

class Player {
  final int id;
  final String name;
  final String? avatar;
  final DateTime createdAt;

  Player({
    required this.id,
    required this.name,
    this.avatar,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get avatarText => avatar ?? name.characters.first;

  Player copyWith({
    int? id,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
