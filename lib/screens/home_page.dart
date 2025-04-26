import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'score_page/score_page.dart';
import 'players_page.dart';
import '../providers/player_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  static final List<Widget> _pages = [const ScorePage(), const PlayersPage()];

  @override
  void initState() {
    super.initState();
    // 使用Provider获取玩家数据，不需要在这里单独加载
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 监听玩家列表的变化 (虽然在这个组件中没有直接使用)
    final playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    return Scaffold(
      body: _pages[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: '对战',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: '统计'),
        ],
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
