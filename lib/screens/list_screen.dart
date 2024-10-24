import 'dart:io';

import 'package:flutter/material.dart';
import '../models/metadata.dart';
import '../services/photo_service.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final PhotoService _photoService = PhotoService();
  List<PhotoMetadata> photos = [];
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

  Future<void> _deletePhoto(PhotoMetadata photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Photo'),
        content: Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed == true && photo.id != null) {
      await _photoService.deletePhoto(photo.id!);
      _loadPhotos();
    }
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
          child: ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Dismissible(
                key: Key(photo.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _deletePhoto(photo),
                child: ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.file(
                      File(photo.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(photo.description),
                  subtitle: Text(photo.timestamp),
                  onTap: () {
                    // Navigate to HomeScreen with this photo
                    Navigator.pushNamed(context, '/');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}