import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text("TODO : Review")),
    Center(child: Text("TODO : My Library")),
    Center(child: Text("TODO : My Vocabulary")),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Sentence Breakdown')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'My Vocabulary',
          ),
        ],
      ),
    );
  }
}
