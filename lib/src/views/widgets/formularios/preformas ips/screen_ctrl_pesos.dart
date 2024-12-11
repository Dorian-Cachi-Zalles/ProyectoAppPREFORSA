import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
import 'package:intl/intl.dart';

class DatosPesosIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final String PA;
  final int PesoTara;
  final int PesoNeto;
  final int PesoTotal;

  // Constructor de la clase
  const DatosPesosIPS({
    this.id,
    required this.hasErrors,
    required this.Hora,
    required this.PA,
    required this.PesoTara,
    required this.PesoNeto,
    required this.PesoTotal
  });

  // Factory para crear una instancia desde un Map
  factory DatosPesosIPS.fromMap(Map<String, dynamic> map) {
    return DatosPesosIPS(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      Hora: map['Hora'] as String,
      PA: map['PA'] as String,
      PesoTara: map['PesoTara'] as int,
      PesoNeto: map['PesoNeto'] as int,
      PesoTotal: map['PesoTotal'] as int
    );
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
  DatosPesosIPS copyWith({
    int? id,
    bool? hasErrors,
    String? Hora, String? PA, int? PesoTara, int? PesoNeto, int? PesoTotal
  }) {
    return DatosPesosIPS(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      Hora: Hora ?? this.Hora,
      PA: PA ?? this.PA,
      PesoTara: PesoTara ?? this.PesoTara,
      PesoNeto: PesoNeto ?? this.PesoNeto,
      PesoTotal: PesoTotal ?? this.PesoTotal
    );
  }
}


class DatosPesosIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosPesosIPS = 'datosPesosIPS';
  List<DatosPesosIPS> _datospesosipsList = [];

  List<DatosPesosIPS> get datospesosipsList => List.unmodifiable(_datospesosipsList);

  DatosPesosIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosPesosIPS.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosPesosIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        PA TEXT NOT NULL,
        PesoTara INTEGER NOT NULL,
        PesoNeto INTEGER NOT NULL,
        PesoTotal INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosPesosIPS);
    _datospesosipsList = maps.map((map) => DatosPesosIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosPesosIPS nuevoDato) async {
    final id = await _db.insert(tableDatosPesosIPS, nuevoDato.toMap());
    _datospesosipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosPesosIPS updatedDato) async {
    final index = _datospesosipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosPesosIPS,
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
        tableDatosPesosIPS,
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
              final newId = await _db.insert(tableDatosPesosIPS, deletedData.toMap());
              _datospesosipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }
}


class ScreenListDatosPesosIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosPesosIPSProvider>(context, listen: false);
    return Scaffold(      
      body: Consumer<DatosPesosIPSProvider>(
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

              return SwipeableTile.card(
                horizontalPadding: 16,
                verticalPadding: 10,
                key: ValueKey(dtdatospesosips.id),
                swipeThreshold: 0.5,
                resizeDuration: const Duration(milliseconds: 300),
                color: Colors.white,
                shadow: const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
                direction: SwipeDirection.endToStart,
                onSwiped: (_) => provider.removeDatito(context, dtdatospesosips.id!),
                backgroundBuilder: (context, direction, progress) {
                  return Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDatosPesosIPSForm(
                          id: dtdatospesosips.id!,
                          datosPesosIPS: dtdatospesosips,
                        ),
                      ),
                    );
                  },
                  child: GradientExpandableCard(
                    title: (index + 1).toString(),
                    subtitle: 'Prueba',
                    expandedContent: [
                  ExpandableContent(label: 'Hora: ', stringValue: dtdatospesosips.Hora.toString()),
                  ExpandableContent(label: 'PA: ', stringValue: dtdatospesosips.PA.toString()),
                  ExpandableContent(label: 'PesoTara: ', stringValue: dtdatospesosips.PesoTara.toString()),
                  ExpandableContent(label: 'PesoNeto: ', stringValue: dtdatospesosips.PesoNeto.toString()),
                  ExpandableContent(label: 'PesoTotal: ', stringValue: dtdatospesosips.PesoTotal.toString()),
                    ],
                    hasErrors: dtdatospesosips.hasErrors,
                    onOpenModal: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDatosPesosIPSForm(
                            id: dtdatospesosips.id!,
                            datosPesosIPS: dtdatospesosips,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: 53,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
              ),
            ),
            onPressed: ()  {
          provider.addDatito(
            DatosPesosIPS(
            hasErrors: true,
              Hora: DateFormat('HH:mm').format(DateTime.now()),
              PA: '',
              PesoTara: 0,
              PesoNeto: 0,
              PesoTotal: 0,
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'AGREGAR UN REGISTRO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
      ),
    )));
  }
}


    class EditProviderDatosPesosIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosPesosIPSForm extends StatefulWidget {
  final int id;
  final DatosPesosIPS datosPesosIPS;

  const EditDatosPesosIPSForm({required this.id, required this.datosPesosIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosPesosIPSFormState createState() => _EditDatosPesosIPSFormState();
}

class _EditDatosPesosIPSFormState extends State<EditDatosPesosIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosPesosIPS = {
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
      create: (_) => EditProviderDatosPesosIPS(),
      child: Consumer<EditProviderDatosPesosIPS>(
        builder: (context, provider, child) {
          return Scaffold(
          body: Column(
              children:[
               Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormularioGeneralDatosPesosIPS(
              formKey: _formKey,
              widget: widget,
              dropOptions: dropOptionsDatosPesosIPS,
            ),),),),
          Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste para teclado
      ),
      child:SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.black),
                    label: const Text(
                      'GUARDAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
                      ),
                    ),
            onPressed: () {
                _formKey.currentState?.save();
                final values = _formKey.currentState!.value;

                final updatedDatito = widget.datosPesosIPS.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  Hora: values['Hora'] ?? widget.datosPesosIPS.Hora,
                  PA: values['PA'] ?? widget.datosPesosIPS.PA,
                  PesoTara:(values['PesoTara']?.isEmpty ?? true)? 0 : int.tryParse(values['PesoTara']),
                  PesoNeto:(values['PesoNeto']?.isEmpty ?? true)? 0 : int.tryParse(values['PesoNeto']),
                  PesoTotal:(values['PesoTotal']?.isEmpty ?? true)? 0 : int.tryParse(values['PesoTotal']),

                );

                Provider.of<DatosPesosIPSProvider>(context, listen: false)
                    .updateDatito(widget.id, updatedDatito);

                Navigator.pop(context);
            },
            ),)
             )]
            )
          );

        },
      ),
    );
  }
}

class FormularioGeneralDatosPesosIPS extends StatelessWidget {
  const FormularioGeneralDatosPesosIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final  widget;
  final Map<String, List<dynamic>> dropOptions;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [

          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'Hora',
            initialValue: widget.datosPesosIPS.Hora,
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Hora'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Hora',
            labelStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold), 
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: TextStyle(
              fontSize: 13, // Tamaño de fuente del mensaje de error
              height: 1,  // Altura de línea (mayor para permitir dos líneas)
              color: Colors.red, // Color del mensaje de error (puedes personalizarlo)
            ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState?.fields['Hora']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'PA',
            initialValue: widget.datosPesosIPS.PA,
            onChanged: (value) {
            final field = _formKey.currentState?.fields['PA'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Pa',
            labelStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold), 
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: TextStyle(
              fontSize: 13, // Tamaño de fuente del mensaje de error
              height: 1,  // Altura de línea (mayor para permitir dos líneas)
              color: Colors.red, // Color del mensaje de error (puedes personalizarlo)
            ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState?.fields['PA']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'PesoTara',
            initialValue: widget.datosPesosIPS.PesoTara.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['PesoTara'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Pesotara',
            labelStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold), 
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: TextStyle(
              fontSize: 13, // Tamaño de fuente del mensaje de error
              height: 1,  // Altura de línea (mayor para permitir dos líneas)
              color: Colors.red, // Color del mensaje de error (puedes personalizarlo)
            ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState?.fields['PesoTara']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'PesoNeto',
            initialValue: widget.datosPesosIPS.PesoNeto.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['PesoNeto'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Pesoneto',
            labelStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold), 
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: TextStyle(
              fontSize: 13, // Tamaño de fuente del mensaje de error
              height: 1,  // Altura de línea (mayor para permitir dos líneas)
              color: Colors.red, // Color del mensaje de error (puedes personalizarlo)
            ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState?.fields['PesoNeto']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'PesoTotal',
            initialValue: widget.datosPesosIPS.PesoTotal.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['PesoTotal'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Pesototal',
            labelStyle: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold), 
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: TextStyle(
              fontSize: 13, // Tamaño de fuente del mensaje de error
              height: 1,  // Altura de línea (mayor para permitir dos líneas)
              color: Colors.red, // Color del mensaje de error (puedes personalizarlo)
            ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState?.fields['PesoTotal']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),
          ),
    ]
          )
          );
  }
}