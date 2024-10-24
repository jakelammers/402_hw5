import 'dart:io';
import 'package:flutter/material.dart';
import '/models/metadata.dart';


class GridViewScreen extends StatelessWidget {
  final List<PhotoMetadata> photos;

  GridViewScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        PhotoMetadata photo = photos[index];

        return GestureDetector(
          onTap: () {
            Navigator.pop(context, index);  // Go back to home screen
          },
          child: Card(
            child: Column(
              children: [
                Image.file(File(photo.path)),
                Text(photo.description),
                Text('${photo.timestamp}, ${photo.location}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
