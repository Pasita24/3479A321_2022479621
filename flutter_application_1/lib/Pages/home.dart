import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decreaseCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    logger.i('Logger is working!');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Card(
          elevation: 4, // Sombra para dar profundidad
          margin: const EdgeInsets.all(16.0), // Margen alrededor del Card
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Espaciado interno
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
              children: [
                // Imagen SVG
                SvgPicture.asset(
                  "Assets/Icons/Apple.svg",
                  semanticsLabel: 'Dart Logo',
                  height: 100, // Ajusta el tamaño según necesites
                ),
                const SizedBox(height: 16), // Espacio entre elementos
                // Mensaje sobre Flutter
                const Text(
                  'Flutter es un framework de Google para crear aplicaciones multiplataforma con una sola base de código.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Contador
                Text(
                  'Contador: $_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                // Botones en una fila
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _incrementCounter,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _decreaseCounter,
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _resetCounter,
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
