import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  final Function(File? url) onUploadComplete; // The callback
  const ImageUpload({super.key,required this.onUploadComplete});
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUpload() async {
    // 1. Pick the image from gallery
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Pro-tip: Compress a bit to save S3 costs!
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      widget.onUploadComplete(_selectedImage);

      // 2. Call your existing MinIO upload function
      //await uploadFile(pickedFile.path); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedImage != null)
          Image.file(_selectedImage!, height: 200)
        else
          Placeholder(fallbackHeight: 200),
          
        ElevatedButton.icon(
          onPressed: _pickAndUpload,
          icon: Icon(Icons.photo_library),
          label: Text("Pick & Upload to S3"),
        ),
      ],
    );
  }
}