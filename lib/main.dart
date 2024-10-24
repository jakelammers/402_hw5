import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hw5/pages/gridview.dart';
import 'pages/listview.dart'; // List view of photos
import 'pages/gridview.dart';
import 'pages/listview.dart'; // Grid view of photos

// A list of the available cameras on the device.
late final List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras on the device.
  _cameras = await availableCameras();

  runApp(const WindowPaneApp());
}

class WindowPaneApp extends StatelessWidget {
  const WindowPaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WindowPane',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScaffold(
              title: 'WindowPane',
              child: HomeScreen(camera: _cameras[0]),
            ),
        '/listView': (context) => MainScaffold(
              child: ListViewScreen(photos: [],),
              title: "List View",
            ),
        '/gridView': (context) => MainScaffold(
              child: GridViewScreen(photos: [],),
              title: "Grid View",
            ),
      },
    );
  }
}

// The HomeScreen widget will handle swipe navigation for photos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({required CameraDescription camera});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/camera');
            },
            child: const Text("Open Camera"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/listView');
            },
            child: const Text("View Photos (List)"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/gridView');
            },
            child: const Text("View Photos (Grid)"),
          ),
        ],
      ),
    );
  }
}

// MainScaffold is a custom widget to enforce consistent scaffold settings.
class MainScaffold extends StatelessWidget {
  final Widget child;
  final String title;

  const MainScaffold({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: 'Camera', icon: Icon(Icons.camera)),
          BottomNavigationBarItem(label: 'List View', icon: Icon(Icons.list)),
          BottomNavigationBarItem(label: 'Grid View', icon: Icon(Icons.grid_view)),
        ],
        onTap: (idx) => Navigator.of(context).pushReplacementNamed(
          switch (idx) {
            0 => '/camera',
            1 => '/listView',
            2 => '/gridView',
            _ => throw UnimplementedError(),
          },
        ),
      ),
    );
  }
}