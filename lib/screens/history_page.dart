import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '历史记录查询功能',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '这里将显示已结算的游戏记录',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
