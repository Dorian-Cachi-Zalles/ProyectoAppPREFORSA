import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DatosForm extends StatefulWidget {
  @override
  State<DatosForm> createState() => _DatosFormState();
}

class _DatosFormState extends State<DatosForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Datos'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [

            FormBuilderTextField(
              name: 'age',
              decoration: InputDecoration(labelText: 'Age'),
            ),
        
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(labelText: 'Name'),
            ),
        
            FormBuilderCheckbox(
              name: 'isActive',
              title: Text('isActive'),
              decoration: InputDecoration(labelText: 'Isactive'),
            ),
        
          ],
        ),
      ),
    );
  }
}
