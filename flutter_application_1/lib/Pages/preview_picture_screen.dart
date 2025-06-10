import 'dart:io';
import 'package:flutter/material.dart';

class PreviewPictureScreen extends StatelessWidget {
  final String imagePath;

  const PreviewPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vista Previa')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
