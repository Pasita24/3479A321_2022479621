import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:fultter_aplication_laboratorio/Provider/app_data.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.i('AboutUs screen loaded'); // Depuración

    final appData = Provider.of<AppData>(context);
    final TextEditingController nameController = TextEditingController(
      text: appData.userName,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nosotros'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Icon(Icons.business, size: 100, color: Colors.blueAccent),
                  SizedBox(height: 10),
                  Text(
                    '3D Heroes Studio',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Dando vida a tus ideas',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '¿Quiénes somos?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'En 3D Heroes Studio somos apasionados del arte digital y la tecnología. '
              'Nos especializamos en la creación de modelos 3D de alta calidad para personajes de videojuegos, '
              'adaptados a distintos estilos como anime, medieval, shooter y mundos post-apocalípticos. '
              'Nuestra misión es transformar ideas en experiencias visuales inolvidables.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Text(
              'Nuestra Visión',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ser líderes en el mercado de modelado 3D para videojuegos, '
              'ofreciendo soluciones innovadoras, artísticas y personalizadas a desarrolladores de todo el mundo.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            const Text(
              '¿Por qué elegirnos?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Modelos detallados y optimizados.\n'
              '• Adaptabilidad a cualquier estilo de juego.\n'
              '• Compromiso con los tiempos de entrega.\n'
              '• Atención personalizada para cada proyecto.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            // NUEVA SECCIÓN: Configuración del usuario
            const Text(
              'Configuración de Usuario',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Usuario',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                appData.setUserName(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '¿Permitir reiniciar contador?',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: appData.canReset,
                  onChanged: (value) {
                    appData.setCanReset(value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  logger.i('Returning to previous screen'); // Depuración
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
