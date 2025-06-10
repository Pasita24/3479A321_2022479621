import 'package:flutter/material.dart';
import 'package:fultter_aplication_laboratorio/pages/AboutUsScreen.dart';
import 'package:fultter_aplication_laboratorio/pages/ListContent.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:fultter_aplication_laboratorio/provider/app_data.dart';
import 'package:fultter_aplication_laboratorio/pages/preferencias.dart';
import 'package:fultter_aplication_laboratorio/pages/actividades_screen.dart';
import 'package:fultter_aplication_laboratorio/pages/camera_screen.dart';
import 'package:fultter_aplication_laboratorio/pages/preview_picture_screen.dart';
import 'package:fultter_aplication_laboratorio/pages/gallery_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/actividad.dart';
import '../services/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:camera/camera.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    Logger().i('Constructor ejecutado - mounted: $mounted');
  }
  int _imageCounter = 1;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String imageUrl = 'https://picsum.photos/250?image=1';
  String? _imagePath;
  bool _isResetEnabled = false; // Variable para almacenar el estado de reinicio

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isResetEnabled = prefs.getBool('isResetEnabled') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    Logger().i('initState ejecutado');
    _loadPreferences();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    Logger().i('setState ejecutado');
  }

  @override
  void dispose() {
    Logger().i('dispose ejecutado');
    super.dispose();
  }

  Future<void> _getNewImage() async {
    _imageCounter++;
    final newImageUrl = 'https://picsum.photos/250?image=$_imageCounter';
    try {
      final response = await http.get(Uri.parse(newImageUrl));
      if (response.statusCode == 200) {
        setState(() {
          imageUrl = newImageUrl;
          _imagePath = null;
        });
        await _dbHelper.insertActivity(
          Actividad(
            fecha: DateTime.now(),
            nombre: 'Actualizó imagen a $newImageUrl',
          ),
        );
        Logger().i('Actividad registrada: Actualizó imagen');
      }
    } catch (e) {
      Logger().e('Error al cargar imagen: $e');
    }
  }

  Future<void> _captureImage() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: firstCamera),
        ),
      );

      if (imagePath != null && context.mounted) {
        setState(() {
          _imagePath = imagePath;
        });

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPictureScreen(imagePath: imagePath),
          ),
        );

        await _dbHelper.insertActivity(
          Actividad(
            fecha: DateTime.now(),
            nombre: 'Capturó imagen: $imagePath',
          ),
        );
        Logger().i('Actividad registrada: Capturó imagen');
      }
    } catch (e) {
      Logger().e('Error al abrir la cámara: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al abrir la cámara: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.i('Home screen loaded');

    final appData = context.watch<AppData>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú de navegación',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Servicios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListContent()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Nosotros'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Preferencias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferenciaScreen(),
                  ),
                ).then((_) {
                  _loadPreferences();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Actividades'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActividadesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GalleryScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _imagePath != null
                      ? Image.file(
                        File(_imagePath!),
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Error al cargar la imagen',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      )
                      : Image.network(
                        imageUrl,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              'Error al cargar la imagen',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _getNewImage,
                                icon: const Icon(Icons.image),
                                label: const Text('Imagen de Internet'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _captureImage,
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Tomar Foto'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Contador: ${appData.counter}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  appData.increment();
                                  await _dbHelper.insertActivity(
                                    Actividad(
                                      fecha: DateTime.now(),
                                      nombre:
                                          'Incrementó contador a ${appData.counter}',
                                    ),
                                  );
                                  logger.i(
                                    'Actividad registrada: Incrementó contador',
                                  );
                                },
                                child: const Icon(Icons.add),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  appData.decrement();
                                  await _dbHelper.insertActivity(
                                    Actividad(
                                      fecha: DateTime.now(),
                                      nombre:
                                          'Decrementó contador a ${appData.counter}',
                                    ),
                                  );
                                  logger.i(
                                    'Actividad registrada: Decrementó contador',
                                  );
                                },
                                child: const Icon(Icons.remove),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_isResetEnabled) {
                                    appData.reset();
                                    await _dbHelper.insertActivity(
                                      Actividad(
                                        fecha: DateTime.now(),
                                        nombre:
                                            'Reinició contador a ${appData.counter}',
                                      ),
                                    );
                                    logger.i(
                                      'Actividad registrada: Reinició contador',
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'El reinicio está deshabilitado',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Icon(Icons.refresh),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
