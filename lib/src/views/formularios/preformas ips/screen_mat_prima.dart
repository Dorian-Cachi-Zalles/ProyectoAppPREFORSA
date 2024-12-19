import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:path/path.dart' as p;
import 'package:proyecto/src/widgets/gradient_expandable_card.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swipeable_tile/swipeable_tile.dart';
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
  final String tableDatosMPIPS = 'datosMPIPS';
  List<DatosMPIPS> _datosmpipsList = [];

  List<DatosMPIPS> get datosmpipsList => List.unmodifiable(_datosmpipsList);

  DatosMPIPSProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      p.join(await getDatabasesPath(), 'datosMPIPS.db'),
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
        body: Consumer<DatosMPIPSProvider>(
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

              return Column(
                children: [
                  Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '¿Se tiene una mezcla con colorante y aditivo?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleSwitch(
                          initialLabelIndex: 1,
                          customWidths: const [90.0, 50.0],
                          cornerRadius: 20.0,
                          activeBgColors: const [
                            [Colors.cyan],
                            [Colors.redAccent]
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: const ['SI', ''],
                          icons: const [null, Icons.close],
                          onToggle: (index) {
                            if (index == 0) {
                              _showBottomSheet();
                            }
                          },
                        ),
                      ],
                    ),
                  ],),
                  Expanded(
                    child: SwipeableTile.card(
                      horizontalPadding: 16,
                      verticalPadding: 10,
                      key: ValueKey(dtdatosmpips.id),
                      swipeThreshold: 0.5,
                      resizeDuration: const Duration(milliseconds: 300),
                      color: Colors.white,
                      shadow: const BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                      direction: SwipeDirection.endToStart,
                      onSwiped: (_) => provider.removeDatito(context, dtdatosmpips.id!),
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
                              builder: (context) => EditDatosMPIPSForm(
                                id: dtdatosmpips.id!,
                                datosMPIPS: dtdatosmpips,
                              ),
                            ),
                          );
                        },
                        child: GradientExpandableCard(
                          title: (index + 1).toString(),
                          subtitle: 'Prueba',
                          expandedContent: [
                        ExpandableContent(label: 'MateriPrima: ', stringValue: dtdatosmpips.MateriPrima.toString()),
                        ExpandableContent(label: 'INTF: ', stringValue: dtdatosmpips.INTF.toString()),
                        ExpandableContent(label: 'CantidadEmpaque: ', stringValue: dtdatosmpips.CantidadEmpaque.toString()),
                        ExpandableContent(label: 'Identif: ', stringValue: dtdatosmpips.Identif.toString()),
                        ExpandableContent(label: 'CantidadBolsones: ', stringValue: dtdatosmpips.CantidadBolsones.toString()),
                        ExpandableContent(label: 'Dosificacion: ', stringValue: dtdatosmpips.Dosificacion.toString()),
                        ExpandableContent(label: 'Humedad: ', stringValue: dtdatosmpips.Humedad.toString()),
                        ExpandableContent(label: 'Conformidad: ', boolValue: dtdatosmpips.Conformidad),
                          ],
                          hasErrors: dtdatosmpips.hasErrors,
                          onOpenModal: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDatosMPIPSForm(
                                  id: dtdatosmpips.id!,
                                  datosMPIPS: dtdatosmpips,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
            DatosMPIPS(
            hasErrors: true,
              MateriPrima: '',
              INTF: '',
              CantidadEmpaque: '',
              Identif: '',
              CantidadBolsones: 0,
              Dosificacion: 0,
              Humedad: 0,
              Conformidad: true,
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Cambia la altura según necesites
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Contenedor deslizable',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Este contenedor se muestra y se oculta dependiendo del estado del switch.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar el BottomSheet
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      setState(() {
// Restablecer el estado de visibilidad del contenedor
      });
    });
  }
}

    class EditProviderDatosMPIPS with ChangeNotifier {
  // Implementación del proveedor, puedes agregar lógica específica aquí
}

class EditDatosMPIPSForm extends StatefulWidget {
  final int id;
  final DatosMPIPS datosMPIPS;

  const EditDatosMPIPSForm({required this.id, required this.datosMPIPS, Key? key})
      : super(key: key);

