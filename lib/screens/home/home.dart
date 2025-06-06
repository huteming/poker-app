import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/player_provider.dart';
import '../score_page/score_page.dart';
import '../player_list/player_list.dart';
import 'widgets/home_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  static final List<Widget> _pages = [
    const ScorePage(),
    const PlayerListPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, playerProvider, child) {
        if (playerProvider.isLoading) {
          return const HomeLoadingView();
        }

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
            onTap: _onTabTapped,
          ),
        );
      },
    );
  }
}
