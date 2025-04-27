import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/database_config.dart';
import 'providers/player_provider.dart';
import 'screens/home/home.dart';
import 'utils/setup_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLog();

  await dotenv.load(fileName: ".env");

  final valid = DatabaseConfig.validate();
  if (!valid) {
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PlayerProvider())],
      child: MaterialApp(
        title: '双扣积分',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
        home: const HomePage(),
      ),
    );
  }
}
