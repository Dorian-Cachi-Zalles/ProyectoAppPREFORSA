import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/views/formularios/preformas%20ips/form_coloranteips.dart';
import 'package:proyecto/src/widgets/boton_agregar.dart';
import 'package:proyecto/src/widgets/boton_guardarform.dart';
import 'package:proyecto/src/widgets/checkboxformulario.dart';
import 'package:proyecto/src/widgets/dropdownformulario.dart';
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';
import 'package:proyecto/src/widgets/titulos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DatosMPIPS {
  final int? id;
  final bool hasErrors;
  final String MateriPrima;
  final String INTF;
  final String CantidadEmpaque;
  final String Identif;
  final int CantidadBolsones;
  final double Dosificacion;
  final double Humedad;
  final bool Conformidad;

  // Constructor de la clase
  const DatosMPIPS({
    this.id,
    required this.hasErrors,
    required this.MateriPrima,
    required this.INTF,
    required this.CantidadEmpaque,
    required this.Identif,
    required this.CantidadBolsones,
    required this.Dosificacion,
    required this.Humedad,
    required this.Conformidad
  });

  // Factory para crear una instancia desde un Map
  factory DatosMPIPS.fromMap(Map<String, dynamic> map) {
    return DatosMPIPS(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      MateriPrima: map['MateriPrima'] as String,
      INTF: map['INTF'] as String,
      CantidadEmpaque: map['CantidadEmpaque'] as String,
      Identif: map['Identif'] as String,
      CantidadBolsones: map['CantidadBolsones'] as int,
      Dosificacion: map['Dosificacion'] as double,
      Humedad: map['Humedad'] as double,
      Conformidad: (map['Conformidad'] as int) == 1
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'MateriPrima': MateriPrima,
      'INTF': INTF,
      'CantidadEmpaque': CantidadEmpaque,
      'Identif': Identif,
      'CantidadBolsones': CantidadBolsones,
      'Dosificacion': Dosificacion,
      'Humedad': Humedad,
      'Conformidad': Conformidad ? 1 : 0
    };
  }

  // Método copyWith
  DatosMPIPS copyWith({
    int? id,
    bool? hasErrors,
    String? MateriPrima, String? INTF, String? CantidadEmpaque, String? Identif, int? CantidadBolsones, double? Dosificacion, double? Humedad, bool? Conformidad
  }) {
    return DatosMPIPS(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      MateriPrima: MateriPrima ?? this.MateriPrima,
      INTF: INTF ?? this.INTF,
      CantidadEmpaque: CantidadEmpaque ?? this.CantidadEmpaque,
      Identif: Identif ?? this.Identif,
      CantidadBolsones: CantidadBolsones ?? this.CantidadBolsones,
      Dosificacion: Dosificacion ?? this.Dosificacion,
      Humedad: Humedad ?? this.Humedad,
      Conformidad: Conformidad ?? this.Conformidad
    );
  }
}


class DatosMPIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosMPIPS = 'datosMpIps';
  List<DatosMPIPS> _datosmpipsList = [];

  List<DatosMPIPS> get datosmpipsList => List.unmodifiable(_datosmpipsList);

  DatosMPIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosMpIps.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosMPIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        MateriPrima TEXT NOT NULL,
        INTF TEXT NOT NULL,
        CantidadEmpaque TEXT NOT NULL,
        Identif TEXT NOT NULL,
        CantidadBolsones INTEGER NOT NULL,
        Dosificacion REAL NOT NULL,
        Humedad REAL NOT NULL,
        Conformidad INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosMPIPS);
    _datosmpipsList = maps.map((map) => DatosMPIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosMPIPS nuevoDato) async {
    final id = await _db.insert(tableDatosMPIPS, nuevoDato.toMap());
    _datosmpipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosMPIPS updatedDato) async {
    final index = _datosmpipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosMPIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosmpipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> removeDatito(BuildContext context, int id) async {
    final index = _datosmpipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datosmpipsList[index];
      await _db.delete(
        tableDatosMPIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosmpipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId = await _db.insert(tableDatosMPIPS, deletedData.toMap());
              _datosmpipsList.insert(index, deletedData.copyWith(id: newId));
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
          tableDatosMPIPS);
      _datosmpipsList.clear();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Todos los registros han sido eliminados.')),
      );
    }
  }
}


