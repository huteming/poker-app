// bin/run_script.dart
import 'package:logging/logging.dart';
import 'package:poker/utils/setup_log.dart';

void myFunction() {
  setupLog();
  final log = Logger('test_script');

  log.info('Hello, world!');
  log.warning('Warning, world!');
  log.severe('Severe, world!');
}

void main() {
  myFunction();
}
