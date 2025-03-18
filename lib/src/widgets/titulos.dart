import 'package:flutter/material.dart';

class Titulos extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final int tipo;
  final Future<void> Function()? accion;
  

  const Titulos({
    super.key,
    required this.titulo,
    required this.tipo,
    this.accion,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final bool tieneSubtitulo = subtitulo != null && subtitulo!.isNotEmpty;

     // Función intermedia para manejar la llamada asíncrona
    void handleEliminar() {
      if (accion != null) {
        accion!();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (tipo == 1)
            GestureDetector(
             onTap: accion != null
                  ? () async {
                      await accion!();
                    }
                  : null,
              child: Text(
                tieneSubtitulo ? subtitulo! : 'Borrar Todo',
                style: TextStyle(
                  color: tieneSubtitulo ? Colors.blue : Colors.red,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 23),
        ],
      ),
    );
  }
}