class ScreenListDatosMPIPS extends StatefulWidget {
  @override
  State<ScreenListDatosMPIPS> createState() => _ScreenListDatosMPIPSState();
}

class _ScreenListDatosMPIPSState extends State<ScreenListDatosMPIPS> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosMPIPSProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  '¿Se tiene una mezcla con \ncolorante o aditivo?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleSwitch(
                  customWidths: [120.0, 70.0],
                  cornerRadius: 20.0,
                  minHeight: 50,
                  fontSize: 25,
                  iconSize: 30,
                  activeBgColors: [
                    [Colors.blueAccent.withOpacity(0.6)],
                    [Colors.redAccent]
                  ],
                  activeFgColor: Colors.black,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black,
                  totalSwitches: 2,
                  labels: ['SI', ''],
                  icons: [null, Icons.close],
                  onToggle: (index) {
                    if (index == 0) {
                      _showBottomSheet();
                    }
                  },
                ),
              ],
            ),
          Titulos(
            titulo: 'REGISTRO',
            tipo: 1,
            eliminar: () => provider.removeAllDatitos(context),
          ),
          Expanded(
            child: Consumer<DatosMPIPSProvider>(
              builder: (context, provider, _) {
                final datosmpips = provider.datosmpipsList;

                if (datosmpips.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay registros aún.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: datosmpips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final dtdatosmpips = datosmpips[index];

                    return GradientExpandableCard(
                      idlista: dtdatosmpips.id,
                      numeroindex: (index + 1).toString(),
                      onSwipedAction: () async {
                        await provider.removeDatito(context, dtdatosmpips.id!);
                      },
                      variableCambiarVentana: EditDatosMPIPSForm(
                        id: dtdatosmpips.id!,
                        datosMpIps: dtdatosmpips,
                      ),
                      titulo: 'Materia Prima',
                      subtitulos: {
                        'MateriPrima': dtdatosmpips.MateriPrima,                        
                        'Conformidad': dtdatosmpips.Conformidad ? 'SI' : 'NO',
                      },
                      expandedContent: generateExpandableContent([
                        ['INTF: ', 1, dtdatosmpips.INTF],
                        ['CantidadEmpaque: ', 1, dtdatosmpips.CantidadEmpaque],
                        ['Identif: ', 1, dtdatosmpips.Identif],
                        ['CantidadBolsones: ', 1, dtdatosmpips.CantidadBolsones.toString()],
                        ['Dosificacion: ', 1, dtdatosmpips.Dosificacion.toString()],
                        ['Humedad: ', 1, dtdatosmpips.Humedad.toString()],
                        ['Conformidad: ', 5, dtdatosmpips.Conformidad],
                      ]),
                      hasErrors: dtdatosmpips.hasErrors,
                      onOpenModal: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDatosMPIPSForm(
                              id: dtdatosmpips.id!,
                              datosMpIps: dtdatosmpips,
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
        provider: provider,
        datos: const DatosMPIPS(
          hasErrors: true,
              MateriPrima: '',
              INTF: '',
              CantidadEmpaque: '',
              Identif: '',
              CantidadBolsones: 1,
              Dosificacion: 0,
              Humedad: 0,
              Conformidad: true,
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(top: 5,left: 16,right: 16),          
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))
            
          ),
          child: FormColorante(),
        );
      },
    );


}
}


class EditProviderDatosMPIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosMPIPSForm extends StatefulWidget {
  final int id;
  final DatosMPIPS datosMpIps;

  const EditDatosMPIPSForm({required this.id, required this.datosMpIps, Key? key})
      : super(key: key);

  @override
  _EditDatosMPIPSFormState createState() => _EditDatosMPIPSFormState();
}

