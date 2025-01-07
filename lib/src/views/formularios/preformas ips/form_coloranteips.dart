import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:proyecto/src/services/database_formdatos.dart';
import 'package:proyecto/src/widgets/custom_dropdown.dart';
import 'package:proyecto/src/widgets/custom_text_field.dart';
import 'package:proyecto/src/widgets/titulospeq.dart';

class FormColorante extends StatefulWidget {
  const FormColorante({super.key});

  @override
  createState() => _FormColoranteState();
}

class _FormColoranteState extends State<FormColorante> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _autoLoadForm();
  }

  // Guardar automáticamente valores del formulario en SQLite
  void autoSaveForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic> formDatacoloranteIPS = _formKey.currentState!.value;

      // Guardar los datos en SQLite
      await DatabaseHelper.instance.insertData(formDatacoloranteIPS);

      print('Datos guardados automáticamente: $formDatacoloranteIPS');
    } else {
      print('Formulario no válido para guardar automáticamente.');
    }
  }

  // Cargar valores al formulario desde SQLite
  void loadForm() async {
    Map<String, dynamic>? savedDatacoloranteIPS = await DatabaseHelper.instance.getData();

    if (savedDatacoloranteIPS != null) {
      _formKey.currentState?.patchValue(savedDatacoloranteIPS);
      print('Datos cargados: $savedDatacoloranteIPS');
    } else {
      print('No hay datos guardados.');
    }
  }

  // Cargar automáticamente los datos al iniciar
  void _autoLoadForm() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => loadForm());
  }

   @override
  Widget build(BuildContext context) {
    ThemeData;
    return SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: FormBuilder(
          key: _formKey,
          onChanged: autoSaveForm, // Auto guardar en cada cambio
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Titulospeq(tipo: 1,titulo: 'COLORANTE',),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: CustomFormBuilderDropdown<String>(
                    name: 'Colorante',
                    label: 'Colorante',
                    items: [
                      DropdownMenuItem(
                        value: 'Microbatch azul',
                        child: Text('Microbatch azul'),
                      ),
                      DropdownMenuItem(value: 'Microbatch verde', child: Text('Microbatch verde')),
                    ],
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'Codigo',
                      label: 'Codigo',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'KL',
                      label: 'KL',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'BP',
                      label: 'BP',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomFormBuilderTextField(
                      name: 'Dosificacion',
                      label: 'Dosificacion',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomFormBuilderDropdown(
                          name: 'CantidaddeBolsones',
                          label: 'Cantidad de Bolsones',
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
                        DropdownMenuItem(value: '5', child: Text('5')),
                      ])),                    
                ],
              ),
             
            ],
          ),
        ),
      );
    
  }
}
