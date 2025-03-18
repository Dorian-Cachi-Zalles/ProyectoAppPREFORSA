import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/services/bdpreformas.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/Providerids.dart';
import 'package:proyecto/src/widgets/nuevobotonguardar.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/formulario_principal.dart';
import 'package:proyecto/src/widgets/boton_agregar.dart';
import 'package:proyecto/src/widgets/boxpendiente.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';
import 'package:proyecto/src/widgets/titulos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatosPESOSIPS {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int idregistro;
  final String Hora;
  final String PA;
  final double PesoTara;
  final double PesoNeto;
  final double PesoTotal;

  // Constructor de la clase
  const DatosPESOSIPS(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.idregistro,
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
        hasSend: map['hasSend'] == 1,
        idregistro: map['idregistro'] as int,        
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
      'hasSend': hasSend ? 1 : 0,
      'idregistro': idregistro,
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
      bool? hasSend,
      int? idregistro,
      String? Hora,
      String? PA,
      double? PesoTara,
      double? PesoNeto,
      double? PesoTotal}) {
    return DatosPESOSIPS(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        idregistro: idregistro ?? this.idregistro,
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
      version: 2,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
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

 Future<void> removeAllDatitos() async {
  await _db.delete(tableDatosPESOSIPS);
  _datospesosipsList.clear();
  notifyListeners();
}

  Future<bool> enviarDatosAPIPost(int id) async {
    final url = Uri.parse("http://192.168.0.138:8000/api/pesosips");

    // Buscar el dato actualizado en SQLite
    final index = _datospesosipsList.indexWhere((d) => d.id == id);
    if (index == -1) {
      print("❌ Error: No se encontró el dato con ID $id en SQLite");
      return false;
    }

    final DatosPESOSIPS dato = _datospesosipsList[index];

    // Convertir a JSON sin 'id' y 'hasErrors'
    final Map<String, dynamic> datosJson = {
      "Hora": dato.Hora,
      "PA": dato.PA,
      "PesoTara": dato.PesoTara,
      "PesoNeto": dato.PesoNeto,
      "PesoTotal": dato.PesoTotal,
    };

    print("📤 Enviando datos a la API: $datosJson");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(datosJson),
      );

      print(
          "📥 Respuesta del servidor: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 201) {
        return true;
      } else {
        print("❌ Error al enviar datos. Código: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error de conexión: $e");
      return false;
    }
  }
}

class ScreenListDatosPESOSIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
    final providerregistro = Provider.of<IdsProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Titulos(
            titulo: 'REGISTROS DE PESOS',
            tipo: 0,
            accion: () => provider.removeAllPesos(),
          ),
          Expanded(
            child: Consumer<DatosProviderPrefIPS>(
              builder: (context, provider, _) {
                final datosPESOSIPS = provider.datospesosipsList;

                if (datosPESOSIPS.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay registros aún.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: datosPESOSIPS.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final dtdatospesosips = datosPESOSIPS[index];

                    return GradientExpandableCard(
                      idlista: dtdatospesosips.id,
                      hasSend: dtdatospesosips.hasSend, 
                      numeroindex: (index + 1).toString(),
                      onSwipedAction:() async {
                        await provider.removePeso(
                            context, dtdatospesosips.id!);
                      },
                      subtitulos: {},
                      expandedContent: generateExpandableContent([
                        ['Hora: ', 1, dtdatospesosips.Hora],
                        ['PA: ', 1, dtdatospesosips.PA],
                        ['PesoTara: ', 1, dtdatospesosips.PesoTara.toString()],
                        ['PesoNeto: ', 1, dtdatospesosips.PesoNeto.toString()],
                        ['PesoTotal: ',1,dtdatospesosips.PesoTotal.toString()],
                      ]),
                      hasErrors: dtdatospesosips.hasErrors,
                      onOpenModal:  dtdatospesosips.hasSend  ? () {} :() {
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
        ],
      ),
      bottomNavigationBar: BotonAgregar(
        onPressed: () async {
  int? idregistro = await providerregistro.getNumeroById(1);

  if (idregistro == null || idregistro == 0) {
    print("El idregistro no es válido, no se ejecutará addPesosIPS");
    return; // Detiene la ejecución si el idregistro es 0 o null
  } provider.addPesosIPS(DatosPESOSIPS(
    hasErrors: true,
    hasSend: false,
    idregistro: idregistro,  // Ya sabemos que no es 0 ni null
    Hora: DateFormat('HH:mm').format(DateTime.now()),
    PA: '',
    PesoTara: 45,
    PesoNeto: 0,
    PesoTotal: 0,
  ));  
},
      ),
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
          BotonDeslizable(
  onPressed: () async{
  _formKey.currentState?.save();
  final values = _formKey.currentState!.value;
  final updatedDatito = widget.datosPESOSIPS.copyWith(
    hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
    idregistro:widget.datosPESOSIPS.idregistro ,
    Hora: values['Hora'] ?? widget.datosPESOSIPS.Hora,
    PA: values['PA'] ?? widget.datosPESOSIPS.PA,
    PesoTara: (values['PesoTara']?.isEmpty ?? true)? 0: double.tryParse(values['PesoTara']),
    PesoNeto: (values['PesoNeto']?.isEmpty ?? true)? 0: double.tryParse(values['PesoNeto']),
    PesoTotal: (values['PesoTotal']?.isEmpty ?? true)? 0: double.tryParse(values['PesoTotal']),  

  ); 

  final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);

  await provider.updatePESO(widget.id, updatedDatito);

  Navigator.pop(context);
},
  onSwipedAction: () async{
   final providerregistro = Provider.of<DatosProviderPrefIPS>(context, listen: false);

bool enviado = await providerregistro.enviarDatosAPIPeso(widget.id);

if (!enviado) {
  print("❌ Error al enviar los datos");

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Error al enviar los datos. Verifique su conexión."),
      backgroundColor: Colors.red,
    ),
  );
} else {
  final terminar = widget.datosPESOSIPS.copyWith(hasSend: true);

  final provider = Provider.of<DatosProviderPrefIPS>(context, listen: false);
  await provider.updatePESO(widget.id, terminar);

  Navigator.pop(context);
}
    
  },
),

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
              onChanged: (value) {
                final field = _formKey.currentState?.fields['Hora'];
                field?.validate();
                field?.save();
              },
              label: 'Hora',
              valorInicial: widget.datosPESOSIPS.Hora,
              textoError: 'error'),
          TextoSimple(
              name: 'PA',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['PA'];
                field?.validate();
                field?.save();
              },
              label: 'PA',
              valorInicial: widget.datosPESOSIPS.PA,
              textoError: 'error'),
        CustomInputField(
              name: 'PesoTara',              
              onChanged: (value) {                
                final field = _formKey.currentState?.fields['PesoTara'];
                field?.validate(); // Valida solo este campo
                field?.save();
                _updatePesoTotal(context);
              },
              label: 'PesoTara',
              valorInicial: widget.datosPESOSIPS.PesoTara.toString(),
              isNumeric: true,
              isRequired: true,
              max: 100.6,
              min: 70,
              ),
          TextoSimple(
              name: 'PesoNeto',
              onChanged: (value) {
                final provider = context.read<ProviderPesoPromedio>();
                provider.pesoNeto =
                    double.tryParse(value?.trim() ?? '0') ?? 0.0;
                final field = _formKey.currentState?.fields['PesoNeto'];
                field?.validate(); // Valida solo este campo
                field?.save();
                _updatePesoTotal(context);
              },
              label: 'PesoNeto',
              valorInicial: context
                  .watch<EditProviderDatosPESOSIPS>()
                  .pesoNeto
                  .toString(),
              textoError: 'error'),
          TextoSimple(
              name: 'PesoTotal',
              onChanged: (value) {
                final field = _formKey.currentState?.fields['PesoTotal'];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              label: 'PesoTotal',
              valorInicial: widget.datosPESOSIPS.PesoTotal.toString(),
              textoError: 'error'),
        ]));
  }
}
