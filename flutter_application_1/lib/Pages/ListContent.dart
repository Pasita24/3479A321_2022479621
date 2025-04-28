import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:fultter_aplication_laboratorio/Pages/AboutUsScreen.dart';

class ListContent extends StatelessWidget {
  const ListContent({super.key});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.i('ListContent screen loaded'); // Depuración

    // Lista de servicios de modelado 3D
    final List<Map<String, String>> services = [
      {
        'title': 'Estilo Anime',
        'description':
            'Personajes vibrantes y estilizados inspirados en el anime, perfectos para RPGs y juegos narrativos.',
        'image': 'assets/Image/Anime.jpg',
      },
      {
        'title': 'Estilo Apocalíptico',
        'description':
            'Modelos robustos y detallados para mundos post-apocalípticos, ideales para juegos de supervivencia.',
        'image': 'assets/Image/Apocalipsis.jpg',
      },
      {
        'title': 'Estilo Shooter',
        'description':
            'Personajes dinámicos y optimizados para juegos de disparos en primera o tercera persona.',
        'image': 'assets/Image/Shooter.jpg',
      },
      {
        'title': 'Estilo Medieval',
        'description':
            'Caballeros, magos y criaturas míticas diseñadas para aventuras de fantasía medieval.',
        'image': 'assets/Image/Medevial.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de Modelado 3D'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio:
                0.75, // Proporción para que los cards sean más altos
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        services[index]['image']!,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Título
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      services[index]['title']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Descripción
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      services[index]['description']!,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // Botones flotantes
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón para volver a Home
            FloatingActionButton(
              onPressed: () {
                logger.i('Navigating back to Home'); // Depuración
                Navigator.pop(context); // Volver a la página Home
              },
              tooltip: 'Volver a Home',
              child: const Icon(Icons.home),
            ),
            // Botón para ir a AboutUsScreen
            FloatingActionButton(
              onPressed: () {
                logger.i('Navigating to AboutUsScreen'); // Depuración
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsScreen(),
                  ),
                );
              },
              tooltip: 'Ir a About Us',
              child: const Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
