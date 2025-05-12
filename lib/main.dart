import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';
import 'screens/home/home.dart';
import 'utils/setup_log.dart';
import 'utils/message.dart';

void main() async {
  setupLog();
  final log = Logger('FlutterError');

  FlutterError.onError = (FlutterErrorDetails details) {
    log.severe('Flutter 框架异常: ${details.exception}');
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      log.severe(error.toString());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PlayerProvider())],
      child: MaterialApp(
        scaffoldMessengerKey: Message().scaffoldMessengerKey,
        title: '双扣积分榜',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const HomePage(),
      ),
    );
  }
}
