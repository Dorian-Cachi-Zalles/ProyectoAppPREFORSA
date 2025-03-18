import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/formulario_principal.dart';
import 'package:proyecto/src/services/database_formdatos.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_ctrl_pesos.dart';
import 'package:proyecto/src/widgets/custom_dropdown.dart';
import 'package:proyecto/src/widgets/custom_text_field.dart';

class ScreenDatos extends StatefulWidget {
  const ScreenDatos({super.key});

  @override
  createState() => _ScreenDatosState();
}

class _ScreenDatosState extends State<ScreenDatos> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _autoLoadForm();
  }

  // Guardar automáticamente valores del formulario en SQLite
  void autoSaveForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic> formData = _formKey.currentState!.value;

      // Guardar los datos en SQLite
      await DatabaseHelper.instance.insertData(formData);

      print('Datos guardados automáticamente: $formData');
    } else {
      print('Formulario no válido para guardar automáticamente.');
    }
  }

  // Cargar valores al formulario desde SQLite
  void loadForm() async {
    Map<String, dynamic>? savedData = await DatabaseHelper.instance.getData();

    if (savedData != null) {
      _formKey.currentState?.patchValue(savedData);
      print('Datos cargados: $savedData');
    } else {
      print('No hay datos guardados.');
    }
  }

  // Cargar automáticamente los datos al iniciar
  void _autoLoadForm() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadForm());
  }

  String pesoPromedio = '0'; // Variable para almacenar el valor de peso
// Para evitar múltiples navegaciones simultáneas
  @override
  Widget build(BuildContext context) {
    ThemeData;
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Permite el ajuste al aparecer el teclado

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          onChanged: autoSaveForm, // Auto guardar en cada cambio
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  Text('Datos Principales',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 16, // Espaciado entre el texto y el Divider
                  ),
                  Expanded(
                    child:
                        Divider(), // Se expande para llenar el espacio disponible
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                children: [
                  Expanded(
                      child: CustomFormBuilderDropdown<String>(
                    name: 'modalidad',
                    label: 'Modalidad',
                    items: [
                      DropdownMenuItem(
                        value: 'Normal',
                        child: Text('Normal'),
                      ),
                      DropdownMenuItem(value: 'Prueba', child: Text('Prueba')),
                    ],
                  )),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: CustomFormBuilderDropdown(
                          name: 'maquinista',
                          label: 'Maquinista',
                          items: [
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                            value: 'Prueba', child: Text('Prueba')),
                      ])),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'parte',
                      label: 'Parte',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: CustomFormBuilderDropdown(
                          name: 'producto',
                          label: 'Producto',
                          items: [
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                            value: 'Prueba', child: Text('Prueba')),
                      ])),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                      child: CustomFormBuilderDropdown(
                          name: 'gramaje',
                          label: 'Gramaje',
                          items: [
                        DropdownMenuItem(
                          value: 'Normal',
                          child: Text('Normal'),
                        ),
                        DropdownMenuItem(
                            value: 'Prueba', child: Text('Prueba')),
                      ])),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: CustomFormBuilderDropdown(
                          name: 'cavidades',
                          label: 'Cavidades',
                          items: [
                        DropdownMenuItem(
                          value: '1',
                          child: Text('1'),
                        ),
                        DropdownMenuItem(value: '2', child: Text('2')),
                        DropdownMenuItem(
                          value: '3',
                          child: Text('3'),
                        ),
                        DropdownMenuItem(value: '4', child: Text('4')),
                      ])),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'ciclo_promedio',
                      label: 'Ciclo Promedio',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomFormBuilderTextField(
                        name: 'peso_promedio', label: 'Peso Promedio'),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                        name: 'pa_inicial', label: 'PA Inicial'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomFormBuilderTextField(
                        name: 'cantidad', label: 'Cantidad'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'peso_prom_en_cont_neto',
                      label: 'Peso Promedio en cont NETO',
                      onChanged: (value) {
  final field = _formKey.currentState?.fields['PesoNeto'];
  field?.validate(); // Valida solo este campo
  field?.save();

  // Actualiza el valor en el Provider
  double? newValue = double.tryParse(value ?? '');
  if (newValue != null) {
    context.read<EditProviderDatosPESOSIPS>().pesoNeto = newValue;
  }
},    
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'total_cajas_controladas',
                      label: 'Total Cajas Controladas',
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                        name: 'saldos', label: 'Saldos'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'cant_total_kg',
                      label: 'Cant total Kg.',
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                        name: 'total_cajas_producidas',
                        label: 'Total cajas producidas'),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'cant_total_piezas',
                      label: 'Cantidad total piezas',
                    ),
                  ),
                ],
              ),
              const CustomFormBuilderTextField(
                  name: 'cant_prod_retenido',
                  label: 'Cantidad de producto retenido'),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
