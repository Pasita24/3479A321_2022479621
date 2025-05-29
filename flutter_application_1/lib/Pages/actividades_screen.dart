import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../entity/actividad.dart';
import '../services/database_helper.dart';

class ActividadesScreen extends StatefulWidget {
  const ActividadesScreen({super.key});

  @override
  State<ActividadesScreen> createState() => _ActividadesScreenState();
}

class _ActividadesScreenState extends State<ActividadesScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Actividad> _activities = [];
  final Logger _logger = Logger();
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final activities = await _dbHelper.getActividades();
      setState(() {
        _activities = activities;
      });
    } catch (e) {
      _logger.e('Error al cargar actividades: $e');
    }
  }

  Future<void> _addActivity() async {
    if (_nombreController.text.isEmpty) return;
    final actividad = Actividad(
      fecha: DateTime.now(),
      nombre: _nombreController.text,
    );
    try {
      await _dbHelper.insertActivity(actividad);
      _nombreController.clear();
      await _loadActivities();
      _logger.i('Actividad agregada: ${actividad.nombre}');
    } catch (e) {
      _logger.e('Error al agregar actividad: $e');
    }
  }

  Future<void> _editActivity(Actividad actividad) async {
    _nombreController.text = actividad.nombre;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Editar Actividad'),
            content: TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  if (_nombreController.text.isEmpty) return;
                  final updated = Actividad(
                    id: actividad.id,
                    fecha: actividad.fecha,
                    nombre: _nombreController.text,
                  );
                  await _dbHelper.updateActivity(updated);
                  _nombreController.clear();
                  await _loadActivities();
                  Navigator.pop(context);
                  _logger.i('Actividad editada: ${updated.nombre}');
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteActivity(int? id) async {
    if (id == null) return;
    try {
      await _dbHelper.deleteActivity(id);
      await _loadActivities();
      _logger.i('Actividad eliminada: $id');
    } catch (e) {
      _logger.e('Error al eliminar actividad: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actividades Registradas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nueva Actividad',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addActivity,
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _activities.isEmpty
                    ? const Center(
                      child: Text('No hay actividades registradas'),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final actividad = _activities[index];
                        return Card(
                          child: ListTile(
                            title: Text(actividad.nombre),
                            subtitle: Text(actividad.fecha.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editActivity(actividad),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed:
                                      () => _deleteActivity(actividad.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
