import 'dart:io';

import 'package:flutter/material.dart';
import '../models/metadata.dart';
import '../services/photo_service.dart';

/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * home screen for the windowpane app
 */
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
    return Scaffold(
      backgroundColor: Colors.grey[100],  // Set background color for the screen
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search photos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),  // Rounded corners
                ),
                filled: true,
                fillColor: Colors.white,  // White background for the search bar
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
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
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,  // Add shadow to the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.file(
                              File(photo.path),
                              fit: BoxFit.cover,  // Fill the container nicely
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,  // Bold title
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8.0),  // Spacing between texts
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16.0),
                                  SizedBox(width: 4.0),
                                  Text(photo.timestamp),
                                ],
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 16.0),
                                  SizedBox(width: 4.0),
                                  Text(photo.location),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
