import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/views/formularios/preformas%20ips/defectosips.dart';
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/titulospeq.dart';
import 'package:sqflite/sqflite.dart';

class DatosDEFIPSprueba {
  final int? id;
  final List<Map<String, String>> Defectos;

  // Constructor de la clase
  const DatosDEFIPSprueba({
    this.id,
    required this.Defectos,
  });

  // Factory para crear una instancia desde un Map
  factory DatosDEFIPSprueba.fromMap(Map<String, dynamic> map) {
    return DatosDEFIPSprueba(
      id: map['id'] as int?,
      Defectos: map['Defectos'] != null
          ? List<Map<String, String>>.from(jsonDecode(map['Defectos']))
          : [],
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'Defectos': jsonEncode(Defectos),
    };
  }

  // Método copyWith
  DatosDEFIPSprueba copyWith({
    int? id,
    List<Map<String, String>>? Defectos,
  }) {
    return DatosDEFIPSprueba(
      id: id ?? this.id,
      Defectos: Defectos ?? this.Defectos,
    );
  }
}

class DatosDEFIPSProviderprueba with ChangeNotifier {
  late Database _db;
  final String tableDatosDEFIPS = 'datosDEFIPS';
  List<DatosDEFIPSprueba> _datosdefipsList = [];

  List<DatosDEFIPSprueba> get datosdefipsList => List.unmodifiable(_datosdefipsList);

  DatosDEFIPSProviderprueba() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosDEFIPS.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosDEFIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        Defectos TEXT NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosDEFIPS);
    _datosdefipsList = maps.map((map) => DatosDEFIPSprueba.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosDEFIPSprueba nuevoDato) async {
    final id = await _db.insert(tableDatosDEFIPS, nuevoDato.toMap());
    final nuevoDatoConId = nuevoDato.copyWith(id: id);
    _datosdefipsList.add(nuevoDatoConId);
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosDEFIPSprueba updatedDato) async {
    final index = _datosdefipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosDEFIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosdefipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> removeDatito(BuildContext context, int id) async {
    final index = _datosdefipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datosdefipsList[index];
      await _db.delete(
        tableDatosDEFIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosdefipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId =
                  await _db.insert(tableDatosDEFIPS, deletedData.toMap());
              _datosdefipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }
}
class ScreenListDatosDEFIPSprueba extends StatelessWidget {
  const ScreenListDatosDEFIPSprueba({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosDEFIPSProviderprueba>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          const Titulospeq(
            titulo: 'REGISTRO DE DEFECTOS',
            tipo: 1,
          ),
          Expanded(
            child: Consumer<DatosDEFIPSProviderprueba>(
              builder: (context, provider, _) {
                final datosdefips = provider.datosdefipsList;

                return ListView.separated(
                  itemCount: datosdefips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final dtdatosdefips = datosdefips[index];

                    return GestureDetector(
                      onTap: () {
                        _navigateToEdit(context, dtdatosdefips);
                      },
                      child: GradientExpandableCard(
                        title: (index + 1).toString(),
                        subtitle: dtdatosdefips.Defectos.map((defecto) {
                          return "${defecto['defecto']} - ${defecto['criticidad']}";
                        }).join(", "),
                        expandedContent: [],
                        hasErrors: false,
                        onOpenModal: () {
                          _navigateToEdit(context, dtdatosdefips);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            provider.addDatito(
              DatosDEFIPSprueba(
                Defectos: [
                  {"defecto": "Defecto1", "criticidad": "Alta"},
                  {"defecto": "Defecto2", "criticidad": "Baja"}
                ],
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('AGREGAR UN REGISTRO'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, DatosDEFIPSprueba datosDEFIPS) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioGeneralDatosDEFIPS(
          formKey: GlobalKey<FormBuilderState>(), // Clave agregada aquí
          id: datosDEFIPS.id!,
          datosDEFIPS: datosDEFIPS,
        ),
      ),
    );
  }
}

class FormularioGeneralDatosDEFIPS extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final int id;
  final DatosDEFIPSprueba datosDEFIPS;

  const FormularioGeneralDatosDEFIPS({
    required this.formKey,
    required this.id,
    required this.datosDEFIPS,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defectosOptions = ['CN', 'B', 'NN'];
    final criticidadOptions = ['Alta', 'Media', 'Baja'];
    final defectosImages = {
      'CN': 'images/d1.jpg',
      'B': 'images/d2.jpg',
      'NN': 'images/d3.png',
    };

    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              children: defectosOptions.map((defecto) {
                return GestureDetector(
                  onTap: () {
                    _showCriticidadDialog(context, defecto, criticidadOptions);
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.asset(
                        defectosImages[defecto] ?? 'assets/images/default.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black54,
                        child: Text(
                          defecto,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: datosDEFIPS.Defectos.map((defecto) {
                return Chip(
                  label: Text('${defecto['defecto']} - ${defecto['criticidad']}'),
                  onDeleted: () {
                    final updatedDefectos =
                        List<Map<String, String>>.from(datosDEFIPS.Defectos);
                    updatedDefectos.remove(defecto);

                    Provider.of<DatosDEFIPSProviderprueba>(context, listen: false)
                        .updateDatito(id, datosDEFIPS.copyWith(Defectos: updatedDefectos));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCriticidadDialog(
      BuildContext context, String defecto, List<String> criticidadOptions) {
    String? selectedCriticidad;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Seleccionar criticidad para $defecto'),
          content: DropdownButtonFormField<String>(
            items: criticidadOptions.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              selectedCriticidad = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCriticidad != null) {
                  final updatedDefectos =
                      List<Map<String, String>>.from(datosDEFIPS.Defectos);
                  updatedDefectos.add({
                    'defecto': defecto,
                    'criticidad': selectedCriticidad!,
                  });

                  Provider.of<DatosDEFIPSProviderprueba>(context, listen: false)
                      .updateDatito(id, datosDEFIPS.copyWith(Defectos: updatedDefectos));
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}



