import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/views/formularios/preformas%20ips/defectosips.dart';
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/titulospeq.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class DatosDEFIPS {
  final int? id;
  final bool hasErrors;
  final String Hora;
  final List<String> Defectos;
  final List<String> Criticidad;
  final String SeccionDefecto;
  final int DefectosEncontrados;
  final String Fase;
  final bool Palet;
  final bool Empaque;
  final bool Embalado;
  final bool Etiquetado;
  final bool Inocuidad;
  final double CantidadProductoRetenido;
  final double CanidadProductoCorregido;
  final String?Observaciones;

  // Constructor de la clase
  const DatosDEFIPS(
      {this.id,
      required this.hasErrors,
      required this.Hora,
      required this.Defectos,
      required this.Criticidad,
      required this.SeccionDefecto,
      required this.DefectosEncontrados,
      required this.Fase,
      required this.Palet,
      required this.Empaque,
      required this.Embalado,
      required this.Etiquetado,
      required this.Inocuidad,
      required this.CantidadProductoRetenido,
      required this.CanidadProductoCorregido,
      this.Observaciones});

       // Factory para crear una instancia desde un Map
  factory DatosDEFIPS.fromMap(Map<String, dynamic> map) {
    return DatosDEFIPS(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        Hora: map['Hora'] as String,        
        Defectos: (map['Defectos'] as String?)?.split(',').where((item) => item.isNotEmpty).toList() ?? [],
        Criticidad: (map['Criticidad'] as String?)?.split(',').where((item) => item.isNotEmpty).toList() ?? [],
        SeccionDefecto: map['SeccionDefecto'] as String,
        DefectosEncontrados: map['DefectosEncontrados'] as int,
        Fase: map['Fase'] as String,
        Palet: (map['Palet'] as int) == 1,
        Empaque: (map['Empaque'] as int) == 1,
        Embalado: (map['Embalado'] as int) == 1,
        Etiquetado: (map['Etiquetado'] as int) == 1,
        Inocuidad: (map['Inocuidad'] as int) == 1,
        CantidadProductoRetenido: map['CantidadProductoRetenido'] as double,
        CanidadProductoCorregido: map['CanidadProductoCorregido'] as double,
        Observaciones: map['Observaciones'] as String?);
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'Hora': Hora,
      'Defectos': Defectos.join(','),
      'Criticidad': Criticidad.join(','),
      'SeccionDefecto': SeccionDefecto,
      'DefectosEncontrados': DefectosEncontrados,
      'Fase': Fase,
      'Palet': Palet ? 1 : 0,
      'Empaque': Empaque ? 1 : 0,
      'Embalado': Embalado ? 1 : 0,
      'Etiquetado': Etiquetado ? 1 : 0,
      'Inocuidad': Inocuidad ? 1 : 0,
      'CantidadProductoRetenido': CantidadProductoRetenido,
      'CanidadProductoCorregido': CanidadProductoCorregido,
      'Observaciones': Observaciones
    };
  }

  // Método copyWith
  DatosDEFIPS copyWith(
      {int? id,
      bool? hasErrors,
      String? Hora,
      List<String>?Defectos,
      List<String>?Criticidad,
      String? SeccionDefecto,
      int? DefectosEncontrados,
      String? Fase,
      bool? Palet,
      bool? Empaque,
      bool? Embalado,
      bool? Etiquetado,
      bool? Inocuidad,
      double? CantidadProductoRetenido,
      double? CanidadProductoCorregido,
      String? Observaciones}) {
    return DatosDEFIPS(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        Hora: Hora ?? this.Hora,
        Defectos: Defectos ?? this.Defectos,
        Criticidad: Criticidad?? this.Criticidad,
        SeccionDefecto: SeccionDefecto ?? this.SeccionDefecto,
        DefectosEncontrados: DefectosEncontrados ?? this.DefectosEncontrados,
        Fase: Fase ?? this.Fase,
        Palet: Palet ?? this.Palet,
        Empaque: Empaque ?? this.Empaque,
        Embalado: Embalado ?? this.Embalado,
        Etiquetado: Etiquetado ?? this.Etiquetado,
        Inocuidad: Inocuidad ?? this.Inocuidad,
        CantidadProductoRetenido:
            CantidadProductoRetenido ?? this.CantidadProductoRetenido,
        CanidadProductoCorregido:
            CanidadProductoCorregido ?? this.CanidadProductoCorregido,
        Observaciones: Observaciones ?? this.Observaciones);
  }
}

