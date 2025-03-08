import 'package:flutter/material.dart';

class BotonesFormulario extends StatelessWidget {
  final VoidCallback? onGuardar;
  final VoidCallback? onCancelar;
  final VoidCallback? onEnviar;

  const BotonesFormulario({
    Key? key,
    this.onGuardar,
    this.onCancelar,
    this.onEnviar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2, // Hacer el botón "Guardar" más grande
            child: BotonAccion(
              texto: 'Guardar',
              icono: Icons.save,
              colorInicio: const Color.fromARGB(255, 187, 206, 243),
              colorFin: const Color.fromARGB(255, 117, 165, 247),
              onPressed: onGuardar,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: BotonAccion(
              texto: 'Cancelar',
              icono: Icons.cancel,
              colorInicio: const Color.fromARGB(255, 255, 184, 184),
              colorFin: const Color.fromARGB(255, 240, 80, 80),
              onPressed: onCancelar,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: BotonAccion(
              texto: 'Enviar',
              icono: Icons.send,
              colorInicio: const Color.fromARGB(255, 183, 242, 196),
              colorFin: const Color.fromARGB(255, 60, 180, 90),
              onPressed: onEnviar,
            ),
          ),
        ],
      ),
    );
  }
}


class BotonAccion extends StatelessWidget {
  final String texto;
  final IconData icono;
  final Color colorInicio;
  final Color colorFin;
  final VoidCallback? onPressed;

  const BotonAccion({
    Key? key,
    required this.texto,
    required this.icono,
    required this.colorInicio,
    required this.colorFin,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [colorInicio, colorFin]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, color: Colors.black, size: 20),
              const SizedBox(width: 4),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 12, // Texto más pequeño
                  fontWeight: FontWeight.w500,
                  color: Colors.black
                ),
              ),
            ],          
          ),
        ),
      ),
    );
  }
}
