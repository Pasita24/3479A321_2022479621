import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:fultter_aplication_laboratorio/Pages/AboutUsScreen.dart';
import 'package:fultter_aplication_laboratorio/Provider/app_data.dart';

class ListContent extends StatelessWidget {
  const ListContent({super.key});

  static final List<String> _modelingConcepts = [
    'Malla: Estructura de polígonos que define la forma de un objeto 3D.',
    'Textura: Imagen aplicada a una malla para darle color y detalle.',
    'Rigging: Proceso de crear un esqueleto para animar un modelo 3D.',
    'Shader: Algoritmo que define cómo se renderiza la luz en un objeto.',
  ];

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de Modelado 3D'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AppData>(
          builder: (context, appData, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mostrar el nombre del usuario
                Text(
                  'Bienvenido, ${appData.userName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Contador global
                Text(
                  'Contador Global: ${appData.counter}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Botón para reiniciar si está permitido
                if (appData.canReset)
                  ElevatedButton(
                    onPressed: () {
                      appData.reset();
                      logger.i('Contador reiniciado');
                    },
                    child: const Text('Reiniciar Contador'),
                  ),
                const SizedBox(height: 16),

                // Cuadrícula de servicios
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                services[index]['image']!,
                                height: 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              services[index]['title']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
                const SizedBox(height: 24),

                // Lista de conceptos
                const Text(
                  'Conceptos de Modelado 3D',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _modelingConcepts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            _modelingConcepts[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          logger.i('Agregando nuevo concepto');
                          _modelingConcepts.add(
                            'Animación: Proceso de dar movimiento a un modelo 3D (${_modelingConcepts.length + 1}).',
                          );
                          (context as Element).markNeedsBuild();
                        },
                        child: const Text('Agregar Concepto'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          logger.i('Eliminando último concepto');
                          if (_modelingConcepts.isNotEmpty) {
                            _modelingConcepts.removeLast();
                            (context as Element).markNeedsBuild();
                          }
                        },
                        child: const Text('Borrar Último'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'boton_unico_1',
              onPressed: () {
                logger.i('Volviendo a Home');
                Navigator.pop(context);
              },
              tooltip: 'Volver a Home',
              child: const Icon(Icons.home),
            ),
            FloatingActionButton(
              heroTag: 'boton_unico_2',
              onPressed: () {
                logger.i('Navegando a AboutUsScreen');
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

  // Lista de servicios de modelado 3D
  List<Map<String, String>> get services => [
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
}
