import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('formulario.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE formulario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      modalidad TEXT,
      maquinista TEXT,
      parte TEXT,
      producto TEXT,
      gramaje TEXT,
      cavidades TEXT,
      ciclo_promedio TEXT,
      peso_promedio TEXT,
      pa_inicial TEXT,
      cantidad TEXT,
      peso_prom_en_cont_neto TEXT,
      total_cajas_controladas TEXT,
      saldos TEXT,
      total_cajas_producidas TEXT,
      cant_total_piezas TEXT,
      cant_total_kg TEXT,
      cant_prod_retenido TEXT
    )
    ''');
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert('formulario', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getData() async {
    final db = await instance.database;
    final result = await db.query('formulario', orderBy: 'id DESC', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
