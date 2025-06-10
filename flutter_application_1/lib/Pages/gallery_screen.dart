import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fultter_aplication_laboratorio/pages/preview_picture_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory(directory.path);
    final List<String> imagePaths =
        imageDir
            .listSync()
            .where(
              (item) =>
                  item is File &&
                  (item.path.endsWith('.jpg') || item.path.endsWith('.png')),
            )
            .map((item) => item.path)
            .toList();
    setState(() {
      _imagePaths = imagePaths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galería de Imágenes')),
      body:
          _imagePaths.isEmpty
              ? const Center(child: Text('No hay imágenes en la galería'))
              : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PreviewPictureScreen(
                                imagePath: _imagePaths[index],
                              ),
                        ),
                      );
                    },
                    child: Image.file(
                      File(_imagePaths[index]),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
    );
  }
}
