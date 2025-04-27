import 'package:logging/logging.dart';

String _getLevelEmoji(Level level) {
  switch (level.name) {
    case 'INFO':
      return 'ℹ️';
    case 'WARNING':
      return '⚠️';
    case 'SEVERE':
      return '🔴';
    default:
      return '🔵';
  }
}

void setupLog() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    final emoji = _getLevelEmoji(record.level);
    // ignore: avoid_print
    print('$emoji ${record.time} ${record.loggerName}: ${record.message}');
  });
}
