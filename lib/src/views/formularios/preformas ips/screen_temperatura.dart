import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/titulospeq.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class DatosTEMPIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final String Fase;
  final List<int> Cavidades;
  final List<double> Tcuerpo;
  final List<double> Tcuello;

  // Constructor de la clase
  const DatosTEMPIPS({
    this.id,
    required this.hasErrors,
    required this.Hora,
    required this.Fase,
    required this.Cavidades,
    required this.Tcuerpo,
    required this.Tcuello
  });

  // Factory para crear una instancia desde un Map
  factory DatosTEMPIPS.fromMap(Map<String, dynamic> map) {
    return DatosTEMPIPS(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      Hora: map['Hora'] as String,
      Fase: map['Fase'] as String,
      Cavidades: (map['Cavidades'] as String).split(',').where((item) => item.isNotEmpty).map(int.parse).toList(),
      Tcuerpo: (map['Tcuerpo'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      Tcuello: (map['Tcuello'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList()
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'Hora': Hora,
      'Fase': Fase,
      'Cavidades': Cavidades.join(','),
      'Tcuerpo': Tcuerpo.join(','),
      'Tcuello': Tcuello.join(',')
    };
  }

  // Método copyWith
  DatosTEMPIPS copyWith({
    int? id,
    bool? hasErrors,
    String? Hora, String? Fase, List<int>? Cavidades, List<double>? Tcuerpo, List<double>? Tcuello
  }) {
    return DatosTEMPIPS(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      Hora: Hora ?? this.Hora,
      Fase: Fase ?? this.Fase,
      Cavidades: Cavidades ?? this.Cavidades,
      Tcuerpo: Tcuerpo ?? this.Tcuerpo,
      Tcuello: Tcuello ?? this.Tcuello
    );
  }
}


class DatosTEMPIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosTEMPIPS = 'datosTEMPIPS';
  List<DatosTEMPIPS> _datostempipsList = [];

  List<DatosTEMPIPS> get datostempipsList => List.unmodifiable(_datostempipsList);

  DatosTEMPIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosTEMPIPS.db'),
      version: 1,
      onCreate: (db, version) => createTable(db),
    );
    await _loadData();
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableDatosTEMPIPS (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hasErrors INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        Fase TEXT NOT NULL,
        Cavidades TEXT NOT NULL,
        Tcuerpo TEXT NOT NULL,
        Tcuello TEXT NOT NULL
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosTEMPIPS);
    _datostempipsList = maps.map((map) => DatosTEMPIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosTEMPIPS nuevoDato) async {
    final id = await _db.insert(tableDatosTEMPIPS, nuevoDato.toMap());
    _datostempipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosTEMPIPS updatedDato) async {
    final index = _datostempipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      await _db.update(
        tableDatosTEMPIPS,
        updatedDato.copyWith(id: id).toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      _datostempipsList[index] = updatedDato.copyWith(id: id);
      notifyListeners();
    }
  }

  Future<void> removeDatito(BuildContext context, int id) async {
    final index = _datostempipsList.indexWhere((d) => d.id == id);
    if (index != -1) {
      final deletedData = _datostempipsList[index];
      await _db.delete(
        tableDatosTEMPIPS,
        where: 'id = ?',
        whereArgs: [id],
      );
      _datostempipsList.removeAt(index);
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              final newId = await _db.insert(tableDatosTEMPIPS, deletedData.toMap());
              _datostempipsList.insert(index, deletedData.copyWith(id: newId));
              notifyListeners();
            },
          ),
        ),
      );
    }
  }
}


class ScreenListDatosTEMPIPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosTEMPIPSProvider>(context, listen: false);
    return Scaffold(
        body: Column(
          children: [
            Titulospeq(titulo:'REGISTRO DE TEMPERATURA',tipo: 1,),
            Expanded(
              child: Consumer<DatosTEMPIPSProvider>(
              builder: (context, provider, _) {
                final datostempips = provider.datostempipsList;
              
                if (datostempips.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay registros aún.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
              
                return ListView.separated(
                  itemCount: datostempips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final dtdatostempips = datostempips[index];
              
                    return SwipeableTile.card(
                      horizontalPadding: 16,
                      verticalPadding: 10,
                      key: ValueKey(dtdatostempips.id),
                      swipeThreshold: 0.5,
                      resizeDuration: const Duration(milliseconds: 300),
                      color: Colors.white,
                      shadow: const BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      direction: SwipeDirection.endToStart,
                      onSwiped: (_) => provider.removeDatito(context, dtdatostempips.id!),
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
                              builder: (context) => EditDatosTEMPIPSForm(
                                id: dtdatostempips.id!,
                                datosTEMPIPS: dtdatostempips,
                              ),
                            ),
                          );
                        },
                        child: GradientExpandableCard(
                          title: (index + 1).toString(),
                          subtitle: 'Prueba',
                          expandedContent: [
                        ExpandableContent(label: 'Hora: ', stringValue: dtdatostempips.Hora.toString()),
                        ExpandableContent(label: 'Fase: ', stringValue: dtdatostempips.Fase.toString()),
                        ExpandableContent(label: 'Cavidades: ', intListValue: dtdatostempips.Cavidades),
                        ExpandableContent(label: 'Tcuerpo: ', doubleListValue: dtdatostempips.Tcuerpo),
                        ExpandableContent(label: 'Tcuello: ', doubleListValue: dtdatostempips.Tcuello),
                          ],
                          hasErrors: dtdatostempips.hasErrors,
                          onOpenModal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDatosTEMPIPSForm(
                                  id: dtdatostempips.id!,
                                  datosTEMPIPS: dtdatostempips,
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
            ),
          ],
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
            DatosTEMPIPS(
            hasErrors: true,
              Hora: DateFormat('HH:mm').format(DateTime.now()),
              Fase: '',
              Cavidades: [0,0,0,0],
              Tcuerpo: [0,0,0,0],
              Tcuello: [0,0,0,0],
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


    class EditProviderDatosTEMPIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosTEMPIPSForm extends StatefulWidget {
  final int id;
  final DatosTEMPIPS datosTEMPIPS;

  const EditDatosTEMPIPSForm({required this.id, required this.datosTEMPIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosTEMPIPSFormState createState() => _EditDatosTEMPIPSFormState();
}

class _EditDatosTEMPIPSFormState extends State<EditDatosTEMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosTEMPIPS = {
    'fase': ['Fase 1', 'Fase 2', 'Fase 3'],
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
      create: (_) => EditProviderDatosTEMPIPS(),
      child: Consumer<EditProviderDatosTEMPIPS>(
        builder: (context, provider, child) {
          return Scaffold(
          body: Column(
              children:[
               Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FormularioGeneralDatosTEMPIPS(
              formKey: _formKey,
              widget: widget,
              dropOptions: dropOptionsDatosTEMPIPS,
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

                final Cavidades = List.generate(
                  widget.datosTEMPIPS.Cavidades.length,
                  (index) => int.tryParse(values['Cavidades_$index'] ?? '0') ?? 0,
                );
                final Tcuerpo = List.generate(
                  widget.datosTEMPIPS.Tcuerpo.length,
                  (index) => double.tryParse(values['Tcuerpo_$index'] ?? '0') ?? 0,
                );
                final Tcuello = List.generate(
                  widget.datosTEMPIPS.Tcuello.length,
                  (index) => double.tryParse(values['Tcuello_$index'] ?? '0') ?? 0,
                );

                final updatedDatito = widget.datosTEMPIPS.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  Hora: values['Hora'] ?? widget.datosTEMPIPS.Hora,
                  Fase: values['Fase'] ?? widget.datosTEMPIPS.Fase,
                  Cavidades: Cavidades,
                  Tcuerpo: Tcuerpo,
                  Tcuello: Tcuello

                );

                Provider.of<DatosTEMPIPSProvider>(context, listen: false)
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

class FormularioGeneralDatosTEMPIPS extends StatelessWidget {
  const FormularioGeneralDatosTEMPIPS({
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
            initialValue: widget.datosTEMPIPS.Hora,
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
            name: 'Fase',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Fase'];
            field?.validate(); // Valida solo este campo
            field?.save();
            },
            initialValue: widget.datosTEMPIPS.Fase,
            decoration: InputDecoration(labelText: 'Fase',
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
            items: dropOptions['fase']!
                .map((option) => DropdownMenuItem<String>(
                      value: option as String,
                      child: Text(option.toString()),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(errorText: 'Seleccione una opción'),
          ),
          const SizedBox(height: 15,),
            const Titulospeq(titulo: 'Cavidades',tipo: 0,),
            const SizedBox(height: 15,),
          GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0, // Espacio horizontal entre columnas
                mainAxisSpacing: 15.0, // Espacio vertical entre filas
                childAspectRatio: 2.5, // Relación ancho/alto de los elementos
              ),
              itemCount: widget.datosTEMPIPS.Cavidades.length,
              itemBuilder: (context, index) {
                return FormBuilderTextField(
                  name: 'Cavidades_$index',
                  initialValue: widget.datosTEMPIPS.Cavidades[index].toString(),
                  onChanged: (value) {
                    final field = _formKey.currentState?.fields['Cavidades_$index'];
                    field?.validate(); // Valida solo este campo
                    field?.save();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Cavidades ${(index + 1).toString()}',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 20, 100, 96),
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Color de fondo de los campos
                    errorStyle: const TextStyle(
                      fontSize: 13,
                      height: 1, // Altura de línea
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 29, 57, 80),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: Builder(
                      builder: (context) {
                        final isValid =
                            _formKey.currentState?.fields['Cavidades_$index']?.isValid ??
                                false;
                        return Icon(
                          isValid ? Icons.check_circle : Icons.error,
                          color: isValid ? Colors.green : Colors.red,
                        );
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'El campo no puede estar vacío'),
                    FormBuilderValidators.integer(errorText: 'Debe ser un número entero'),
                    FormBuilderValidators.min(0, errorText: 'Debe ser mayor o igual a 0'),
                    FormBuilderValidators.max(100, errorText: 'Debe ser menor o igual a 100'),
                  ]),
                );
              },
              shrinkWrap: true,              
            ),    
            const SizedBox(height: 15,),
            const Titulospeq(titulo: 'Temperatura del cuerpo',tipo: 0,),
            const SizedBox(height: 15,),

          GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 10.0, 
                mainAxisSpacing: 15.0, 
                childAspectRatio: 2.5, 
              ),
              itemCount: widget.datosTEMPIPS.Tcuerpo.length,
              itemBuilder: (context, index) {
                return FormBuilderTextField(
                  name: 'Tcuerpo_$index',
                  initialValue: widget.datosTEMPIPS.Tcuerpo[index].toString(),
                  onChanged: (value) {
                    final field = _formKey.currentState?.fields['Tcuerpo_$index'];
                    field?.validate(); // Valida solo este campo
                    field?.save();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Tcuerpo ${(index + 1).toString()}',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 20, 100, 96),
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Color de fondo de los campos
                    errorStyle: const TextStyle(
                      fontSize: 13,
                      height: 1, // Altura de línea
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 29, 57, 80),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: Builder(
                      builder: (context) {
                        final isValid =
                            _formKey.currentState?.fields['Tcuerpo_$index']?.isValid ??
                                false;
                        return Icon(
                          isValid ? Icons.check_circle : Icons.error,
                          color: isValid ? Colors.green : Colors.red,
                        );
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'El campo no puede estar vacío'),
                    FormBuilderValidators.integer(errorText: 'Debe ser un número entero'),
                    FormBuilderValidators.min(0, errorText: 'Debe ser mayor o igual a 0'),
                    FormBuilderValidators.max(100, errorText: 'Debe ser menor o igual a 100'),
                  ]),
                );
              },
              shrinkWrap: true,              
            ),
            const SizedBox(height: 15,),
            const Titulospeq(titulo: 'Temperatura del cuello',tipo: 0,),
            const SizedBox(height: 15,),
          GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas
                crossAxisSpacing: 10.0, // Espacio horizontal entre columnas
                mainAxisSpacing: 15.0, // Espacio vertical entre filas
                childAspectRatio: 2.5, // Relación ancho/alto de los elementos
              ),
              itemCount: widget.datosTEMPIPS.Tcuello.length,
              itemBuilder: (context, index) {
                return FormBuilderTextField(
                  name: 'Tcuello_$index',
                  initialValue: widget.datosTEMPIPS.Tcuello[index].toString(),
                  onChanged: (value) {
                    final field = _formKey.currentState?.fields['Tcuello_$index'];
                    field?.validate(); // Valida solo este campo
                    field?.save();
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Tcuello ${(index + 1).toString()}',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 20, 100, 96),
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Color de fondo de los campos
                    errorStyle: const TextStyle(
                      fontSize: 13,
                      height: 1, // Altura de línea
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 29, 57, 80),
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: Builder(
                      builder: (context) {
                        final isValid =
                            _formKey.currentState?.fields['Tcuello_$index']?.isValid ??
                                false;
                        return Icon(
                          isValid ? Icons.check_circle : Icons.error,
                          color: isValid ? Colors.green : Colors.red,
                        );
                      },
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'El campo no puede estar vacío'),
                    FormBuilderValidators.integer(errorText: 'Debe ser un número entero'),
                    FormBuilderValidators.min(0, errorText: 'Debe ser mayor o igual a 0'),
                    FormBuilderValidators.max(100, errorText: 'Debe ser menor o igual a 100'),
                  ]),
                );
              },
              shrinkWrap: true,              
            ),    ]
          )
          );
  }
}