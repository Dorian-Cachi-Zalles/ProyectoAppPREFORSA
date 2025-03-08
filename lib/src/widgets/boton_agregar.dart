import 'package:flutter/material.dart';

class BotonAgregar extends StatelessWidget {
  final VoidCallback? onPressed;

  const BotonAgregar({
    super.key,    
    this.onPressed,
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
            onPressed: onPressed,


            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'AGREGAR UN REGISTRO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )))));
      
  }
}