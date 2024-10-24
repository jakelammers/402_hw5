// main.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hw5/screens/settings_screen.dart';
import 'models/settings.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/grid_screen.dart';
import 'screens/camera_screen.dart'; // Ensure this is imported
import 'services/database.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(WindowPaneApp());
}

class WindowPaneApp extends StatefulWidget {
  @override
  _WindowPaneAppState createState() => _WindowPaneAppState();
}

class _WindowPaneAppState extends State<WindowPaneApp> {
  final AppSettings settings = AppSettings();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WindowPane',
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      // Define your routes here
      routes: {
        '/settings': (context) => SettingsScreen(settings: settings), // Ensure this screen is defined
        '/camera': (context) => CameraScreen(), // Ensure you have a CameraScreen
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WindowPane'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(),
            ListScreen(),
            GridScreen(),
          ],
        ),
        floatingActionButton: Builder( // Use Builder to get a valid context
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => _openCamera(context), // Pass the context from Builder
              child: const Icon(Icons.add_a_photo),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Grid'),
          ],
        ),
      ),
    );
  }

  void _openCamera(BuildContext context) {
    // Now this context is valid for navigation
    print("Navigator context: $context");
    Navigator.pushNamed(context, '/camera');
  }
}
