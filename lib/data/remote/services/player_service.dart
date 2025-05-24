import 'package:logging/logging.dart';
import 'package:poker/utils/api_client.dart';
import 'package:poker/models/api_error_response.dart';
import 'package:poker/utils/message.dart';

class PlayerService extends ApiClient {
  static final PlayerService _instance = PlayerService._internal();
  factory PlayerService() => _instance;
  PlayerService._internal();

  final log = Logger('PlayerService');
  final _message = Message();

  /// 远程拉取
  Future<List<dynamic>> getAllPlayers() async {
    try {
      final response = await get<List<dynamic>>('/players');
      final players = response.data;
      log.info('已从服务器加载玩家列表: ${players.length}个玩家');
      return players;
    } on ApiErrorResponse catch (e) {
      _message.showError('从服务器加载玩家列表失败: ${e.message}');
      return [];
    }
  }
}