class _EditDatosMPIPSFormState extends State<EditDatosMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosMPIPS = {
     'MateriaPrima': [
      'JADE CZ 328A',
      'EASTLON CB 612',
      'ECOPET',
      'RAMAPET',
      'OCTAL',
      'SKY PET',
      'CR-BRIGHT',
      'MOLIDO',
      'WANKAY',
    ],
    'CantidadEmapque': ['1100Kg'],
    'CantidadBolsones': [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
    ],
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
      create: (_) => EditProviderDatosMPIPS(),
      child: Consumer<EditProviderDatosMPIPS>(
        builder: (context, provider, child) {
          return Scaffold(
          body: Column(
              children:[
               Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormularioGeneralDatosMPIPS(
              formKey: _formKey,
              widget: widget,
              dropOptions: dropOptionsDatosMPIPS,
            ),),),),
          BotonGuardarForm(
            onPressed: () {
                _formKey.currentState?.save();
                final values = _formKey.currentState!.value;

                final updatedDatito = widget.datosMpIps.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  MateriPrima: values['MateriPrima'] ?? widget.datosMpIps.MateriPrima,
                  INTF: values['INTF'] ?? widget.datosMpIps.INTF,
                  CantidadEmpaque: values['CantidadEmpaque'] ?? widget.datosMpIps.CantidadEmpaque,
                  Identif: values['Identif'] ?? widget.datosMpIps.Identif,
                  CantidadBolsones:(values['CantidadBolsones']?.isEmpty ?? true)? 0 : int.tryParse(values['CantidadBolsones']),
                  Dosificacion:(values['Dosificacion']?.isEmpty ?? true)? 0 : double.tryParse(values['Dosificacion']),       
                  Humedad:(values['Humedad']?.isEmpty ?? true)? 0 : double.tryParse(values['Humedad']),
                  Conformidad: values['Conformidad'] ?? widget.datosMpIps.Conformidad,

                );

                Provider.of<DatosMPIPSProvider>(context, listen: false)
                    .updateDatito(widget.id, updatedDatito);

                Navigator.pop(context);
             },
            ),
          ]));
        }));
  }
}

class FormularioGeneralDatosMPIPS extends StatelessWidget {
  const FormularioGeneralDatosMPIPS({
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

          DropdownSimple(
            name: 'MateriPrima',
            label: 'Materiprima',
            textoError: 'Selecciona',
            valorInicial: widget.datosMpIps.MateriPrima,
            opciones: 'MateriaPrima',
            dropOptions: dropOptions,
            onChanged: (value) {
              final field = _formKey.currentState?.fields['MateriPrima'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
          ),

          TextoSimple(
              name: 'INTF',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['INTF'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Intf',
              valorInicial: widget.datosMpIps.INTF.toString(),
              textoError: 'error'),

          DropdownSimple(
            name: 'CantidadEmpaque',
            label: 'Cantidadempaque',
            textoError: 'Selecciona',
            valorInicial: widget.datosMpIps.CantidadEmpaque,
            opciones: 'CantidadEmapque',
            dropOptions: dropOptions,
            onChanged: (value) {
              final field = _formKey.currentState?.fields['CantidadEmpaque'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
          ),

          TextoSimple(
              name: 'Identif',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Identif'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Identif',
              valorInicial: widget.datosMpIps.Identif.toString(),
              textoError: 'error'),

          DropdownSimple<dynamic>(
            name: 'CantidadBolsones',
            label: 'Cantidadbolsones',
            textoError: 'Selecciona',
            valorInicial: widget.datosMpIps.CantidadBolsones,
            opciones: 'CantidadBolsones',
            dropOptions: dropOptions,
            onChanged: (value) {
              final field = _formKey.currentState?.fields['CantidadBolsones'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
          ),

          TextoSimple(
              name: 'Dosificacion',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Dosificacion'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Dosificacion',
              valorInicial: widget.datosMpIps.Dosificacion.toString(),
              textoError: 'error'),

          TextoSimple(
              name: 'Humedad',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Humedad'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'Humedad',
              valorInicial: widget.datosMpIps.Humedad.toString(),
              textoError: 'error'),

          const SizedBox(height: 15,),
          CheckboxSimple(
            label: 'Conformidad',
            name: 'Conformidad',
            valorInicial: widget.datosMpIps.Conformidad,
          ),

    ]
      ),
    );
  }
}