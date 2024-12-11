import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomFormBuilderDropdown<T> extends StatelessWidget {
  final String name;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final IconData? prefixIcon;
  final T? initialValue;
  final String? hintText;
  final bool readOnly;

  const CustomFormBuilderDropdown({
    super.key,
    required this.name,
    required this.label,
    required this.items,
    this.prefixIcon,
    this.initialValue,
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
              color: Colors.grey.withOpacity(0.2), // Sombra suave
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: FormBuilderDropdown<T>(
          name: name,
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
                color: Theme.of(context).primaryColor,
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
          items: items,
        ),
      ),
    );
  }
}