class DatosDEFIPSProvider with ChangeNotifier {
  late Database _db;
  final String tableDatosDEFIPS = 'datosDEFIPS';
  List<DatosDEFIPS> _datosdefipsList = [];

  List<DatosDEFIPS> get datosdefipsList => List.unmodifiable(_datosdefipsList);

  DatosDEFIPSProvider() {
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
        hasErrors INTEGER NOT NULL,
        Hora TEXT NOT NULL,
        Defectos TEXT NOT NULL,
        Criticidad TEXT NOT NULL,
        SeccionDefecto TEXT NOT NULL,
        DefectosEncontrados INTEGER NOT NULL,
        Fase TEXT NOT NULL,
        Palet INTEGER NOT NULL,
        Empaque INTEGER NOT NULL,
        Embalado INTEGER NOT NULL,
        Etiquetado INTEGER NOT NULL,
        Inocuidad INTEGER NOT NULL,
        CantidadProductoRetenido REAL NOT NULL,
        CanidadProductoCorregido REAL NOT NULL,
        Observaciones TEXT
      )
    ''');
  }

  Future<void> _loadData() async {
    final maps = await _db.query(tableDatosDEFIPS);
    _datosdefipsList = maps.map((map) => DatosDEFIPS.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addDatito(DatosDEFIPS nuevoDato) async {
    final id = await _db.insert(tableDatosDEFIPS, nuevoDato.toMap());
    _datosdefipsList.add(nuevoDato.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateDatito(int id, DatosDEFIPS updatedDato) async {
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

class ScreenListDatosDEFIPS extends StatelessWidget {
  const ScreenListDatosDEFIPS({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosDEFIPSProvider>(context, listen: false);
    return Scaffold(
        body: Column(
          children: [
            const Titulospeq(titulo: 'REGISTRO DE DEFECTOS',tipo: 1,),
            Expanded(
              child: Consumer<DatosDEFIPSProvider>(
                builder: (context, provider, _) {
                  final datosdefips = provider.datosdefipsList;
              
                  if (datosdefips.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay registros aún.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
              
                  return ListView.separated(
                    itemCount: datosdefips.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final dtdatosdefips = datosdefips[index];
              
                      return SwipeableTile.card(
                        horizontalPadding: 16,
                        verticalPadding: 10,
                        key: ValueKey(dtdatosdefips.id),
                        swipeThreshold: 0.5,
                        resizeDuration: const Duration(milliseconds: 300),
                        color: Colors.white,
                        shadow: const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                        direction: SwipeDirection.endToStart,
                        onSwiped: (_) =>
                            provider.removeDatito(context, dtdatosdefips.id!),
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
                                builder: (context) => EditDatosDEFIPSForm(
                                  id: dtdatosdefips.id!,
                                  datosDEFIPS: dtdatosdefips,
                                ),
                              ),
                            );
                          },
                          child: GradientExpandableCard(
                            title: (index + 1).toString(),
                            title2: 'Defectos - Criticidad',
                            subtitle: List.generate(dtdatosdefips.Defectos.length, (index) {
    return '${dtdatosdefips.Defectos[index]}';}).join(", ") + List.generate(dtdatosdefips.Defectos.length, (index) {
    return '${dtdatosdefips.Defectos[index]}';}).join(", "),
                            expandedContent: [
                              ExpandableContent(
                                  label: 'Hora: ',
                                  stringValue: dtdatosdefips.Hora.toString()),
                              ExpandableContent(
                                  label: 'SeccionDefecto: ',
                                  stringValue:
                                      dtdatosdefips.SeccionDefecto.toString()),
                              ExpandableContent(
                                  label: 'DefectosEncontrados: ',
                                  stringValue:
                                      dtdatosdefips.DefectosEncontrados.toString()),
                              ExpandableContent(
                                  label: 'Fase: ',
                                  stringValue: dtdatosdefips.Fase.toString()),
                              ExpandableContent(
                                  label: 'Palet: ', boolValue: dtdatosdefips.Palet),
                              ExpandableContent(
                                  label: 'Empaque: ',
                                  boolValue: dtdatosdefips.Empaque),
                              ExpandableContent(
                                  label: 'Embalado: ',
                                  boolValue: dtdatosdefips.Embalado),
                              ExpandableContent(
                                  label: 'Etiquetado: ',
                                  boolValue: dtdatosdefips.Etiquetado),
                              ExpandableContent(
                                  label: 'Inocuidad: ',
                                  boolValue: dtdatosdefips.Inocuidad),
                              ExpandableContent(
                                  label: 'CantidadProductoRetenido: ',
                                  stringValue: dtdatosdefips.CantidadProductoRetenido
                                      .toString()),
                              ExpandableContent(
                                  label: 'CanidadProductoCorregido: ',
                                  stringValue: dtdatosdefips.CanidadProductoCorregido
                                      .toString()),
                              ExpandableContent(
                                  label: 'Observaciones: ',
                                  stringValue:
                                      dtdatosdefips.Observaciones.toString()),
                            ],
                            hasErrors: dtdatosdefips.hasErrors,
                            onOpenModal: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDatosDEFIPSForm(
                                    id: dtdatosdefips.id!,
                                    datosDEFIPS: dtdatosdefips,
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                ),
                onPressed: () {
                  provider.addDatito(
                    DatosDEFIPS(
                      hasErrors: true,
                      Hora: DateFormat('HH:mm').format(DateTime.now()),
                      Defectos:[],
                      Criticidad: [],
                      SeccionDefecto: '',
                      DefectosEncontrados: 0,
                      Fase: '',
                      Palet: true,
                      Empaque: true,
                      Embalado: true,
                      Etiquetado: true,
                      Inocuidad: true,
                      CantidadProductoRetenido: 0,
                      CanidadProductoCorregido: 0,
                      Observaciones: '',
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

class EditProviderDatosDEFIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosDEFIPSForm extends StatefulWidget {
  final int id;
  final DatosDEFIPS datosDEFIPS;

  const EditDatosDEFIPSForm(
      {required this.id, required this.datosDEFIPS, super.key});

  @override
  _EditDatosDEFIPSFormState createState() => _EditDatosDEFIPSFormState();
}

class _EditDatosDEFIPSFormState extends State<EditDatosDEFIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosDEFIPS = {
    'Secciones': ['Al inicio', 'Medio', 'Final'],
    'Ffase': ['Fase 1', 'Fase 2', 'Fase 3'],
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
      create: (_) => EditProviderDatosDEFIPS(),
      child: Consumer<EditProviderDatosDEFIPS>(
        builder: (context, provider, child) {
          return Scaffold(
              body: Column(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: FormularioGeneralDatosDEFIPS(
                    formKey: _formKey,
                    widget: widget,
                    dropOptions: dropOptionsDatosDEFIPS,
                    id: widget.id,
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context)
                      .viewInsets
                      .bottom, // Ajuste para teclado
                ),
                child: SizedBox(
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                    ),
                    onPressed: () {
                      _formKey.currentState?.save();
                      final values = _formKey.currentState!.value;                      
                      final updatedDatito = widget.datosDEFIPS.copyWith(
                        hasErrors: _formKey.currentState?.fields.values
                                .any((field) => field.hasError) ??
                            false,
                        Hora: values['Hora'] ?? widget.datosDEFIPS.Hora,                       
                        SeccionDefecto: values['SeccionDefecto'] ??
                            widget.datosDEFIPS.SeccionDefecto,
                        DefectosEncontrados:
                            (values['DefectosEncontrados']?.isEmpty ?? true)
                                ? 0
                                : int.tryParse(values['DefectosEncontrados']),
                        Fase: values['Fase'] ?? widget.datosDEFIPS.Fase,
                        Palet: values['Palet'] ?? widget.datosDEFIPS.Palet,
                        Empaque:
                            values['Empaque'] ?? widget.datosDEFIPS.Empaque,
                        Embalado:
                            values['Embalado'] ?? widget.datosDEFIPS.Embalado,
                        Etiquetado: values['Etiquetado'] ??
                            widget.datosDEFIPS.Etiquetado,
                        Inocuidad:
                            values['Inocuidad'] ?? widget.datosDEFIPS.Inocuidad,
                        CantidadProductoRetenido:
                            (values['CantidadProductoRetenido']?.isEmpty ??
                                    true)
                                ? 0
                                : double.tryParse(
                                    values['CantidadProductoRetenido']),
                        CanidadProductoCorregido:
                            (values['CanidadProductoCorregido']?.isEmpty ??
                                    true)
                                ? 0
                                : double.tryParse(
                                    values['CanidadProductoCorregido']),
                        Observaciones: values['Observaciones'] ??
                            widget.datosDEFIPS.Observaciones,
                      );

                      Provider.of<DatosDEFIPSProvider>(context, listen: false)
                          .updateDatito(widget.id, updatedDatito);

                      Navigator.pop(context);
                    },
                  ),
                ))
          ])
          );
        },
      ),
    );
  }
}

class FormularioGeneralDatosDEFIPS extends StatelessWidget {
  const FormularioGeneralDatosDEFIPS({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions, required this.id,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final widget;
  final Map<String, List<dynamic>> dropOptions;
  final int id;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        key: _formKey,
        child: Column(children: [          
          DefectosScreenWidget(id: id,),
          
            FormBuilderTextField(
            name: 'Hora',
            initialValue: widget.datosDEFIPS.Hora,
            onChanged: (value) {
              final field = _formKey.currentState?.fields['Hora'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            decoration: InputDecoration(
              labelText: 'Hora',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: const TextStyle(
                fontSize: 13, // Tamaño de fuente del mensaje de error
                height: 1, // Altura de línea (mayor para permitir dos líneas)
                color: Colors
                    .red, // Color del mensaje de error (puedes personalizarlo)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid =
                      _formKey.currentState?.fields['Hora']?.isValid ?? false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(
                errorText: 'El campo no puede estar vacío'),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderDropdown<String>(
            name: 'SeccionDefecto',
            onChanged: (value) {
              final field = _formKey.currentState?.fields['SeccionDefecto'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            initialValue: widget.datosDEFIPS.SeccionDefecto,
            decoration: InputDecoration(
              labelText: 'Seccion Donde Se Encontro El Defecto',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
            ),
            items: dropOptions['Secciones']!
                .map((option) => DropdownMenuItem<String>(
                      value: option as String,
                      child: Text(option.toString()),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(
                errorText: 'Seleccione una opción'),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'DefectosEncontrados',
            initialValue: widget.datosDEFIPS.DefectosEncontrados.toString(),
            onChanged: (value) {
              final field =
                  _formKey.currentState?.fields['DefectosEncontrados'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            decoration: InputDecoration(
              labelText: 'Defectos Encontrados',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: const TextStyle(
                fontSize: 13, // Tamaño de fuente del mensaje de error
                height: 1, // Altura de línea (mayor para permitir dos líneas)
                color: Colors
                    .red, // Color del mensaje de error (puedes personalizarlo)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState
                          ?.fields['DefectosEncontrados']?.isValid ??
                      false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(
                errorText: 'El campo no puede estar vacío'),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderDropdown<String>(
            name: 'Fase',
            onChanged: (value) {
              final field = _formKey.currentState?.fields['Fase'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            initialValue: widget.datosDEFIPS.Fase,
            decoration: InputDecoration(
              labelText: 'Fase',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
            ),
            items: dropOptions['Ffase']!
                .map((option) => DropdownMenuItem<String>(
                      value: option as String,
                      child: Text(option.toString()),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(
                errorText: 'Seleccione una opción'),
          ), 
          const SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      for (var item in [
        {'label': 'Palet', 'name': 'Palet', 'value': widget.datosDEFIPS.Palet},
        {'label': 'Empaque', 'name': 'Empaque', 'value': widget.datosDEFIPS.Empaque},
        {'label': 'Embalado', 'name': 'Embalado', 'value': widget.datosDEFIPS.Embalado},
        {'label': 'Etiquetado', 'name': 'Etiquetado', 'value': widget.datosDEFIPS.Etiquetado},
        {'label': 'Inocuidad', 'name': 'Inocuidad', 'value': widget.datosDEFIPS.Inocuidad},
      ])
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 150,
            height: 60,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                color: const Color.fromARGB(255, 29, 57, 80),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FormBuilderCheckbox(
              name: item['name']!,
              initialValue: item['value']!,
              onChanged: (value) {
                final field = _formKey.currentState?.fields[item['name']];
                field?.validate(); // Valida solo este campo
                field?.save();
              },
              title: Text(
              item['label']!,              
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 20, 100, 96),
                fontWeight: FontWeight.bold,
              ),
            ), // Espacio vacío para evitar errores
            ),
          ),
        ),
    ],
  ),
),

          const SizedBox(
            height: 20,
          ),
          FormBuilderTextField(
            name: 'CantidadProductoRetenido',
            initialValue:
                widget.datosDEFIPS.CantidadProductoRetenido.toString(),
            onChanged: (value) {
              final field =
                  _formKey.currentState?.fields['CantidadProductoRetenido'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            decoration: InputDecoration(
              labelText: 'Cantidad de Producto Retenido',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: const TextStyle(
                fontSize: 13, // Tamaño de fuente del mensaje de error
                height: 1, // Altura de línea (mayor para permitir dos líneas)
                color: Colors
                    .red, // Color del mensaje de error (puedes personalizarlo)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState
                          ?.fields['CantidadProductoRetenido']?.isValid ??
                      false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(
                errorText: 'El campo no puede estar vacío'),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'CanidadProductoCorregido',
            initialValue:
                widget.datosDEFIPS.CanidadProductoCorregido.toString(),
            onChanged: (value) {
              final field =
                  _formKey.currentState?.fields['CanidadProductoCorregido'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            decoration: InputDecoration(
              labelText: 'Canidad de Producto Corregido',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: const TextStyle(
                fontSize: 13, // Tamaño de fuente del mensaje de error
                height: 1, // Altura de línea (mayor para permitir dos líneas)
                color: Colors
                    .red, // Color del mensaje de error (puedes personalizarlo)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),
              suffixIcon: Builder(
                builder: (context) {
                  final isValid = _formKey.currentState
                          ?.fields['CanidadProductoCorregido']?.isValid ??
                      false;
                  return Icon(
                    isValid ? Icons.check_circle : Icons.error,
                    color: isValid ? Colors.green : Colors.red,
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            validator: FormBuilderValidators.required(
                errorText: 'El campo no puede estar vacío'),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'Observaciones',
            initialValue: widget.datosDEFIPS.Observaciones,
            onChanged: (value) {
              final field = _formKey.currentState?.fields['Observaciones'];
              field?.validate(); // Valida solo este campo
              field?.save();
            },
            decoration: InputDecoration(
              labelText: 'Observaciones',
              labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 20, 100, 96),
                  fontWeight: FontWeight.bold),
              filled: true,
              fillColor: Colors.grey[200], // Color de fondo de los campos
              errorStyle: const TextStyle(
                fontSize: 13, // Tamaño de fuente del mensaje de error
                height: 1, // Altura de línea (mayor para permitir dos líneas)
                color: Colors
                    .red, // Color del mensaje de error (puedes personalizarlo)
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 29, 57, 80), width: 1.5),
              ),              
            ),
            keyboardType: TextInputType.text,            
          ),
        ]));
  }
}
