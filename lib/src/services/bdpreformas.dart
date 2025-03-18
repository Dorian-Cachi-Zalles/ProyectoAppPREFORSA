import 'package:flutter/material.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/principio.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_ctrl_pesos.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_procesos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatosProviderPrefIPS with ChangeNotifier {
  late Database _db;  
  final String tableDatosPROCEIPS = 'DatosProceips';
  final String tableDatosPESOSIPS = 'datosPESOSIPS';

  List<DatosPrefIPS> _datosprefipsList = [];
  List<DatosPROCEIPS> _datosproceipsList = [];
  List<DatosPESOSIPS> _datospesosipsList = [];

 
  List<DatosPrefIPS> get datosprefipsList => List.unmodifiable(_datosprefipsList);
  List<DatosPROCEIPS> get datosproceipsList => List.unmodifiable(_datosproceipsList);
  List<DatosPESOSIPS> get datospesosipsList => List.unmodifiable(_datospesosipsList);

  DatosProviderPrefIPS() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'datosIPS.db'),
      version: 5,
      onCreate: (db, version) async {       
        await db.execute('''
          CREATE TABLE $tableDatosPROCEIPS (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hasErrors INTEGER NOT NULL,
          Hora TEXT NOT NULL,
          PAprod TEXT NOT NULL,
          TempTolvaSec TEXT NOT NULL,
          TempProd REAL NOT NULL,
          Tciclo REAL NOT NULL,
          Tenfri REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $tableDatosPESOSIPS (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hasErrors INTEGER NOT NULL,
          hasSend INTEGER NOT NULL,
          idregistro INTEGER NOT NULL,
          Hora TEXT NOT NULL,
          PA TEXT NOT NULL,
          PesoTara REAL NOT NULL,
          PesoNeto REAL NOT NULL,
          PesoTotal REAL NOT NULL
          )
        ''');
      },
    );
    await _loadData();
  }

  Future<void> _loadData() async {    

    final proceMaps = await _db.query(tableDatosPROCEIPS);
    _datosproceipsList = proceMaps.map((map) => DatosPROCEIPS.fromMap(map)).toList();

    final pesosMaps = await _db.query(tableDatosPESOSIPS);
    _datospesosipsList = pesosMaps.map((map) => DatosPESOSIPS.fromMap(map)).toList();

    notifyListeners();
  } 

  Future<void> addProceIPS(DatosPROCEIPS nuevo) async {
    final id = await _db.insert(tableDatosPROCEIPS, nuevo.toMap());
    _datosproceipsList.add(nuevo.copyWith(id: id));
    notifyListeners();
  }

  Future<void> addPesosIPS(DatosPESOSIPS nuevo) async {
    final id = await _db.insert(tableDatosPESOSIPS, nuevo.toMap());
    _datospesosipsList.add(nuevo.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateProcesos(int id, DatosPROCEIPS updatedDato) async {
    final index = _datosproceipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosPROCEIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosproceipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> updatePESO(int id, DatosPESOSIPS updatedDato) async {
    final index = _datospesosipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosPESOSIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datospesosipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> removeProceso(BuildContext context, int id) async {
    final index = _datosproceipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datosproceipsList[index];
      await _db.delete(
        tableDatosPROCEIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosproceipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId = await _db.insert(tableDatosPROCEIPS, deletedData.toMap());
              _datosproceipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }
  Future<void> removePeso(BuildContext context, int id) async {
    final index = _datospesosipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datospesosipsList[index];
      await _db.delete(
        tableDatosPESOSIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datospesosipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId =
                  await _db.insert(tableDatosPESOSIPS, deletedData.toMap());
              _datospesosipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }  

  Future<void> removeAllPesos() async {
  await _db.delete(tableDatosPESOSIPS);
  _datospesosipsList.clear();
  notifyListeners();
}

Future<void> removeAllProcesos(BuildContext context) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación'),
        content: const Text(
            '¿Está seguro de que desea eliminar todos los registros? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _db.delete(
          tableDatosPROCEIPS);
      _datosproceipsList.clear();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Todos los registros han sido eliminados.')),
      );
    }
  }

Future<void> finishProcess() async {
  await _db.delete(tableDatosPESOSIPS);
  await _db.execute("DELETE FROM sqlite_sequence WHERE name='$tableDatosPESOSIPS'");
  _datospesosipsList.clear();
  notifyListeners();
}


}
