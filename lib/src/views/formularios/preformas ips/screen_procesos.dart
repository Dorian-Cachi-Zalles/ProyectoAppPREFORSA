import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/services/bdpreformas.dart';
import 'package:proyecto/src/widgets/boton_agregar.dart';
import 'package:proyecto/src/widgets/boton_guardarform.dart';
import 'package:proyecto/src/widgets/boxpendiente.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';
import 'package:proyecto/src/widgets/titulos.dart';
import 'package:sqflite/sqflite.dart';

class DatosPROCEIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final String PAprod;
  final List<double> TempTolvaSec;
  final double TempProd;
  final double Tciclo;
  final double Tenfri;

  // Constructor de la clase
  const DatosPROCEIPS({
    this.id,
    required this.hasErrors,
    required this.Hora,
    required this.PAprod,
    required this.TempTolvaSec,
    required this.TempProd,
    required this.Tciclo,
    required this.Tenfri
  });

  // Factory para crear una instancia desde un Map
  factory DatosPROCEIPS.fromMap(Map<String, dynamic> map) {
    return DatosPROCEIPS(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      Hora: map['Hora'] as String,
      PAprod: map['PAprod'] as String,
      TempTolvaSec: (map['TempTolvaSec'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      TempProd: map['TempProd'] as double,
      Tciclo: map['Tciclo'] as double,
      Tenfri: map['Tenfri'] as double
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'Hora': Hora,
      'PAprod': PAprod,
      'TempTolvaSec': TempTolvaSec.join(','),
      'TempProd': TempProd,
      'Tciclo': Tciclo,
      'Tenfri': Tenfri
    };
  }

  // Método copyWith
  DatosPROCEIPS copyWith({
    int? id,
    bool? hasErrors,
    String? Hora, String? PAprod, List<double>? TempTolvaSec, double? TempProd, double? Tciclo, double? Tenfri
  }) {
    return DatosPROCEIPS(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      Hora: Hora ?? this.Hora,
      PAprod: PAprod ?? this.PAprod,
      TempTolvaSec: TempTolvaSec ?? this.TempTolvaSec,
      TempProd: TempProd ?? this.TempProd,
      Tciclo: Tciclo ?? this.Tciclo,
      Tenfri: Tenfri ?? this.Tenfri
    );
  }
}


class DatosPROCEIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosPROCEIPS = 'DatosProceips';
  List<DatosPROCEIPS> _datosproceipsList = [];

  List<DatosPROCEIPS> get datosproceipsList => List.unmodifiable(_datosproceipsList);

  DatosPROCEIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'DatosProceips.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
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
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosPROCEIPS);
    _datosproceipsList = maps.map((map) => DatosPROCEIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosPROCEIPS nuevoDato) async {
    final id = await _db.insert(tableDatosPROCEIPS, nuevoDato.toMap());
    _datosproceipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosPROCEIPS updatedDato) async {
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

  Future<void> removeDatito(BuildContext context, int id) async {
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
  Future<void> removeAllDatitos(BuildContext context) async {
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
}


class ScreenListDatosPROCEIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Titulos(
            titulo: 'REGISTRO',
            tipo: 1,
            accion: () => provider.removeAllProcesos(context),
          ),
          Expanded(
            child: Consumer<DatosProviderPrefIPS>(
              builder: (context, provider, _) {
                final datosproceips = provider.datosproceipsList;

                if (datosproceips.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay registros aún.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: datosproceips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final dtdatosproceips = datosproceips[index];

                    return GradientExpandableCard(
                      idlista: dtdatosproceips.id,
                      numeroindex: (index + 1).toString(),
                      onSwipedAction: () async {
                        await provider.removeProceso(context, dtdatosproceips.id!);
                      },
                                          subtitulos: {},
                      expandedContent: generateExpandableContent([
                        ['Hora: ', 1, dtdatosproceips.Hora],
                        ['PAprod: ', 1, dtdatosproceips.PAprod],
                        ['TempTolvaSec: ', 4,dtdatosproceips.TempTolvaSec],
                        ['TempProd: ', 1, dtdatosproceips.TempProd.toString() + ' °C'],
                        ['Tciclo: ', 1, dtdatosproceips.Tciclo.toString() + ' seg'],	
                        ['Tenfri: ', 1, dtdatosproceips.Tenfri.toString()],
                      ]),
                      hasErrors: dtdatosproceips.hasErrors,
                      hasSend: dtdatosproceips.hasErrors,
                      onOpenModal: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDatosPROCEIPSForm(
                              id: dtdatosproceips.id!,
                              DatosProceips: dtdatosproceips,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BotonAgregar(
          onPressed: () {
          provider.addProceIPS(
             DatosPROCEIPS(
          hasErrors: true,
              Hora:  DateFormat('HH:mm').format(DateTime.now()),
              PAprod: '',
              TempTolvaSec: [0,0,0],
              TempProd: 0,
              Tciclo: 0,
              Tenfri: 0,
        )
          );
        },
        ));
  }
}
    class EditProviderDatosPROCEIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosPROCEIPSForm extends StatefulWidget {
  final int id;
  final DatosPROCEIPS DatosProceips;

  const EditDatosPROCEIPSForm({required this.id, required this.DatosProceips, Key? key})
      : super(key: key);

  @override
  _EditDatosPROCEIPSFormState createState() => _EditDatosPROCEIPSFormState();
}

class _EditDatosPROCEIPSFormState extends State<EditDatosPROCEIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosPROCEIPS = {
    'Opciones': ['Opción 1', 'Opción 2', 'Opción 3'],
  };

  @override
  void initState() {
    super.initState();
    // Validación inicial después de la construcción del widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.saveAndValidate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProviderDatosPROCEIPS(),
      child: Consumer<EditProviderDatosPROCEIPS>(
        builder: (context, provider, child) {
          return Scaffold(
          body: Column(
              children:[
               Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormularioGeneralDatosPROCEIPS(
              formKey: _formKey,
              widget: widget,
              dropOptions: dropOptionsDatosPROCEIPS,
            ),),),),
          BotonesFormulario(
            onGuardar: () {
                _formKey.currentState?.save();
                final values = _formKey.currentState!.value;

                final updatedDatito = widget.DatosProceips.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  Hora: values['Hora'] ?? widget.DatosProceips.Hora,
                  PAprod: values['PAprod'] ?? widget.DatosProceips.PAprod,
                  TempTolvaSec: values['TempTolvaSec'] ?? widget.DatosProceips.TempTolvaSec,
                  TempProd:(values['TempProd']?.isEmpty ?? true)? 0 : double.tryParse(values['TempProd']),
                  Tciclo:(values['Tciclo']?.isEmpty ?? true)? 0 : double.tryParse(values['Tciclo']),
                  Tenfri:(values['Tenfri']?.isEmpty ?? true)? 0 : double.tryParse(values['Tenfri']),

                );

                Provider.of<DatosPROCEIPSProvider>(context, listen: false)
                    .updateDatito(widget.id, updatedDatito);

                Navigator.pop(context);
             },
            ),
          ]));
        }));
  }
}

