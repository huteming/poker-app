import 'package:flutter/material.dart';

/// 显示加载中状态的视图组件
class ScorePageLoadingView extends StatelessWidget {
  const ScorePageLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('本局积分')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