  @override
  _EditDatosMPIPSFormState createState() => _EditDatosMPIPSFormState();
}

class _EditDatosMPIPSFormState extends State<EditDatosMPIPSForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Mapa para las opciones de Dropdowns
  final Map<String, List<dynamic>> dropOptionsDatosMPIPS = {
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

                final updatedDatito = widget.datosMPIPS.copyWith(
                hasErrors:_formKey.currentState?.fields.values.any((field) => field.hasError) ?? false,
                  MateriPrima: values['MateriPrima'] ?? widget.datosMPIPS.MateriPrima,
                  INTF: values['INTF'] ?? widget.datosMPIPS.INTF,
                  CantidadEmpaque: values['CantidadEmpaque'] ?? widget.datosMPIPS.CantidadEmpaque,
                  Identif: values['Identif'] ?? widget.datosMPIPS.Identif,
                  CantidadBolsones:(values['CantidadBolsones']?.isEmpty ?? true)? 0 : int.tryParse(values['CantidadBolsones']),
                  Dosificacion:(values['Dosificacion']?.isEmpty ?? true)? 0 : double.tryParse(values['Dosificacion']),
                  Humedad:(values['Humedad']?.isEmpty ?? true)? 0 : double.tryParse(values['Humedad']),
                  Conformidad: values['Conformidad'] ?? widget.datosMPIPS.Conformidad,

                );

                Provider.of<DatosMPIPSProvider>(context, listen: false)
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

class FormularioGeneralDatosMPIPS extends StatelessWidget {
  const FormularioGeneralDatosMPIPS({
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
          FormBuilderDropdown<String>(
            name: 'MateriPrima',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['MateriPrima'];
            field?.validate(); // Valida solo este campo
            field?.save();
            },
            initialValue: widget.datosMPIPS.MateriPrima,
            decoration: InputDecoration(labelText: 'Materiprima',
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
          FormBuilderTextField(
            name: 'INTF',
            initialValue: widget.datosMPIPS.INTF,
            onChanged: (value) {
            final field = _formKey.currentState?.fields['INTF'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Intf',
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
                  final isValid = _formKey.currentState?.fields['INTF']?.isValid ?? false;
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
            name: 'CantidadEmpaque',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['CantidadEmpaque'];
            field?.validate(); // Valida solo este campo
            field?.save();
            },
            initialValue: widget.datosMPIPS.CantidadEmpaque,
            decoration: InputDecoration(labelText: 'Cantidadempaque',
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
          FormBuilderTextField(
            name: 'Identif',
            initialValue: widget.datosMPIPS.Identif,
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Identif'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Identif',
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
                  final isValid = _formKey.currentState?.fields['Identif']?.isValid ?? false;
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
          FormBuilderDropdown<int>(
            name: 'CantidadBolsones',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['CantidadBolsones'];
            field?.validate(); // Valida solo este campo
            field?.save();
            },
            initialValue: widget.datosMPIPS.CantidadBolsones,
            decoration: InputDecoration(labelText: 'Cantidadbolsones',
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
                .map((option) => DropdownMenuItem<int>(
                      value: option as int,
                      child: Text(option.toString()),
                    ))
                .toList(),
            validator: FormBuilderValidators.required(errorText: 'Seleccione una opción'),
          ),
          const SizedBox(height: 15,),
          FormBuilderTextField(
            name: 'Dosificacion',
            initialValue: widget.datosMPIPS.Dosificacion.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Dosificacion'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Dosificacion',
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
                  final isValid = _formKey.currentState?.fields['Dosificacion']?.isValid ?? false;
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
            name: 'Humedad',
            initialValue: widget.datosMPIPS.Humedad.toString(),
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Humedad'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(labelText: 'Humedad',
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
                  final isValid = _formKey.currentState?.fields['Humedad']?.isValid ?? false;
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
          FormBuilderCheckbox(
            name: 'Conformidad',
            onChanged: (value) {
            final field = _formKey.currentState?.fields['Conformidad'];
            field?.validate(); // Valida solo este campo
            field?.save();
          },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
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
            initialValue: widget.datosMPIPS.Conformidad,
            title: Text('Conformidad'),
          ),

    ]
          )
          );
  }
}