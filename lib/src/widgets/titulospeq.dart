import 'package:flutter/material.dart';

class Titulospeq extends StatelessWidget {
  final String titulo;
  final int tipo;

  const Titulospeq({super.key, required this.titulo, required this.tipo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        tipo == 1
            ? Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent, // Cambia el color según tu diseño
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(8)), // Bordes redondeados
                  ),
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontSize: 16.0, // Tamaño de fuente
                      fontWeight: FontWeight.w500, // Grosor de la fuente
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey, // Cambia el color según tu diseño
                        borderRadius:
                            BorderRadius.circular(20.0), // Bordes redondeados
                      ),
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white, // Color del texto
                          fontSize: 16.0, // Tamaño de fuente
                          fontWeight: FontWeight.w500, // Grosor de la fuente
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

