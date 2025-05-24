// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlayersTable extends Players with TableInfo<$PlayersTable, Player> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    createdAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'players';
  @override
  VerificationContext validateIntegrity(
    Insertable<Player> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Player map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Player(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $PlayersTable createAlias(String alias) {
    return $PlayersTable(attachedDatabase, alias);
  }
}

class Player extends DataClass implements Insertable<Player> {
  final int id;
  final String name;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastSyncAt;
  const Player({
    required this.id,
    required this.name,
    this.avatar,
    required this.createdAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  PlayersCompanion toCompanion(bool nullToAbsent) {
    return PlayersCompanion(
      id: Value(id),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      createdAt: Value(createdAt),
      lastSyncAt:
          lastSyncAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastSyncAt),
    );
  }

  factory Player.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Player(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  Player copyWith({
    int? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => Player(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar.present ? avatar.value : this.avatar,
    createdAt: createdAt ?? this.createdAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  Player copyWithCompanion(PlayersCompanion data) {
    return Player(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Player(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatar, createdAt, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Player &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.createdAt == this.createdAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class PlayersCompanion extends UpdateCompanion<Player> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastSyncAt;
  const PlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  PlayersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatar = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Player> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (createdAt != null) 'created_at': createdAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  PlayersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastSyncAt,
  }) {
    return PlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $GameRecordsTable extends GameRecords
    with TableInfo<$GameRecordsTable, GameRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _player1IdMeta = const VerificationMeta(
    'player1Id',
  );
  @override
  late final GeneratedColumn<int> player1Id = GeneratedColumn<int>(
    'player1_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player2IdMeta = const VerificationMeta(
    'player2Id',
  );
  @override
  late final GeneratedColumn<int> player2Id = GeneratedColumn<int>(
    'player2_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player3IdMeta = const VerificationMeta(
    'player3Id',
  );
  @override
  late final GeneratedColumn<int> player3Id = GeneratedColumn<int>(
    'player3_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player4IdMeta = const VerificationMeta(
    'player4Id',
  );
  @override
  late final GeneratedColumn<int> player4Id = GeneratedColumn<int>(
    'player4_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player1BombScoreMeta = const VerificationMeta(
    'player1BombScore',
  );
  @override
  late final GeneratedColumn<int> player1BombScore = GeneratedColumn<int>(
    'player1_bomb_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player2BombScoreMeta = const VerificationMeta(
    'player2BombScore',
  );
  @override
  late final GeneratedColumn<int> player2BombScore = GeneratedColumn<int>(
    'player2_bomb_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player3BombScoreMeta = const VerificationMeta(
    'player3BombScore',
  );
  @override
  late final GeneratedColumn<int> player3BombScore = GeneratedColumn<int>(
    'player3_bomb_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player4BombScoreMeta = const VerificationMeta(
    'player4BombScore',
  );
  @override
  late final GeneratedColumn<int> player4BombScore = GeneratedColumn<int>(
    'player4_bomb_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player1FinalScoreMeta = const VerificationMeta(
    'player1FinalScore',
  );
  @override
  late final GeneratedColumn<int> player1FinalScore = GeneratedColumn<int>(
    'player1_final_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player2FinalScoreMeta = const VerificationMeta(
    'player2FinalScore',
  );
  @override
  late final GeneratedColumn<int> player2FinalScore = GeneratedColumn<int>(
    'player2_final_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player3FinalScoreMeta = const VerificationMeta(
    'player3FinalScore',
  );
  @override
  late final GeneratedColumn<int> player3FinalScore = GeneratedColumn<int>(
    'player3_final_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _player4FinalScoreMeta = const VerificationMeta(
    'player4FinalScore',
  );
  @override
  late final GeneratedColumn<int> player4FinalScore = GeneratedColumn<int>(
    'player4_final_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameResultTypeMeta = const VerificationMeta(
    'gameResultType',
  );
  @override
  late final GeneratedColumn<String> gameResultType = GeneratedColumn<String>(
    'game_result_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settlementStatusMeta = const VerificationMeta(
    'settlementStatus',
  );
  @override
  late final GeneratedColumn<String> settlementStatus = GeneratedColumn<String>(
    'settlement_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    player1Id,
    player2Id,
    player3Id,
    player4Id,
    player1BombScore,
    player2BombScore,
    player3BombScore,
    player4BombScore,
    player1FinalScore,
    player2FinalScore,
    player3FinalScore,
    player4FinalScore,
    gameResultType,
    settlementStatus,
    createdAt,
    updatedAt,
    remarks,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('player1_id')) {
      context.handle(
        _player1IdMeta,
        player1Id.isAcceptableOrUnknown(data['player1_id']!, _player1IdMeta),
      );
    } else if (isInserting) {
      context.missing(_player1IdMeta);
    }
    if (data.containsKey('player2_id')) {
      context.handle(
        _player2IdMeta,
        player2Id.isAcceptableOrUnknown(data['player2_id']!, _player2IdMeta),
      );
    } else if (isInserting) {
      context.missing(_player2IdMeta);
    }
    if (data.containsKey('player3_id')) {
      context.handle(
        _player3IdMeta,
        player3Id.isAcceptableOrUnknown(data['player3_id']!, _player3IdMeta),
      );
    } else if (isInserting) {
      context.missing(_player3IdMeta);
    }
    if (data.containsKey('player4_id')) {
      context.handle(
        _player4IdMeta,
        player4Id.isAcceptableOrUnknown(data['player4_id']!, _player4IdMeta),
      );
    } else if (isInserting) {
      context.missing(_player4IdMeta);
    }
    if (data.containsKey('player1_bomb_score')) {
      context.handle(
        _player1BombScoreMeta,
        player1BombScore.isAcceptableOrUnknown(
          data['player1_bomb_score']!,
          _player1BombScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player1BombScoreMeta);
    }
    if (data.containsKey('player2_bomb_score')) {
      context.handle(
        _player2BombScoreMeta,
        player2BombScore.isAcceptableOrUnknown(
          data['player2_bomb_score']!,
          _player2BombScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player2BombScoreMeta);
    }
    if (data.containsKey('player3_bomb_score')) {
      context.handle(
        _player3BombScoreMeta,
        player3BombScore.isAcceptableOrUnknown(
          data['player3_bomb_score']!,
          _player3BombScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player3BombScoreMeta);
    }
    if (data.containsKey('player4_bomb_score')) {
      context.handle(
        _player4BombScoreMeta,
        player4BombScore.isAcceptableOrUnknown(
          data['player4_bomb_score']!,
          _player4BombScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player4BombScoreMeta);
    }
    if (data.containsKey('player1_final_score')) {
      context.handle(
        _player1FinalScoreMeta,
        player1FinalScore.isAcceptableOrUnknown(
          data['player1_final_score']!,
          _player1FinalScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player1FinalScoreMeta);
    }
    if (data.containsKey('player2_final_score')) {
      context.handle(
        _player2FinalScoreMeta,
        player2FinalScore.isAcceptableOrUnknown(
          data['player2_final_score']!,
          _player2FinalScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player2FinalScoreMeta);
    }
    if (data.containsKey('player3_final_score')) {
      context.handle(
        _player3FinalScoreMeta,
        player3FinalScore.isAcceptableOrUnknown(
          data['player3_final_score']!,
          _player3FinalScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player3FinalScoreMeta);
    }
    if (data.containsKey('player4_final_score')) {
      context.handle(
        _player4FinalScoreMeta,
        player4FinalScore.isAcceptableOrUnknown(
          data['player4_final_score']!,
          _player4FinalScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_player4FinalScoreMeta);
    }
    if (data.containsKey('game_result_type')) {
      context.handle(
        _gameResultTypeMeta,
        gameResultType.isAcceptableOrUnknown(
          data['game_result_type']!,
          _gameResultTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gameResultTypeMeta);
    }
    if (data.containsKey('settlement_status')) {
      context.handle(
        _settlementStatusMeta,
        settlementStatus.isAcceptableOrUnknown(
          data['settlement_status']!,
          _settlementStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settlementStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameRecord(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      player1Id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player1_id'],
          )!,
      player2Id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player2_id'],
          )!,
      player3Id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player3_id'],
          )!,
      player4Id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player4_id'],
          )!,
      player1BombScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player1_bomb_score'],
          )!,
      player2BombScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player2_bomb_score'],
          )!,
      player3BombScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player3_bomb_score'],
          )!,
      player4BombScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player4_bomb_score'],
          )!,
      player1FinalScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player1_final_score'],
          )!,
      player2FinalScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player2_final_score'],
          )!,
      player3FinalScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player3_final_score'],
          )!,
      player4FinalScore:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}player4_final_score'],
          )!,
      gameResultType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game_result_type'],
          )!,
      settlementStatus:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}settlement_status'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      ),
    );
  }

  @override
  $GameRecordsTable createAlias(String alias) {
    return $GameRecordsTable(attachedDatabase, alias);
  }
}

class GameRecord extends DataClass implements Insertable<GameRecord> {
  final int id;
  final int player1Id;
  final int player2Id;
  final int player3Id;
  final int player4Id;
  final int player1BombScore;
  final int player2BombScore;
  final int player3BombScore;
  final int player4BombScore;
  final int player1FinalScore;
  final int player2FinalScore;
  final int player3FinalScore;
  final int player4FinalScore;
  final String gameResultType;
  final String settlementStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? remarks;
  const GameRecord({
    required this.id,
    required this.player1Id,
    required this.player2Id,
    required this.player3Id,
    required this.player4Id,
    required this.player1BombScore,
    required this.player2BombScore,
    required this.player3BombScore,
    required this.player4BombScore,
    required this.player1FinalScore,
    required this.player2FinalScore,
    required this.player3FinalScore,
    required this.player4FinalScore,
    required this.gameResultType,
    required this.settlementStatus,
    required this.createdAt,
    required this.updatedAt,
    this.remarks,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['player1_id'] = Variable<int>(player1Id);
    map['player2_id'] = Variable<int>(player2Id);
    map['player3_id'] = Variable<int>(player3Id);
    map['player4_id'] = Variable<int>(player4Id);
    map['player1_bomb_score'] = Variable<int>(player1BombScore);
    map['player2_bomb_score'] = Variable<int>(player2BombScore);
    map['player3_bomb_score'] = Variable<int>(player3BombScore);
    map['player4_bomb_score'] = Variable<int>(player4BombScore);
    map['player1_final_score'] = Variable<int>(player1FinalScore);
    map['player2_final_score'] = Variable<int>(player2FinalScore);
    map['player3_final_score'] = Variable<int>(player3FinalScore);
    map['player4_final_score'] = Variable<int>(player4FinalScore);
    map['game_result_type'] = Variable<String>(gameResultType);
    map['settlement_status'] = Variable<String>(settlementStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String>(remarks);
    }
    return map;
  }

  GameRecordsCompanion toCompanion(bool nullToAbsent) {
    return GameRecordsCompanion(
      id: Value(id),
      player1Id: Value(player1Id),
      player2Id: Value(player2Id),
      player3Id: Value(player3Id),
      player4Id: Value(player4Id),
      player1BombScore: Value(player1BombScore),
      player2BombScore: Value(player2BombScore),
      player3BombScore: Value(player3BombScore),
      player4BombScore: Value(player4BombScore),
      player1FinalScore: Value(player1FinalScore),
      player2FinalScore: Value(player2FinalScore),
      player3FinalScore: Value(player3FinalScore),
      player4FinalScore: Value(player4FinalScore),
      gameResultType: Value(gameResultType),
      settlementStatus: Value(settlementStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      remarks:
          remarks == null && nullToAbsent
              ? const Value.absent()
              : Value(remarks),
    );
  }

  factory GameRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameRecord(
      id: serializer.fromJson<int>(json['id']),
      player1Id: serializer.fromJson<int>(json['player1Id']),
      player2Id: serializer.fromJson<int>(json['player2Id']),
      player3Id: serializer.fromJson<int>(json['player3Id']),
      player4Id: serializer.fromJson<int>(json['player4Id']),
      player1BombScore: serializer.fromJson<int>(json['player1BombScore']),
      player2BombScore: serializer.fromJson<int>(json['player2BombScore']),
      player3BombScore: serializer.fromJson<int>(json['player3BombScore']),
      player4BombScore: serializer.fromJson<int>(json['player4BombScore']),
      player1FinalScore: serializer.fromJson<int>(json['player1FinalScore']),
      player2FinalScore: serializer.fromJson<int>(json['player2FinalScore']),
      player3FinalScore: serializer.fromJson<int>(json['player3FinalScore']),
      player4FinalScore: serializer.fromJson<int>(json['player4FinalScore']),
      gameResultType: serializer.fromJson<String>(json['gameResultType']),
      settlementStatus: serializer.fromJson<String>(json['settlementStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      remarks: serializer.fromJson<String?>(json['remarks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'player1Id': serializer.toJson<int>(player1Id),
      'player2Id': serializer.toJson<int>(player2Id),
      'player3Id': serializer.toJson<int>(player3Id),
      'player4Id': serializer.toJson<int>(player4Id),
      'player1BombScore': serializer.toJson<int>(player1BombScore),
      'player2BombScore': serializer.toJson<int>(player2BombScore),
      'player3BombScore': serializer.toJson<int>(player3BombScore),
      'player4BombScore': serializer.toJson<int>(player4BombScore),
      'player1FinalScore': serializer.toJson<int>(player1FinalScore),
      'player2FinalScore': serializer.toJson<int>(player2FinalScore),
      'player3FinalScore': serializer.toJson<int>(player3FinalScore),
      'player4FinalScore': serializer.toJson<int>(player4FinalScore),
      'gameResultType': serializer.toJson<String>(gameResultType),
      'settlementStatus': serializer.toJson<String>(settlementStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'remarks': serializer.toJson<String?>(remarks),
    };
  }

  GameRecord copyWith({
    int? id,
    int? player1Id,
    int? player2Id,
    int? player3Id,
    int? player4Id,
    int? player1BombScore,
    int? player2BombScore,
    int? player3BombScore,
    int? player4BombScore,
    int? player1FinalScore,
    int? player2FinalScore,
    int? player3FinalScore,
    int? player4FinalScore,
    String? gameResultType,
    String? settlementStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> remarks = const Value.absent(),
  }) => GameRecord(
    id: id ?? this.id,
    player1Id: player1Id ?? this.player1Id,
    player2Id: player2Id ?? this.player2Id,
    player3Id: player3Id ?? this.player3Id,
    player4Id: player4Id ?? this.player4Id,
    player1BombScore: player1BombScore ?? this.player1BombScore,
    player2BombScore: player2BombScore ?? this.player2BombScore,
    player3BombScore: player3BombScore ?? this.player3BombScore,
    player4BombScore: player4BombScore ?? this.player4BombScore,
    player1FinalScore: player1FinalScore ?? this.player1FinalScore,
    player2FinalScore: player2FinalScore ?? this.player2FinalScore,
    player3FinalScore: player3FinalScore ?? this.player3FinalScore,
    player4FinalScore: player4FinalScore ?? this.player4FinalScore,
    gameResultType: gameResultType ?? this.gameResultType,
    settlementStatus: settlementStatus ?? this.settlementStatus,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    remarks: remarks.present ? remarks.value : this.remarks,
  );
  GameRecord copyWithCompanion(GameRecordsCompanion data) {
    return GameRecord(
      id: data.id.present ? data.id.value : this.id,
      player1Id: data.player1Id.present ? data.player1Id.value : this.player1Id,
      player2Id: data.player2Id.present ? data.player2Id.value : this.player2Id,
      player3Id: data.player3Id.present ? data.player3Id.value : this.player3Id,
      player4Id: data.player4Id.present ? data.player4Id.value : this.player4Id,
      player1BombScore:
          data.player1BombScore.present
              ? data.player1BombScore.value
              : this.player1BombScore,
      player2BombScore:
          data.player2BombScore.present
              ? data.player2BombScore.value
              : this.player2BombScore,
      player3BombScore:
          data.player3BombScore.present
              ? data.player3BombScore.value
              : this.player3BombScore,
      player4BombScore:
          data.player4BombScore.present
              ? data.player4BombScore.value
              : this.player4BombScore,
      player1FinalScore:
          data.player1FinalScore.present
              ? data.player1FinalScore.value
              : this.player1FinalScore,
      player2FinalScore:
          data.player2FinalScore.present
              ? data.player2FinalScore.value
              : this.player2FinalScore,
      player3FinalScore:
          data.player3FinalScore.present
              ? data.player3FinalScore.value
              : this.player3FinalScore,
      player4FinalScore:
          data.player4FinalScore.present
              ? data.player4FinalScore.value
              : this.player4FinalScore,
      gameResultType:
          data.gameResultType.present
              ? data.gameResultType.value
              : this.gameResultType,
      settlementStatus:
          data.settlementStatus.present
              ? data.settlementStatus.value
              : this.settlementStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameRecord(')
          ..write('id: $id, ')
          ..write('player1Id: $player1Id, ')
          ..write('player2Id: $player2Id, ')
          ..write('player3Id: $player3Id, ')
          ..write('player4Id: $player4Id, ')
          ..write('player1BombScore: $player1BombScore, ')
          ..write('player2BombScore: $player2BombScore, ')
          ..write('player3BombScore: $player3BombScore, ')
          ..write('player4BombScore: $player4BombScore, ')
          ..write('player1FinalScore: $player1FinalScore, ')
          ..write('player2FinalScore: $player2FinalScore, ')
          ..write('player3FinalScore: $player3FinalScore, ')
          ..write('player4FinalScore: $player4FinalScore, ')
          ..write('gameResultType: $gameResultType, ')
          ..write('settlementStatus: $settlementStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    player1Id,
    player2Id,
    player3Id,
    player4Id,
    player1BombScore,
    player2BombScore,
    player3BombScore,
    player4BombScore,
    player1FinalScore,
    player2FinalScore,
    player3FinalScore,
    player4FinalScore,
    gameResultType,
    settlementStatus,
    createdAt,
    updatedAt,
    remarks,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameRecord &&
          other.id == this.id &&
          other.player1Id == this.player1Id &&
          other.player2Id == this.player2Id &&
          other.player3Id == this.player3Id &&
          other.player4Id == this.player4Id &&
          other.player1BombScore == this.player1BombScore &&
          other.player2BombScore == this.player2BombScore &&
          other.player3BombScore == this.player3BombScore &&
          other.player4BombScore == this.player4BombScore &&
          other.player1FinalScore == this.player1FinalScore &&
          other.player2FinalScore == this.player2FinalScore &&
          other.player3FinalScore == this.player3FinalScore &&
          other.player4FinalScore == this.player4FinalScore &&
          other.gameResultType == this.gameResultType &&
          other.settlementStatus == this.settlementStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.remarks == this.remarks);
}

class GameRecordsCompanion extends UpdateCompanion<GameRecord> {
  final Value<int> id;
  final Value<int> player1Id;
  final Value<int> player2Id;
  final Value<int> player3Id;
  final Value<int> player4Id;
  final Value<int> player1BombScore;
  final Value<int> player2BombScore;
  final Value<int> player3BombScore;
  final Value<int> player4BombScore;
  final Value<int> player1FinalScore;
  final Value<int> player2FinalScore;
  final Value<int> player3FinalScore;
  final Value<int> player4FinalScore;
  final Value<String> gameResultType;
  final Value<String> settlementStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> remarks;
  const GameRecordsCompanion({
    this.id = const Value.absent(),
    this.player1Id = const Value.absent(),
    this.player2Id = const Value.absent(),
    this.player3Id = const Value.absent(),
    this.player4Id = const Value.absent(),
    this.player1BombScore = const Value.absent(),
    this.player2BombScore = const Value.absent(),
    this.player3BombScore = const Value.absent(),
    this.player4BombScore = const Value.absent(),
    this.player1FinalScore = const Value.absent(),
    this.player2FinalScore = const Value.absent(),
    this.player3FinalScore = const Value.absent(),
    this.player4FinalScore = const Value.absent(),
    this.gameResultType = const Value.absent(),
    this.settlementStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.remarks = const Value.absent(),
  });
  GameRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int player1Id,
    required int player2Id,
    required int player3Id,
    required int player4Id,
    required int player1BombScore,
    required int player2BombScore,
    required int player3BombScore,
    required int player4BombScore,
    required int player1FinalScore,
    required int player2FinalScore,
    required int player3FinalScore,
    required int player4FinalScore,
    required String gameResultType,
    required String settlementStatus,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.remarks = const Value.absent(),
  }) : player1Id = Value(player1Id),
       player2Id = Value(player2Id),
       player3Id = Value(player3Id),
       player4Id = Value(player4Id),
       player1BombScore = Value(player1BombScore),
       player2BombScore = Value(player2BombScore),
       player3BombScore = Value(player3BombScore),
       player4BombScore = Value(player4BombScore),
       player1FinalScore = Value(player1FinalScore),
       player2FinalScore = Value(player2FinalScore),
       player3FinalScore = Value(player3FinalScore),
       player4FinalScore = Value(player4FinalScore),
       gameResultType = Value(gameResultType),
       settlementStatus = Value(settlementStatus);
  static Insertable<GameRecord> custom({
    Expression<int>? id,
    Expression<int>? player1Id,
    Expression<int>? player2Id,
    Expression<int>? player3Id,
    Expression<int>? player4Id,
    Expression<int>? player1BombScore,
    Expression<int>? player2BombScore,
    Expression<int>? player3BombScore,
    Expression<int>? player4BombScore,
    Expression<int>? player1FinalScore,
    Expression<int>? player2FinalScore,
    Expression<int>? player3FinalScore,
    Expression<int>? player4FinalScore,
    Expression<String>? gameResultType,
    Expression<String>? settlementStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? remarks,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (player1Id != null) 'player1_id': player1Id,
      if (player2Id != null) 'player2_id': player2Id,
      if (player3Id != null) 'player3_id': player3Id,
      if (player4Id != null) 'player4_id': player4Id,
      if (player1BombScore != null) 'player1_bomb_score': player1BombScore,
      if (player2BombScore != null) 'player2_bomb_score': player2BombScore,
      if (player3BombScore != null) 'player3_bomb_score': player3BombScore,
      if (player4BombScore != null) 'player4_bomb_score': player4BombScore,
      if (player1FinalScore != null) 'player1_final_score': player1FinalScore,
      if (player2FinalScore != null) 'player2_final_score': player2FinalScore,
      if (player3FinalScore != null) 'player3_final_score': player3FinalScore,
      if (player4FinalScore != null) 'player4_final_score': player4FinalScore,
      if (gameResultType != null) 'game_result_type': gameResultType,
      if (settlementStatus != null) 'settlement_status': settlementStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (remarks != null) 'remarks': remarks,
    });
  }

  GameRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? player1Id,
    Value<int>? player2Id,
    Value<int>? player3Id,
    Value<int>? player4Id,
    Value<int>? player1BombScore,
    Value<int>? player2BombScore,
    Value<int>? player3BombScore,
    Value<int>? player4BombScore,
    Value<int>? player1FinalScore,
    Value<int>? player2FinalScore,
    Value<int>? player3FinalScore,
    Value<int>? player4FinalScore,
    Value<String>? gameResultType,
    Value<String>? settlementStatus,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? remarks,
  }) {
    return GameRecordsCompanion(
      id: id ?? this.id,
      player1Id: player1Id ?? this.player1Id,
      player2Id: player2Id ?? this.player2Id,
      player3Id: player3Id ?? this.player3Id,
      player4Id: player4Id ?? this.player4Id,
      player1BombScore: player1BombScore ?? this.player1BombScore,
      player2BombScore: player2BombScore ?? this.player2BombScore,
      player3BombScore: player3BombScore ?? this.player3BombScore,
      player4BombScore: player4BombScore ?? this.player4BombScore,
      player1FinalScore: player1FinalScore ?? this.player1FinalScore,
      player2FinalScore: player2FinalScore ?? this.player2FinalScore,
      player3FinalScore: player3FinalScore ?? this.player3FinalScore,
      player4FinalScore: player4FinalScore ?? this.player4FinalScore,
      gameResultType: gameResultType ?? this.gameResultType,
      settlementStatus: settlementStatus ?? this.settlementStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (player1Id.present) {
      map['player1_id'] = Variable<int>(player1Id.value);
    }
    if (player2Id.present) {
      map['player2_id'] = Variable<int>(player2Id.value);
    }
    if (player3Id.present) {
      map['player3_id'] = Variable<int>(player3Id.value);
    }
    if (player4Id.present) {
      map['player4_id'] = Variable<int>(player4Id.value);
    }
    if (player1BombScore.present) {
      map['player1_bomb_score'] = Variable<int>(player1BombScore.value);
    }
    if (player2BombScore.present) {
      map['player2_bomb_score'] = Variable<int>(player2BombScore.value);
    }
    if (player3BombScore.present) {
      map['player3_bomb_score'] = Variable<int>(player3BombScore.value);
    }
    if (player4BombScore.present) {
      map['player4_bomb_score'] = Variable<int>(player4BombScore.value);
    }
    if (player1FinalScore.present) {
      map['player1_final_score'] = Variable<int>(player1FinalScore.value);
    }
    if (player2FinalScore.present) {
      map['player2_final_score'] = Variable<int>(player2FinalScore.value);
    }
    if (player3FinalScore.present) {
      map['player3_final_score'] = Variable<int>(player3FinalScore.value);
    }
    if (player4FinalScore.present) {
      map['player4_final_score'] = Variable<int>(player4FinalScore.value);
    }
    if (gameResultType.present) {
      map['game_result_type'] = Variable<String>(gameResultType.value);
    }
    if (settlementStatus.present) {
      map['settlement_status'] = Variable<String>(settlementStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameRecordsCompanion(')
          ..write('id: $id, ')
          ..write('player1Id: $player1Id, ')
          ..write('player2Id: $player2Id, ')
          ..write('player3Id: $player3Id, ')
          ..write('player4Id: $player4Id, ')
          ..write('player1BombScore: $player1BombScore, ')
          ..write('player2BombScore: $player2BombScore, ')
          ..write('player3BombScore: $player3BombScore, ')
          ..write('player4BombScore: $player4BombScore, ')
          ..write('player1FinalScore: $player1FinalScore, ')
          ..write('player2FinalScore: $player2FinalScore, ')
          ..write('player3FinalScore: $player3FinalScore, ')
          ..write('player4FinalScore: $player4FinalScore, ')
          ..write('gameResultType: $gameResultType, ')
          ..write('settlementStatus: $settlementStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlayersTable players = $PlayersTable(this);
  late final $GameRecordsTable gameRecords = $GameRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [players, gameRecords];
}

typedef $$PlayersTableCreateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> avatar,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSyncAt,
    });
typedef $$PlayersTableUpdateCompanionBuilder =
    PlayersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> avatar,
      Value<DateTime> createdAt,
      Value<DateTime?> lastSyncAt,
    });

class $$PlayersTableFilterComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayersTable> {
  $$PlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$PlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayersTable,
          Player,
          $$PlayersTableFilterComposer,
          $$PlayersTableOrderingComposer,
          $$PlayersTableAnnotationComposer,
          $$PlayersTableCreateCompanionBuilder,
          $$PlayersTableUpdateCompanionBuilder,
          (Player, BaseReferences<_$AppDatabase, $PlayersTable, Player>),
          Player,
          PrefetchHooks Function()
        > {
  $$PlayersTableTableManager(_$AppDatabase db, $PlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => PlayersCompanion(
                id: id,
                name: name,
                avatar: avatar,
                createdAt: createdAt,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> avatar = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => PlayersCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                createdAt: createdAt,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayersTable,
      Player,
      $$PlayersTableFilterComposer,
      $$PlayersTableOrderingComposer,
      $$PlayersTableAnnotationComposer,
      $$PlayersTableCreateCompanionBuilder,
      $$PlayersTableUpdateCompanionBuilder,
      (Player, BaseReferences<_$AppDatabase, $PlayersTable, Player>),
      Player,
      PrefetchHooks Function()
    >;
typedef $$GameRecordsTableCreateCompanionBuilder =
    GameRecordsCompanion Function({
      Value<int> id,
      required int player1Id,
      required int player2Id,
      required int player3Id,
      required int player4Id,
      required int player1BombScore,
      required int player2BombScore,
      required int player3BombScore,
      required int player4BombScore,
      required int player1FinalScore,
      required int player2FinalScore,
      required int player3FinalScore,
      required int player4FinalScore,
      required String gameResultType,
      required String settlementStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> remarks,
    });
typedef $$GameRecordsTableUpdateCompanionBuilder =
    GameRecordsCompanion Function({
      Value<int> id,
      Value<int> player1Id,
      Value<int> player2Id,
      Value<int> player3Id,
      Value<int> player4Id,
      Value<int> player1BombScore,
      Value<int> player2BombScore,
      Value<int> player3BombScore,
      Value<int> player4BombScore,
      Value<int> player1FinalScore,
      Value<int> player2FinalScore,
      Value<int> player3FinalScore,
      Value<int> player4FinalScore,
      Value<String> gameResultType,
      Value<String> settlementStatus,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> remarks,
    });

class $$GameRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $GameRecordsTable> {
  $$GameRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player1Id => $composableBuilder(
    column: $table.player1Id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player2Id => $composableBuilder(
    column: $table.player2Id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player3Id => $composableBuilder(
    column: $table.player3Id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player4Id => $composableBuilder(
    column: $table.player4Id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player1BombScore => $composableBuilder(
    column: $table.player1BombScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player2BombScore => $composableBuilder(
    column: $table.player2BombScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player3BombScore => $composableBuilder(
    column: $table.player3BombScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player4BombScore => $composableBuilder(
    column: $table.player4BombScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player1FinalScore => $composableBuilder(
    column: $table.player1FinalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player2FinalScore => $composableBuilder(
    column: $table.player2FinalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player3FinalScore => $composableBuilder(
    column: $table.player3FinalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get player4FinalScore => $composableBuilder(
    column: $table.player4FinalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameResultType => $composableBuilder(
    column: $table.gameResultType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settlementStatus => $composableBuilder(
    column: $table.settlementStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameRecordsTable> {
  $$GameRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player1Id => $composableBuilder(
    column: $table.player1Id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player2Id => $composableBuilder(
    column: $table.player2Id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player3Id => $composableBuilder(
    column: $table.player3Id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player4Id => $composableBuilder(
    column: $table.player4Id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player1BombScore => $composableBuilder(
    column: $table.player1BombScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player2BombScore => $composableBuilder(
    column: $table.player2BombScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player3BombScore => $composableBuilder(
    column: $table.player3BombScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player4BombScore => $composableBuilder(
    column: $table.player4BombScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player1FinalScore => $composableBuilder(
    column: $table.player1FinalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player2FinalScore => $composableBuilder(
    column: $table.player2FinalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player3FinalScore => $composableBuilder(
    column: $table.player3FinalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get player4FinalScore => $composableBuilder(
    column: $table.player4FinalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameResultType => $composableBuilder(
    column: $table.gameResultType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settlementStatus => $composableBuilder(
    column: $table.settlementStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameRecordsTable> {
  $$GameRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get player1Id =>
      $composableBuilder(column: $table.player1Id, builder: (column) => column);

  GeneratedColumn<int> get player2Id =>
      $composableBuilder(column: $table.player2Id, builder: (column) => column);

  GeneratedColumn<int> get player3Id =>
      $composableBuilder(column: $table.player3Id, builder: (column) => column);

  GeneratedColumn<int> get player4Id =>
      $composableBuilder(column: $table.player4Id, builder: (column) => column);

  GeneratedColumn<int> get player1BombScore => $composableBuilder(
    column: $table.player1BombScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player2BombScore => $composableBuilder(
    column: $table.player2BombScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player3BombScore => $composableBuilder(
    column: $table.player3BombScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player4BombScore => $composableBuilder(
    column: $table.player4BombScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player1FinalScore => $composableBuilder(
    column: $table.player1FinalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player2FinalScore => $composableBuilder(
    column: $table.player2FinalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player3FinalScore => $composableBuilder(
    column: $table.player3FinalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get player4FinalScore => $composableBuilder(
    column: $table.player4FinalScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gameResultType => $composableBuilder(
    column: $table.gameResultType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settlementStatus => $composableBuilder(
    column: $table.settlementStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);
}

class $$GameRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameRecordsTable,
          GameRecord,
          $$GameRecordsTableFilterComposer,
          $$GameRecordsTableOrderingComposer,
          $$GameRecordsTableAnnotationComposer,
          $$GameRecordsTableCreateCompanionBuilder,
          $$GameRecordsTableUpdateCompanionBuilder,
          (
            GameRecord,
            BaseReferences<_$AppDatabase, $GameRecordsTable, GameRecord>,
          ),
          GameRecord,
          PrefetchHooks Function()
        > {
  $$GameRecordsTableTableManager(_$AppDatabase db, $GameRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GameRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GameRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$GameRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> player1Id = const Value.absent(),
                Value<int> player2Id = const Value.absent(),
                Value<int> player3Id = const Value.absent(),
                Value<int> player4Id = const Value.absent(),
                Value<int> player1BombScore = const Value.absent(),
                Value<int> player2BombScore = const Value.absent(),
                Value<int> player3BombScore = const Value.absent(),
                Value<int> player4BombScore = const Value.absent(),
                Value<int> player1FinalScore = const Value.absent(),
                Value<int> player2FinalScore = const Value.absent(),
                Value<int> player3FinalScore = const Value.absent(),
                Value<int> player4FinalScore = const Value.absent(),
                Value<String> gameResultType = const Value.absent(),
                Value<String> settlementStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
              }) => GameRecordsCompanion(
                id: id,
                player1Id: player1Id,
                player2Id: player2Id,
                player3Id: player3Id,
                player4Id: player4Id,
                player1BombScore: player1BombScore,
                player2BombScore: player2BombScore,
                player3BombScore: player3BombScore,
                player4BombScore: player4BombScore,
                player1FinalScore: player1FinalScore,
                player2FinalScore: player2FinalScore,
                player3FinalScore: player3FinalScore,
                player4FinalScore: player4FinalScore,
                gameResultType: gameResultType,
                settlementStatus: settlementStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                remarks: remarks,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int player1Id,
                required int player2Id,
                required int player3Id,
                required int player4Id,
                required int player1BombScore,
                required int player2BombScore,
                required int player3BombScore,
                required int player4BombScore,
                required int player1FinalScore,
                required int player2FinalScore,
                required int player3FinalScore,
                required int player4FinalScore,
                required String gameResultType,
                required String settlementStatus,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> remarks = const Value.absent(),
              }) => GameRecordsCompanion.insert(
                id: id,
                player1Id: player1Id,
                player2Id: player2Id,
                player3Id: player3Id,
                player4Id: player4Id,
                player1BombScore: player1BombScore,
                player2BombScore: player2BombScore,
                player3BombScore: player3BombScore,
                player4BombScore: player4BombScore,
                player1FinalScore: player1FinalScore,
                player2FinalScore: player2FinalScore,
                player3FinalScore: player3FinalScore,
                player4FinalScore: player4FinalScore,
                gameResultType: gameResultType,
                settlementStatus: settlementStatus,
                createdAt: createdAt,
                updatedAt: updatedAt,
                remarks: remarks,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameRecordsTable,
      GameRecord,
      $$GameRecordsTableFilterComposer,
      $$GameRecordsTableOrderingComposer,
      $$GameRecordsTableAnnotationComposer,
      $$GameRecordsTableCreateCompanionBuilder,
      $$GameRecordsTableUpdateCompanionBuilder,
      (
        GameRecord,
        BaseReferences<_$AppDatabase, $GameRecordsTable, GameRecord>,
      ),
      GameRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlayersTableTableManager get players =>
      $$PlayersTableTableManager(_db, _db.players);
  $$GameRecordsTableTableManager get gameRecords =>
      $$GameRecordsTableTableManager(_db, _db.gameRecords);
}
