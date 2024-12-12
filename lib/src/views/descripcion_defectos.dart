import 'package:flutter/material.dart';

class ScreenDescDefec extends StatelessWidget {
  const ScreenDescDefec({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> defectDescriptions = [
      {
        'title': 'Burbuja',
        'description':
            'Defecto causado por atrapamiento de aire durante la inyección.',
      },
      {
        'title': 'Raya de flujo',
        'description':
            'Líneas visibles en la preforma debido a un flujo inadecuado del material.',
      },
      {
        'title': 'Manchas negras',
        'description':
            'Contaminación del material o acumulación de residuos en la máquina.',
      },
      {
        'title': 'Peso incorrecto',
        'description':
            'El peso de la preforma no coincide con el especificado, lo que afecta su calidad.',
      },
      {
        'title': 'Cristalización',
        'description':
            'Apariencia opaca o blanquecina causada por un enfriamiento insuficiente.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defectos'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: defectDescriptions.length,
        itemBuilder: (context, index) {
          final defect = defectDescriptions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    defect['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    defect['description']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
