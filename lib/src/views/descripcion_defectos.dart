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
        'icon': 'bubble_chart',
      },
      {
        'title': 'Raya de flujo',
        'description':
            'Líneas visibles en la preforma debido a un flujo inadecuado del material.',
        'icon': 'water_drop',
      },
      {
        'title': 'Manchas negras',
        'description':
            'Contaminación del material o acumulación de residuos en la máquina.',
        'icon': 'palette',
      },
      {
        'title': 'Peso incorrecto',
        'description':
            'El peso de la preforma no coincide con el especificado, lo que afecta su calidad.',
        'icon': 'scale',
      },
      {
        'title': 'Cristalización',
        'description':
            'Apariencia opaca o blanquecina causada por un enfriamiento insuficiente.',
        'icon': 'cloud',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Defectos de Producción'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade100, Colors.blue.shade200],
              ),
            ),
            child: const Text(
              'Lista de posibles defectos encontrados durante la producción de preformas. Cada defecto puede afectar la calidad final del producto.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: defectDescriptions.length,
              itemBuilder: (context, index) {
                final defect = defectDescriptions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blueAccent.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueAccent.shade100,
                          child: Icon(
                            _getIcon(defect['icon']!),
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                defect['title']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                defect['description']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'bubble_chart':
        return Icons.bubble_chart;
      case 'water_drop':
        return Icons.water_drop;
      case 'palette':
        return Icons.palette;
      case 'scale':
        return Icons.scale;
      case 'cloud':
        return Icons.cloud;
      default:
        return Icons.error_outline;
    }
  }
}
