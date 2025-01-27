import 'package:flutter/material.dart';



class BotonAgregar<T> extends StatelessWidget {
  final T provider;
  final dynamic datos;

  const BotonAgregar({
    super.key,
    required this.provider,
    required this.datos,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 53,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 187, 206, 243),
                const Color.fromARGB(255, 117, 165, 247),
              ],
            ),
            borderRadius: BorderRadius.circular(8), // Ajusta según lo necesites
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
            ),
            onPressed: () {
              
              // Verificar si el método existe y no es nulo antes de llamarlo
              if (provider != null && (provider as dynamic).addDatito != null) {
                (provider as dynamic).addDatito(datos);
              } else {
                debugPrint(
                    "El provider no es válido o no tiene el método 'addDatito'.");
              }
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
        ),
      ),
    );
  }
}
