class Player {
  final int id;
  final String name;
  final String avatar;
  final DateTime createdAt;

  Player({
    required this.id,
    required this.name,
    String? avatar,
    DateTime? createdAt,
  }) : avatar = avatar ?? name,
       createdAt = createdAt ?? DateTime.now();

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
