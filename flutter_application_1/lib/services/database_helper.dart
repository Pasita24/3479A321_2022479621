import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entity/actividad.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static const String tableName = 'actividades';

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<void> initializeDatabase() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'activity_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        nombre TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertActivity(Actividad actividad) async {
    final db = await database;
    await db.insert(
      tableName,
      actividad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Actividad>> getActividades() async {
    final db = await database;
    final maps = await db.query(tableName);
    return maps.map((map) => Actividad.fromMap(map)).toList();
  }

  Future<void> updateActivity(Actividad actividad) async {
    final db = await database;
    await db.update(
      tableName,
      actividad.toMap(),
      where: 'id = ?',
      whereArgs: [actividad.id],
    );
  }

  Future<void> deleteActivity(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
