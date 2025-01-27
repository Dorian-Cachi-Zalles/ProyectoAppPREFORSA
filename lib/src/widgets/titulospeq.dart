import 'package:flutter/material.dart';

class Titulospeq extends StatelessWidget {
  final String titulo;


  const Titulospeq({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [        
        Align(
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

