import 'package:flutter/material.dart';

class Titulos extends StatelessWidget {
  final String titulo;
  final int tipo;
  final Future<void> Function()? eliminar; // Cambiamos a este tipo para aceptar funciones que devuelvan Future<void>.

  const Titulos({
    super.key,
    required this.titulo,
    required this.tipo,
    this.eliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.black, // Color del texto
              fontSize: 18.0, // Tamaño de fuente
              fontWeight: FontWeight.w700, // Grosor de la fuente
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          tipo == 1
              ? GestureDetector(
                  onTap: eliminar != null
                      ? () async {
                          await eliminar!(); // Llamada asíncrona envuelta en un VoidCallback
                        }
                      : null,
                  child: Text(
                    'Borrar Todo',
                    style: const TextStyle(
                      color: Colors.red, // Color del texto
                      fontSize: 16.0, // Tamaño de fuente
                      fontWeight: FontWeight.w700, // Grosor de la fuente
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 23),
        ],
      ),
    );
  }
}
