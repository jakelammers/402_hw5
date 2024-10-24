import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// HomeScreen now incorporates camera functionality
class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({super.key, required this.camera});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  late Future<void> _cameraReady;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _cameraReady = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: FutureBuilder<void>(
        future: _cameraReady,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: _imagePath == null
                    ? CameraPreview(_controller)
                    : Image.file(File(_imagePath!)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () async {
                    try {
                      await _cameraReady;
                      final image = await _controller.takePicture();
                      setState(() {
                        _imagePath = image.path;
                      });
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: Text(_imagePath == null ? 'Take Picture' : 'Retake Picture'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
