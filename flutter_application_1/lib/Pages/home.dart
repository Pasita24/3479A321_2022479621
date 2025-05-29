import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:fultter_aplication_laboratorio/Pages/ListContent.dart';
import 'package:fultter_aplication_laboratorio/Pages/AboutUsScreen.dart';
import 'package:fultter_aplication_laboratorio/Provider/app_data.dart';
import 'package:fultter_aplication_laboratorio/Pages/Preferencias.dart';
import 'package:fultter_aplication_laboratorio/Pages/actividades_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/actividad.dart';
import '../services/database_helper.dart';

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
  int _currentIndex = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final List<Widget> _screens = [
    const MyHomePage(title: 'Flutter Home'),
    const ListContent(),
    const AboutUsScreen(),
  ];

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isResetEnabled = prefs.getBool('isResetEnabled') ?? false;
  }

  @override
  void initState() {
    super.initState();
    Logger().i('initState ejecutado');
    _loadPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Logger().i('didChangeDependencies ejecutado');
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    Logger().i('setState ejecutado');
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    Logger().i('didUpdateWidget ejecutado');
  }

  @override
  void deactivate() {
    super.deactivate();
    Logger().i('deactivate ejecutado');
  }

  @override
  void dispose() {
    Logger().i('dispose ejecutado');
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    Logger().i('reassemble ejecutado');
  }

  void _navigateBasedOnCounter() {
    final counter = context.read<AppData>().counter;
    if (counter % 2 == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListContent()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutUsScreen()),
      );
    }
  }

  void _navigateToListContent() {
    Logger logger = Logger();
    logger.i('Navigating to ListContent');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListContent()),
    );
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
                setState(() {
                  _currentIndex = 0;
                });
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
          ],
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "Assets/Icons/Apple.svg",
                  semanticsLabel: 'Dart Logo',
                  height: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Flutter es un framework de Google para crear aplicaciones multiplataforma con una sola base de código.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Contador: ${appData.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          logger.i('Actividad registrada: Incrementó contador');
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
                          logger.i('Actividad registrada: Decrementó contador');
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final isResetEnabled =
                              prefs.getBool('isResetEnabled') ?? false;

                          if (isResetEnabled) {
                            appData.reset();
                            await _dbHelper.insertActivity(
                              Actividad(
                                fecha: DateTime.now(),
                                nombre:
                                    'Reinició contador a ${appData.counter}',
                              ),
                            );
                            logger.i('Actividad registrada: Reinició contador');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('El reinicio está deshabilitado'),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.refresh),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateBasedOnCounter,
                        child: const Text('Ir a Pantalla'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToListContent,
        tooltip: 'Ver Servicios de Modelado 3D',
        child: const Icon(Icons.brush),
      ),
    );
  }
}
