import 'dart:io';

import 'package:flutter/material.dart';
import '../models/metadata.dart';
import '../services/photo_service.dart';

/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * Gridview screen for the windowpane app
 */
class GridScreen extends StatefulWidget {
  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
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
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    // Navigate to HomeScreen with this photo
                    Navigator.pushNamed(context, '/');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.file(
                          File(photo.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              photo.description,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              photo.timestamp,
                              style: Theme.of(context).textTheme.bodySmall,
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
    );
  }
}