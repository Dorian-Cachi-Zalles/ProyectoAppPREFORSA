import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


class CustomInputField extends StatelessWidget {
  final String name;
  final String label;
  final bool isRequired;
  final bool isNumeric;
  final String valorInicial;
  final double? min;
  final double? max;
  final int? maxWords;
  final ValueChanged<String?>? onChanged;

  const CustomInputField({
    Key? key,
    required this.name,
    required this.label,
    required this.valorInicial,
    this.isRequired = true,
    this.isNumeric = true,
    this.min,
    this.max,
    this.maxWords,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onChanged: onChanged,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
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
          suffixIcon: _buildSuffixIcon(),
        ),
        validator: FormBuilderValidators.compose([
          if (isRequired) FormBuilderValidators.required(errorText: 'El campo no puede estar vacío'),
          if (isNumeric) FormBuilderValidators.numeric(errorText: 'Debe ser un número válido'),
          if (isNumeric && min != null && max != null) 
            (value) {
              final numValue = double.tryParse(value ?? '');
              if (numValue == null) return null; // No marcar como error si está vacío
              if (numValue < min! || numValue > max!) {
                return 'Debe estar entre $min y $max';
              }
              return null;
            },
          if (!isNumeric && maxWords != null) 
            FormBuilderValidators.maxWordsCount(maxWords!, errorText: 'Máximo $maxWords palabras'),
        ]),       
      ),
    );
  }

  /// 📌 Método para construir el icono según el estado del campo
  Widget _buildSuffixIcon() {
    return Builder(
      builder: (context) {
        final field = FormBuilder.of(context)?.fields[name];
        final value = field?.value ?? '';
        final numValue = isNumeric ? double.tryParse(value) : null;

        if (isRequired && value.isEmpty) {
          return const Icon(Icons.error, color: Colors.red);
        } else if (isNumeric && numValue == null) {
          return const Icon(Icons.error, color: Colors.red);
        } else if (isNumeric && ((min != null && numValue! < min!) || (max != null && numValue! > max!))) {
          return const Icon(Icons.warning, color: Colors.amber);
        } else {
          return const Icon(Icons.check_circle, color: Colors.green);
        }
      },
    );
  }
}


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
