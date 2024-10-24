import 'dart:io';
import 'package:flutter/material.dart';
import '../models/metadata.dart';
import '../services/photo_service.dart';

class EditPhotoScreen extends StatefulWidget {
  final String photoPath;
  final String location;
  final String weather;

  const EditPhotoScreen({
    Key? key,
    required this.photoPath,
    required this.location,
    required this.weather,
  }) : super(key: key);

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final PhotoService _photoService = PhotoService();
  bool _isSaving = false;

  Future<void> _savePhoto() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a description')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final metadata = PhotoMetadata(
        path: widget.photoPath,
        description: _descriptionController.text,
        location: widget.location,
        weather: widget.weather,
        timestamp: DateTime.now().toString(),
      );

      await _photoService.savePhoto(metadata);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving photo: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Description'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.file(
                File(widget.photoPath),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for your photo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 8),
            Text(widget.location),
            Text(widget.weather),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSaving ? null : _savePhoto,
              child: _isSaving
                  ? CircularProgressIndicator()
                  : Text('SAVE PHOTO'),
            ),
          ],
        ),
      ),
    );
  }
}