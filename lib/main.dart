import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_page.dart';
import 'config/database_config.dart';
import 'database/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 加载环境变量
  await dotenv.load(fileName: ".env");

  // 验证数据库配置
  try {
    DatabaseConfig.validate();
    await DatabaseManager().initialize();
    log('数据库迁移成功');
  } catch (e) {
    if (e.toString().contains('Cloudflare configuration is missing')) {
      log('数据库配置验证失败: $e');
    } else {
      log('数据库迁移失败: $e');
    }
    rethrow;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '双扣积分',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomePage(),
    );
  }
}
