import '../models/player.dart';
import 'database_service.dart';

class PlayerService {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // 缓存相关
  List<Player>? _cachedPlayers;
  DateTime? _lastCacheTime;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  // 获取所有玩家（带缓存）
  Future<List<Player>> getAllPlayers({bool forceRefresh = false}) async {
    // 如果有缓存且未过期且不强制刷新，直接返回缓存
    if (!forceRefresh &&
        _cachedPlayers != null &&
        _lastCacheTime != null &&
        DateTime.now().difference(_lastCacheTime!) < _cacheExpiration) {
      print('使用缓存的玩家列表，缓存时间: $_lastCacheTime');
      return _cachedPlayers!;
    }

    try {
      print('从数据库获取玩家列表');
      final result = await _databaseService.executeQuery(
        'SELECT * FROM players ORDER BY created_at DESC',
      );

      final List<dynamic> results = result['results'] ?? [];
      print('解析结果列表: $results');
      print('结果数量: ${results.length}');

      if (results.isEmpty) {
        print('警告：没有找到任何玩家数据');
      } else {
        print('第一条数据示例: ${results[0]}');
      }

      // 更新缓存
      _cachedPlayers =
          results.map((data) {
            print('正在解析玩家数据: $data');
            return Player(
              id: data['id'] as int,
              name: data['name'] as String,
              avatar: data['avatar'] as String?,
              createdAt: DateTime.parse(data['created_at'] as String),
            );
          }).toList();
      _lastCacheTime = DateTime.now();

      return _cachedPlayers!;
    } catch (e) {
      print('获取玩家列表失败，详细错误: $e');
      print('错误堆栈: ${StackTrace.current}');
      rethrow;
    }
  }

  // 清除缓存
  void clearCache() {
    print('清除玩家列表缓存');
    _cachedPlayers = null;
    _lastCacheTime = null;
  }

  // 添加新玩家（添加后清除缓存）
  Future<Player> addPlayer(String name, {String? avatar}) async {
    try {
      print('正在添加玩家: $name');

      // 第一步：插入数据
      final insertResult = await _databaseService.executeQuery(
        'INSERT INTO players (name, avatar) VALUES (?, ?)',
        [name, avatar],
      );
      print('插入结果: $insertResult');

      // 第二步：获取最后插入的玩家
      final result = await _databaseService.executeQuery(
        'SELECT * FROM players WHERE id = last_insert_rowid()',
      );
      print('查询结果: $result');

      final List<dynamic> results = result['results'] ?? [];
      if (results.isEmpty) {
        print('数据库返回结果为空');
        throw Exception('添加玩家失败: 无法获取新增的玩家数据');
      }

      final playerData = results[0];
      print('新增玩家数据: $playerData');

      // 清除缓存，因为数据已经变更
      clearCache();

      return Player(
        id: playerData['id'] as int,
        name: playerData['name'] as String,
        avatar: playerData['avatar'] as String?,
        createdAt: DateTime.parse(playerData['created_at'] as String),
      );
    } catch (e) {
      print('添加玩家失败，详细错误: $e');
      rethrow;
    }
  }

  // 根据ID获取玩家（优先从缓存中查找）
  Future<Player?> getPlayerById(int id) async {
    // 如果有缓存，先从缓存中查找
    if (_cachedPlayers != null) {
      final cachedPlayer = _cachedPlayers!.firstWhere(
        (p) => p.id == id,
        orElse: () => throw Exception('未找到玩家'),
      );
      return cachedPlayer;
    }

    try {
      final result = await _databaseService.executeQuery(
        'SELECT * FROM players WHERE id = ?',
        [id],
      );

      final List<dynamic> results = result['results'] ?? [];
      if (results.isEmpty) {
        return null;
      }

      final data = results[0];
      return Player(
        id: data['id'] as int,
        name: data['name'] as String,
        avatar: data['avatar'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (e) {
      print('获取玩家失败: $e');
      rethrow;
    }
  }

  // 更新玩家信息（更新后清除缓存）
  Future<Player> updatePlayer(Player player) async {
    try {
      final result = await _databaseService.executeQuery(
        'UPDATE players SET name = ?, avatar = ? WHERE id = ? RETURNING *',
        [player.name, player.avatar, player.id],
      );

      final List<dynamic> results = result['results'] ?? [];
      if (results.isEmpty) {
        throw Exception('更新玩家失败');
      }

      final data = results[0];

      // 清除缓存，因为数据已经变更
      clearCache();

      return Player(
        id: data['id'] as int,
        name: data['name'] as String,
        avatar: data['avatar'] as String?,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (e) {
      print('更新玩家失败: $e');
      rethrow;
    }
  }

  // 删除玩家（删除后清除缓存）
  Future<bool> deletePlayer(int id) async {
    try {
      final result = await _databaseService.executeQuery(
        'DELETE FROM players WHERE id = ? RETURNING id',
        [id],
      );

      final List<dynamic> results = result['results'] ?? [];

      // 清除缓存，因为数据已经变更
      clearCache();

      return results.isNotEmpty;
    } catch (e) {
      print('删除玩家失败: $e');
      rethrow;
    }
  }
}
