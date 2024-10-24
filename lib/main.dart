import 'package:flutter/material.dart';
import 'package:hw5/pages/home.dart';
import 'package:hw5/pages/gridview.dart';
import 'package:hw5/pages/listview.dart';


void main() => runApp(WindowPaneApp());

class WindowPaneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> _screens = [HomeScreen(), ListViewScreen(photos: [],), GridViewScreen(photos: [],)];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WindowPane'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings navigation
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List View'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_on), label: 'Grid View'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}