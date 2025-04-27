import 'package:flutter/material.dart';

/// 显示加载中状态的视图组件
class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('双扣积分')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
