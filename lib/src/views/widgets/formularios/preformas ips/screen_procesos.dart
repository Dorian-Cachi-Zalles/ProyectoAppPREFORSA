import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class DatosPROCESIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final String PAProd;
  final List<double> TempTolvaSec;
  final double TempProd;
  final double Tciclo;
  final double Tenfri;

  // Constructor de la clase
  const DatosPROCESIPS({
    this.id,
    required this.hasErrors,
    required this.Hora,
    required this.PAProd,
    required this.TempTolvaSec,
    required this.TempProd,
    required this.Tciclo,
    required this.Tenfri
  });

  // Factory para crear una instancia desde un Map
  factory DatosPROCESIPS.fromMap(Map<String, dynamic> map) {
    return DatosPROCESIPS(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      Hora: map['Hora'] as String,
      PAProd: map['PAProd'] as String,
      TempTolvaSec: map['TempTolvaSec'] as List<double>,
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
      'PAProd': PAProd,
      'TempTolvaSec': TempTolvaSec.join(','),
      'TempProd': TempProd,
      'Tciclo': Tciclo,
      'Tenfri': Tenfri
    };
  }

  // Método copyWith
  DatosPROCESIPS copyWith({
    int? id,
    bool? hasErrors,
    String? Hora, String? PAProd, List<double>? TempTolvaSec, double? TempProd, double? Tciclo, double? Tenfri
  }) {
    return DatosPROCESIPS(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      Hora: Hora ?? this.Hora,
      PAProd: PAProd ?? this.PAProd,
      TempTolvaSec: TempTolvaSec ?? this.TempTolvaSec,
      TempProd: TempProd ?? this.TempProd,
      Tciclo: Tciclo ?? this.Tciclo,
      Tenfri: Tenfri ?? this.Tenfri
    );
  }
}


class DatosPROCESIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosPROCESIPS = 'datosPROCESFIPS';
  List<DatosPROCESIPS> _datosprocesipsList = [];

  List<DatosPROCESIPS> get datosprocesipsList => List.unmodifiable(_datosprocesipsList);

  DatosPROCESIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosPROCESFIPS.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosPROCESIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        PAProd TEXT NOT NULL,
        TempTolvaSec TEXT NOT NULL,
        TempProd REAL NOT NULL,
        Tciclo REAL NOT NULL,
        Tenfri REAL NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosPROCESIPS);
    _datosprocesipsList = maps.map((map) => DatosPROCESIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosPROCESIPS nuevoDato) async {
    final id = await _db.insert(tableDatosPROCESIPS, nuevoDato.toMap());
    _datosprocesipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosPROCESIPS updatedDato) async {
    final index = _datosprocesipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosPROCESIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosprocesipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> removeDatito(BuildContext context, int id) async {
    final index = _datosprocesipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datosprocesipsList[index];
      await _db.delete(
        tableDatosPROCESIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datosprocesipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId = await _db.insert(tableDatosPROCESIPS, deletedData.toMap());
              _datosprocesipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }
}


class ScreenListDatosPROCESIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosPROCESIPSProvider>(context, listen: false);
    return Scaffold(
        body: Consumer<DatosPROCESIPSProvider>(
        builder: (context, provider, _) {
          final datosprocesips = provider.datosprocesipsList;

          if (datosprocesips.isEmpty) {
            return const Center(
              child: Text(
                'No hay registros aún.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            itemCount: datosprocesips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final dtdatosprocesips = datosprocesips[index];

              return SwipeableTile.card(
                horizontalPadding: 16,
                verticalPadding: 10,
                key: ValueKey(dtdatosprocesips.id),
                swipeThreshold: 0.5,
                resizeDuration: const Duration(milliseconds: 300),
                color: Colors.white,
                shadow: const BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
                direction: SwipeDirection.endToStart,
                onSwiped: (_) => provider.removeDatito(context, dtdatosprocesips.id!),
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
                        builder: (context) => EditDatosPROCESIPSForm(
                          id: dtdatosprocesips.id!,
                          datosPROCESFIPS: dtdatosprocesips,
                        ),
                      ),
                    );
                  },
                  child: GradientExpandableCard(
                    title: (index + 1).toString(),
                    subtitle: 'Prueba',
                    expandedContent: [
                  ExpandableContent(label: 'Hora: ', stringValue: dtdatosprocesips.Hora.toString()),
                  ExpandableContent(label: 'PAProd: ', stringValue: dtdatosprocesips.PAProd.toString()),
                  ExpandableContent(label: 'TempTolvaSec: ', doubleListValue: dtdatosprocesips.TempTolvaSec),
                  ExpandableContent(label: 'TempProd: ', stringValue: dtdatosprocesips.TempProd.toString()),
                  ExpandableContent(label: 'Tciclo: ', stringValue: dtdatosprocesips.Tciclo.toString()),
                  ExpandableContent(label: 'Tenfri: ', stringValue: dtdatosprocesips.Tenfri.toString()),
                    ],
                    hasErrors: dtdatosprocesips.hasErrors,
                    onOpenModal: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditDatosPROCESIPSForm(
                            id: dtdatosprocesips.id!,
                            datosPROCESFIPS: dtdatosprocesips,
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
            DatosPROCESIPS(
            hasErrors: true,
              Hora: DateFormat('HH:mm').format(DateTime.now()),
              PAProd: '',
              TempTolvaSec: [0,0,0],
              TempProd: 0,
              Tciclo: 0,
              Tenfri: 0,
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


    class EditProviderDatosPROCESIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosPROCESIPSForm extends StatefulWidget {
  final int id;
  final DatosPROCESIPS datosPROCESFIPS;

  const EditDatosPROCESIPSForm({required this.id, required this.datosPROCESFIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosPROCESIPSFormState createState() => _EditDatosPROCESIPSFormState();
}

class _EditDatosPROCESIPSFormState extends State<EditDatosPROCESIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosPROCESIPS = {
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
      create: (_) => EditProviderDatosPROCESIPS(),
      child: Consumer<EditProviderDatosPROCESIPS>(
        builder: (context, provider, child) {
          return Scaffold(
          body: Column(
              children:[
               Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormularioGeneralDatosPROCESIPS(
              formKey: _formKey,
              widget: widget,
              dropOptions: dropOptionsDatosPROCESIPS,
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

                final updatedDatito = widget.datosPROCESFIPS.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  Hora: values['Hora'] ?? widget.datosPROCESFIPS.Hora,
                  PAProd: values['PAProd'] ?? widget.datosPROCESFIPS.PAProd,
                  TempTolvaSec: values['TempTolvaSec'] ?? widget.datosPROCESFIPS.TempTolvaSec,
                  TempProd:(values['TempProd']?.isEmpty ?? true)? 0 : double.tryParse(values['TempProd']),
                  Tciclo:(values['Tciclo']?.isEmpty ?? true)? 0 : double.tryParse(values['Tciclo']),
                  Tenfri:(values['Tenfri']?.isEmpty ?? true)? 0 : double.tryParse(values['Tenfri']),

                );

                Provider.of<DatosPROCESIPSProvider>(context, listen: false)
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

class FormularioGeneralDatosPROCESIPS extends StatelessWidget {
  const FormularioGeneralDatosPROCESIPS({
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
            initialValue: widget.datosPROCESFIPS.Hora,
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
          FormBuilderDropdown<String>(
            name: 'PAProd',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['PAProd'];
            field?.validate(); // Valida solo este campo
            field?.save();
            },
            initialValue: widget.datosPROCESFIPS.PAProd,
            decoration: InputDecoration(labelText: 'Paprod',
            labelStyle: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 20, 100, 96),fontWeight: FontWeight.bold),   
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: const Color.fromARGB(255, 29, 57, 80), width: 1.5),
            ),
            ),
            items: dropOptions['Opciones']!
                .map((option) => DropdownMenuItem<String>(
                      value: option as String,
                      child: Text(option.toString()),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(errorText: 'Seleccione una opción'),
          ),
            const SizedBox(height: 15,),
          ...List.generate(
            widget.datosPROCESFIPS.TempTolvaSec.length,
            (index) =>Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child:FormBuilderTextField(
              name: 'TempTolvaSec_$index',
              initialValue: widget.datosPROCESFIPS.TempTolvaSec[index].toString(),
              onChanged: (value) {
            final field = _formKey.currentState?.fields['TempTolvaSec_$index'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
              labelText: 'TempTolvaSec ' + (index + 1).toString(),
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
                  final isValid = _formKey.currentState?.fields['TempTolvaSec_$index']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
                  ),
              keyboardType: TextInputType.text,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'El campo no puede 7f estar vacío'),

                FormBuilderValidators.integer(errorText: 'Debe ser un número 7f entero'),
                FormBuilderValidators.min(0, errorText: 'Debe ser mayor o 7f igual a 0'),
                FormBuilderValidators.max(100, errorText: 'Debe ser menor o 7f igual a 100'),

              ]),
            ),),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'TempProd',
            initialValue: widget.datosPROCESFIPS.TempProd.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['TempProd'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Tempprod',
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
                  final isValid = _formKey.currentState?.fields['TempProd']?.isValid ?? false;
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
            name: 'Tciclo',
            initialValue: widget.datosPROCESFIPS.Tciclo.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Tciclo'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Tciclo',
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
                  final isValid = _formKey.currentState?.fields['Tciclo']?.isValid ?? false;
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
            name: 'Tenfri',
            initialValue: widget.datosPROCESFIPS.Tenfri.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Tenfri'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Tenfri',
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
                  final isValid = _formKey.currentState?.fields['Tenfri']?.isValid ?? false;
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