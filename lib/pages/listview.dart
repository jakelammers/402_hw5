import 'dart:io';
import 'package:flutter/material.dart';
import '/models/metadata.dart';

class ListViewScreen extends StatelessWidget {
  final List<PhotoMetadata> photos;

  ListViewScreen({required this.photos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        PhotoMetadata photo = photos[index];

        return Dismissible(
          key: Key(photo.path),
          background: Container(color: Colors.red),
          confirmDismiss: (direction) async {
            return await _confirmDelete(context);
          },
          onDismissed: (direction) {
            // Handle deletion
          },
          child: ListTile(
            leading: Image.file(File(photo.path)),
            title: Text(photo.description),
            subtitle: Text('${photo.timestamp}, ${photo.location}'),
            onTap: () {
              Navigator.pop(context, index);  // Go back to home screen with the selected photo
            },
          ),
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Do you want to delete this photo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete')),
        ],
      ),
    );
  }
}
