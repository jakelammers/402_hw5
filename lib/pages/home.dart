import 'dart:io';
import 'package:flutter/material.dart';
import '/models/metadata.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<PhotoMetadata> _photos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _photos.isEmpty
          ? Center(child: Text('No photos available'))
          : PageView.builder(
              itemCount: _photos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                PhotoMetadata photo = _photos[index];
                return Column(
                  children: [
                    Image.file(File(photo.path)),
                    Text(photo.description),
                    Text('Location: ${photo.location}'),
                    Text('Weather: ${photo.weather}'),
                    Text('Timestamp: ${photo.timestamp}'),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _takePhoto() async {
    // Camera and photo logic
  }
}