class FormularioGeneralDatosPROCEIPS extends StatelessWidget {
  const FormularioGeneralDatosPROCEIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final widget;
  final Map<String, List<dynamic>> dropOptions;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [

          TextoSimple(
              name: 'Hora',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Hora'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Hora',
              valorInicial: widget.DatosProceips.Hora,
              textoError: 'error'),

          TextoSimple(
              name: 'PAprod',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['PAprod'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Paprod',
              valorInicial: widget.DatosProceips.PAprod,
              textoError: 'error'),

            const SizedBox(height: 15,),
            ...List.generate(
              widget.DatosProceips.TempTolvaSec.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: TextoSimple(
              name: 'TempTolvaSec',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['TempTolvaSec'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Temptolvasec',
              valorInicial: widget.DatosProceips.TempTolvaSec[index].toString(),  
              textoError: 'error'),
            )),
          TextoSimple(
              name: 'TempProd',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['TempProd'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Tempprod',
              valorInicial: widget.DatosProceips.TempProd.toString(),
              textoError: 'error'),

          TextoSimple(
              name: 'Tciclo',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Tciclo'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Tciclo',
              valorInicial: widget.DatosProceips.Tciclo.toString(),
              textoError: 'error'),

          TextoSimple(
              name: 'Tenfri',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Tenfri'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Tenfri',
              valorInicial: widget.DatosProceips.Tenfri.toString(),
              textoError: 'error'),

    ]
      ),
    );
  }
}