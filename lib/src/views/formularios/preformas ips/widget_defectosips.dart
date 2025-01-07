import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_defectos.dart';

class DefectosScreenWidget extends StatefulWidget {
  final int id; 
  const DefectosScreenWidget({required this.id, Key? key}) : super(key: key);

  @override
  _DefectosScreenState createState() => _DefectosScreenState();
}

class _DefectosScreenState extends State<DefectosScreenWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<String> defectosOptions = ['B', 'CN', 'PC',];
  List<String> criticidadOptions = ['Alta', 'Media', 'Baja'];
  String? selectedCriticidad;

  Map<String, Map<String, String>> defectosImages = {
  'B': {
    'name': 'Burbuja',
    'image': 'images/d1.jpg',
  },
  'CN': {
    'name': 'Cascara de naranja',
    'image': 'images/d2.jpg',
  },
  'PC': {
    'name': 'Punto Contaminante',
    'image': 'images/d3.png',
  },
};


  @override
  Widget build(BuildContext context) {
  final datosProvider = Provider.of<DatosDEFIPSProvider>(context);
  final dato = datosProvider.datosdefipsList.firstWhere(
    (dato) => dato.id == widget.id,
  );

  // Filtrar defectos por búsqueda
  final filteredDefectos = defectosOptions.where((defecto) {
    return defecto.toLowerCase().contains(_searchController.text.toLowerCase());
  }).toList();

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buscador de defectos
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Buscar defecto',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {}); // Refresca la galería
          },
        ),

        const SizedBox(height: 10),

        // Galería de defectos
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filteredDefectos.map((defecto) {
              final imagePath = defectosImages[defecto]?['image'];
              final defectoName = defectosImages[defecto]?['name'] ?? defecto;              
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Seleccionar criticidad para $defectoName'),
                        content: DropdownButtonFormField<String>(
                          value: selectedCriticidad,
                          hint: const Text("Selecciona criticidad"),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCriticidad = newValue;
                            });
                          },
                          items: criticidadOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        actions: [
                          TextButton(                            
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedCriticidad != null) {
                                // Buscar el índice del defecto existente
                                final existingIndex =
                                    dato.Defectos.indexOf(defecto);

                                if (existingIndex != -1) {
                                  // Si ya existe, actualizar criticidad en la posición correspondiente
                                  setState(() {
                                    dato.Criticidad[existingIndex] =
                                        selectedCriticidad!;
                                  });
                                } else {
                                  // Si no existe, añadir el nuevo defecto y su criticidad
                                  setState(() {
                                    dato.Defectos.add(defecto);
                                    dato.Criticidad.add(selectedCriticidad!);
                                  });
                                }

                                // Actualizar datos en el proveedor y cerrar el diálogo
                                datosProvider.updateDatito(
                                  dato.id!,
                                  dato.copyWith(
                                    Defectos: dato.Defectos,
                                    Criticidad: dato.Criticidad,
                                  ),
                                );

                                selectedCriticidad = null;
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 300,
                  height: 300,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Imagen como fondo
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            imagePath ?? 'assets/images/default.png', // Imagen predeterminada
                            fit: BoxFit.cover, // La imagen ocupa todo el espacio
                          ),
                        ),
                      ),
                      // Texto flotante
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6), // Fondo semitransparente
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            defectoName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // Chips para mostrar defectos seleccionados
        Wrap(
          spacing: 8.0,
          children: List.generate(dato.Defectos.length, (index) {
            return Chip(
              backgroundColor: Colors.blueAccent.withOpacity(0.6),
              label: Text(
                style: TextStyle(fontSize: 14),
                  '${dato.Defectos[index]} - ${dato.Criticidad[index]}'),
              onDeleted: () {
                setState(() {
                  dato.Defectos.removeAt(index);
                  dato.Criticidad.removeAt(index);
                });
                datosProvider.updateDatito(
                  dato.id!,
                  dato.copyWith(
                    Defectos: dato.Defectos,
                    Criticidad: dato.Criticidad,
                  ),
                );
              },
            );
          }),
        ),
      ],
    ),
  );
}
}
