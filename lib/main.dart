import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/score_page.dart';
import 'services/database_migration_service.dart';
import 'config/database_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载环境变量
  await dotenv.load(fileName: ".env");

  // 验证数据库配置
  DatabaseConfig.validate();

  // 初始化数据库
  final migrationService = DatabaseMigrationService();
  try {
    await migrationService.initialize();
  } catch (e) {
    print('数据库初始化失败: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '扑克积分',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const ScorePage(),
    );
  }
}
