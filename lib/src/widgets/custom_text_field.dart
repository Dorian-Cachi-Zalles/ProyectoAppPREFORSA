import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String label;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? prefixIcon;
  final String? hintText;
  final bool readOnly;

  const CustomFormBuilderTextField({
    super.key,
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.prefixIcon,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Sombra
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: FormBuilderTextField(
          name: name,
          readOnly: readOnly,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // Bordes redondeados
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5, // Ancho del borde
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
                color: Theme.of(context)
                    .primaryColor, // Color del borde al enfocarse
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 20.0), // Espaciado interno
          ),
        ),
      ),
    );
  }
}
