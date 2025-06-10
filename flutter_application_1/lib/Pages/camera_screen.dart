import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraScreen extends StatefulWidget {
  final CameraDescription camera; // Recibimos la cámara desde fuera

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _logger.i('Inicializando CameraScreen');

    // Inicializa la cámara con la cámara recibida
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _logger.i('Liberando CameraScreen');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capturar Foto')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al inicializar la cámara',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final directory = await getApplicationDocumentsDirectory();
            final imagePath = path.join(
              directory.path,
              'photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
            );

            final image = await _controller.takePicture();
            await image.saveTo(imagePath);

            _logger.i('Foto capturada y guardada: $imagePath');

            if (!context.mounted) return;
            Navigator.of(context).pop(imagePath);
          } catch (e) {
            _logger.e('Error al capturar la foto: $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al capturar la foto: $e')),
              );
            }
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
