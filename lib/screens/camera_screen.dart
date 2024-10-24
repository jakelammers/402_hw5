// screens/camera_screen.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'edit_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String location = 'Loading location...';
  String weather = 'Loading weather...';
  XFile? photoFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startLocationAndWeatherUpdates();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
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
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
                  return photoFile == null
                      ? CameraPreview(_controller)
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
      final photo = await _controller.takePicture();
      setState(() {
        photoFile = photo;
      });
    } catch (e) {
      print('Error taking photo: $e');
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