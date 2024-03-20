import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _screenIndex = 0;

  void _onTabItemSelect (int index) {
    setState(() => _screenIndex = index);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('First Screen'),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.airplane_ticket_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active_rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
        currentIndex: _screenIndex,
        onTap: _onTabItemSelect,
        selectedItemColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        unselectedItemColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
      ),
    );
  }
}
