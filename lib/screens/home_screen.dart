import 'dart:io';

import 'package:flutter/material.dart';
import '../models/metadata.dart';
import '../services/photo_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PhotoService _photoService = PhotoService();
  List<PhotoMetadata> photos = [];
  int currentIndex = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final loadedPhotos = await _photoService.getPhotos(
      search: searchController.text.isEmpty ? null : searchController.text,
    );
    setState(() {
      photos = loadedPhotos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search photos...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _loadPhotos(),
          ),
        ),
        Expanded(
          child: photos.isEmpty
              ? Center(child: Text('No photos yet'))
              : PageView.builder(
            itemCount: photos.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Column(
                children: [
                  Expanded(
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.description,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(photo.timestamp),
                        Text(photo.location),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}