import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextoSimple extends StatelessWidget {
  final String name;
  final String label;
  final String valorInicial;
  final String textoError;
  

  final ValueChanged<String?>? onChanged;

  const TextoSimple({
    Key? key,
    required this.name,
    required this.label,
    required this.valorInicial,
    required this.textoError,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FormBuilderTextField(
          name: name,
          initialValue: valorInicial,
          validator: FormBuilderValidators.required(errorText: textoError),
          keyboardType: TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
             labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 13,
              height: 1,
              color: Colors.red,
            ),
            suffixIcon: Builder(
              builder: (context) {
                final formField = FormBuilder.of(context)?.fields[name];
                final isValid = formField?.isValid ?? false;
                return Icon(
                  isValid ? Icons.check_circle : Icons.error,
                  color: isValid ? Colors.green : Colors.red,
                );
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
