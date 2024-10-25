import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hw5/screens/settings_screen.dart';
import 'models/settings.dart';
import 'screens/home_screen.dart';
import 'screens/list_screen.dart';
import 'screens/grid_screen.dart';
import 'screens/camera_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WindowPane',
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(settings: settings),
      routes: {
        '/settings': (context) => SettingsScreen(settings: settings),
        '/camera': (context) => CameraScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final AppSettings settings;

  const MainScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Add any initialization here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/camera'),
        child: const Icon(Icons.add_a_photo),
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
    );
  }

  @override
  void dispose() {
    // Add any cleanup here if needed
    super.dispose();
  }
}