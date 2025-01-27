import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/providers/preformas_ips_provider/formulario_principal.dart';
import 'package:proyecto/src/widgets/boton_agregar.dart';
import 'package:proyecto/src/widgets/boton_guardarform.dart';
import 'package:proyecto/src/widgets/checkboxformulario.dart';
import 'package:proyecto/src/widgets/dropdownformulario.dart';

import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';
import 'package:proyecto/src/widgets/titulos.dart';
import 'package:sqflite/sqflite.dart';

class DatosPESOSIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final String PA;
  final double PesoTara;
  final double PesoNeto;
  final double PesoTotal;

  // Constructor de la clase
  const DatosPESOSIPS(
      {this.id,
      required this.hasErrors,
      required this.Hora,
      required this.PA,
      required this.PesoTara,
      required this.PesoNeto,
      required this.PesoTotal});

  // Factory para crear una instancia desde un Map
  factory DatosPESOSIPS.fromMap(Map<String, dynamic> map) {
    return DatosPESOSIPS(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        Hora: map['Hora'] as String,
        PA: map['PA'] as String,
        PesoTara: map['PesoTara'] as double,
        PesoNeto: map['PesoNeto'] as double,
        PesoTotal: map['PesoTotal'] as double);
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'Hora': Hora,
      'PA': PA,
      'PesoTara': PesoTara,
      'PesoNeto': PesoNeto,
      'PesoTotal': PesoTotal
    };
  }

  // Método copyWith
  DatosPESOSIPS copyWith(
      {int? id,
      bool? hasErrors,
      String? Hora,
      String? PA,
      double? PesoTara,
      double? PesoNeto,
      double? PesoTotal}) {
    return DatosPESOSIPS(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        Hora: Hora ?? this.Hora,
        PA: PA ?? this.PA,
        PesoTara: PesoTara ?? this.PesoTara,
        PesoNeto: PesoNeto ?? this.PesoNeto,
        PesoTotal: PesoTotal ?? this.PesoTotal);
  }
}

class DatosPESOSIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosPESOSIPS = 'datosPESOSIPS';
  List<DatosPESOSIPS> _datospesosipsList = [];

  List<DatosPESOSIPS> get datospesosipsList =>
      List.unmodifiable(_datospesosipsList);

  DatosPESOSIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosPESOSIPS.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosPESOSIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        PA TEXT NOT NULL,
        PesoTara REAL NOT NULL,
        PesoNeto REAL NOT NULL,
        PesoTotal REAL NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosPESOSIPS);
    _datospesosipsList = maps.map((map) => DatosPESOSIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosPESOSIPS nuevoDato) async {
    final id = await _db.insert(tableDatosPESOSIPS, nuevoDato.toMap());
    _datospesosipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosPESOSIPS updatedDato) async {
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

  Future<void> removeDatito(BuildContext context, int id) async {
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
          tableDatosPESOSIPS); // Elimina todos los registros de la tabla
      _datospesosipsList.clear(); // Limpia la lista local
      notifyListeners(); // Notifica los cambios

      // Muestra un mensaje de confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Todos los registros han sido eliminados.')),
      );
    }
  }
}

class ScreenListDatosPESOSIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosPESOSIPSProvider>(context, listen: false);
    return Scaffold(
        body: Column(children: [
      Titulos(
        titulo: 'REGISTRO PESOS',
        tipo: 1,
        eliminar: () => provider.removeAllDatitos(context),
      ),
      Expanded(
        child: Consumer<DatosPESOSIPSProvider>(
          builder: (context, provider, _) {
            final datospesosips = provider.datospesosipsList;
            if (datospesosips.isEmpty) {
              return const Center(
                child: Text(
                  'No hay registros aún.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.separated(
              itemCount: datospesosips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final dtdatospesosips = datospesosips[index];

                return GradientExpandableCard(
                  idlista: dtdatospesosips.id,
                  onSwipedAction: () async {
                    await provider.removeDatito(context, dtdatospesosips.id!);
                  },
                  variableCambiarVentana: EditDatosPESOSIPSForm(
                    id: dtdatospesosips.id!,
                    datosPESOSIPS: dtdatospesosips,
                  ),
                  numeroindex: (index + 1).toString(),
                  subtitulos: {
                    'Hora ': dtdatospesosips.Hora,
                    'PA': dtdatospesosips.PA
                  },
                  expandedContent: generateExpandableContent([
                    ['Peso Tara ', 1, '${dtdatospesosips.PesoTara} Kg'],
                    ['Peso Neto ', 1, '${dtdatospesosips.PesoNeto} Kg'],
                    ['Peso Total ', 1, '${dtdatospesosips.PesoTotal} Kg'],
                  ]),
                  hasErrors: dtdatospesosips.hasErrors,
                  onOpenModal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDatosPESOSIPSForm(
                          id: dtdatospesosips.id!,
                          datosPESOSIPS: dtdatospesosips,
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
    ]),
    bottomNavigationBar:BotonAgregar(provider: provider,datos: DatosPESOSIPS(hasErrors: false, Hora: 'ola', PA: 'ola', PesoTara: 0, PesoNeto: 0, PesoTotal: 0) ,),
    );
  }
}

class EditProviderDatosPESOSIPS with ChangeNotifier {
  double _pesoNeto = 0.0;

  double get pesoNeto => _pesoNeto;

  set pesoNeto(double value) {
    _pesoNeto = value;
    notifyListeners();
  }
}

class EditDatosPESOSIPSForm extends StatefulWidget {
  final int id;
  final DatosPESOSIPS datosPESOSIPS;

  const EditDatosPESOSIPSForm(
      {required this.id, required this.datosPESOSIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosPESOSIPSFormState createState() => _EditDatosPESOSIPSFormState();
}

class _EditDatosPESOSIPSFormState extends State<EditDatosPESOSIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosPESOSIPS = {
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
    return Consumer<EditProviderDatosPESOSIPS>(
      builder: (context, provider, child) {
        return Scaffold(
            body: Column(children: [
          Titulos(titulo: 'Formulario de Pesos', tipo: 0),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: FormularioGeneralDatosPESOSIPS(
                  formKey: _formKey,
                  widget: widget,
                  dropOptions: dropOptionsDatosPESOSIPS,
                ),
              ),
            ),
          ),
          BotonGuardarForm(onPressed: () {
                    _formKey.currentState?.save();
                    final values = _formKey.currentState!.value;

                    final updatedDatito = widget.datosPESOSIPS.copyWith(
                      hasErrors: _formKey.currentState?.fields.values
                              .any((field) => field.hasError) ??
                          false,
                      Hora: values['Hora'] ?? widget.datosPESOSIPS.Hora,
                      PA: values['PA'] ?? widget.datosPESOSIPS.PA,
                      PesoTara: (values['PesoTara']?.isEmpty ?? true)
                          ? 0
                          : double.tryParse(values['PesoTara']),
                      PesoNeto: (values['PesoNeto']?.isEmpty ?? true)
                          ? 0
                          : double.tryParse(values['PesoNeto']),
                      PesoTotal: (values['PesoTotal']?.isEmpty ?? true)
                          ? 0
                          : double.tryParse(values['PesoTotal']),
                    );

                    Provider.of<DatosPESOSIPSProvider>(context, listen: false)
                        .updateDatito(widget.id, updatedDatito);

                    Navigator.pop(context);
                  } ,)
        ]));
      },
    );
  }
}





class FormularioGeneralDatosPESOSIPS extends StatelessWidget {
  const FormularioGeneralDatosPESOSIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final widget;
  final Map<String, List<dynamic>> dropOptions;
  void _updatePesoTotal(BuildContext context) {
    final formState = _formKey.currentState;

    if (formState != null) {
      // Obtén los valores actuales de PesoTara y PesoNeto
      final pesoTara =
          double.tryParse(formState.fields['PesoTara']?.value ?? '0') ?? 0.0;
      final pesoNeto =
          double.tryParse(formState.fields['PesoNeto']?.value ?? '0') ?? 0.0;

      // Calcula el PesoTotal
      final pesoTotal = pesoTara + pesoNeto;

      // Actualiza el campo PesoTotal
      formState.fields['PesoTotal']?.didChange(pesoTotal.toStringAsFixed(2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          TextoSimple(
              name: 'Hora',
              onChanged:(value) {
        final field = _formKey.currentState?.fields['Hora'];
        field?.validate(); 
        field?.save();
      } ,
              label: 'Hora',
              valorInicial: widget.datosPESOSIPS.Hora,
              textoError: 'error'),

          DropdownSimple(name:'Opciones' , label: 'Opciones',
          
          
          
           textoError: 'Seleciona', opciones:'Opciones',
           dropOptions:dropOptions ,onChanged: (value) {
              final field = _formKey.currentState?.fields['MateriPrima'];
              field?.validate(); // Valida solo este campo
              field?.save();
            }, ),
          CheckboxSimple(label: 'ola',
          name: 'ola',   
          valorInicial: true  ,),

          TextoSimple(
              name: 'PesoTara',
              onChanged:(value) {
              final field = _formKey.currentState?.fields['PesoTara'];
              field?.validate(); // Valida solo este campo
              field?.save();
              _updatePesoTotal(context);
            },
              label: 'PesoTara',
              valorInicial:widget.datosPESOSIPS.PesoTara.toString(),
              textoError: 'error'),
          
          TextoSimple(
              name: 'PesoNeto',
              onChanged:(value) {
              final provider = context.read<ProviderPesoPromedio>();
              provider.pesoNeto = double.tryParse(value?.trim() ?? '0') ?? 0.0;
              final field = _formKey.currentState?.fields['PesoNeto'];
              field?.validate(); // Valida solo este campo
              field?.save();
              _updatePesoTotal(context);
            },
              label: 'PesoNeto',
              valorInicial:context.watch<EditProviderDatosPESOSIPS>().pesoNeto.toString(),
              textoError: 'error'),

          TextoSimple(
              name: 'PesoTotal',
              onChanged:(value) {
              final field = _formKey.currentState?.fields['PesoTotal'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
              label: 'PesoTotal',
              valorInicial:widget.datosPESOSIPS.PesoTotal.toString(),
              textoError: 'error'),       
          
          
          
        ]));
  }
}


