import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenDatos extends StatelessWidget {
  ScreenDatos({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  // Guardar valores del formulario en SharedPreferences
  void saveForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic> formData = _formKey.currentState!.value;

      // Guardar los datos en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      formData.forEach((key, value) {
        if (value is String) prefs.setString(key, value);
        if (value is int) prefs.setInt(key, value);
      });

      print('Datos guardados: $formData');
    } else {
      print('Formulario no válido');
    }
  }

  // Cargar valores al formulario desde SharedPreferences
  void loadForm() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> savedData = {
      'nombre': prefs.getString('nombre') ?? '',
      'email': prefs.getString('email') ?? '',
      'edad': prefs.getInt('edad') ?? 0,
    };

    _formKey.currentState?.patchValue(savedData);
    print('Datos cargados: $savedData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Permite el ajuste al aparecer el teclado
      appBar: AppBar(
        title: const Text('Formulario de Datos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'nombre',
                decoration: const InputDecoration(labelText: 'Nombre'),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'edad',
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: saveForm,
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: loadForm,
                    child: const Text('Cargar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
