import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'edit_screen.dart';
import 'edit_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  String location = 'Loading location...';
  String weather = 'Loading weather...';
  XFile? photoFile;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
    _startLocationAndWeatherUpdates();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw 'No cameras available';
    }

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    return _controller!.initialize();
  }

  Future<void> _startLocationAndWeatherUpdates() async {
    final locationService = LocationService();
    final weatherService = WeatherService();

    try {
      final position = await locationService.getCurrentPosition();
      final address = await locationService.getAddressFromCoordinates(position);
      final weatherData = await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      setState(() {
        location = address;
        weather = '${weatherData.temperature}°C ${weatherData.condition}';
      });
    } catch (e) {
      print('Error getting location or weather: $e');
      setState(() {
        location = 'Location unavailable';
        weather = 'Weather unavailable';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take Photo')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (_controller == null || !_controller!.value.isInitialized) {
                    return Center(
                      child: Text('Failed to initialize camera'),
                    );
                  }

                  return photoFile == null
                      ? CameraPreview(_controller!)
                      : Image.file(File(photoFile!.path));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(location),
                Text(weather),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (photoFile == null)
                      FloatingActionButton(
                        onPressed: _takePhoto,
                        child: Icon(Icons.camera),
                      )
                    else ...[
                      ElevatedButton(
                        onPressed: () => _savePhoto(context),
                        child: Text('SAVE'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => photoFile = null),
                        child: Text('RETAKE'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      await _initializeControllerFuture;
      if (_controller == null) return;

      final photo = await _controller!.takePicture();
      setState(() {
        photoFile = photo;
      });
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  void _savePhoto(BuildContext context) {
    if (photoFile != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditPhotoScreen(
            photoPath: photoFile!.path,
            location: location,
            weather: weather,
          ),
        ),
      );
    }
  }
}