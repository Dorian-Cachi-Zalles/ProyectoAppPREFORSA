import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'custom_form_builder_text_field.dart';
import 'custom_form_builder_dropdown.dart';

class DatosDorianForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario DatosDorian'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomFormBuilderTextField(
                name: 'edad',
                label: 'Edad',
                prefixIcon: Icons.person, // Este ícono es solo un ejemplo
              ),
        
              CustomFormBuilderTextField(
                name: 'nombre',
                label: 'Nombre',
                prefixIcon: Icons.person, // Este ícono es solo un ejemplo
              ),
        
              FormBuilderCheckbox(
                name: 'isActive',
                label: 'Isactive',
                prefixIcon: Icons.person, // Este ícono es solo un ejemplo
              ),
        
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    print(_formKey.currentState!.value);
                  } else {
                    print('Formulario no válido');
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
