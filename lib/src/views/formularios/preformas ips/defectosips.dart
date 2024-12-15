import 'package:flutter/material.dart';


class DefectsScreen extends StatefulWidget {
  const DefectsScreen({super.key});

  @override
  _DefectsScreenState createState() => _DefectsScreenState();
}

class _DefectsScreenState extends State<DefectsScreen> {
   final Map<String, String> countryImages = {
    "Españo": "https://via.placeholder.com/400x300.png?text=España",
    "Francia": "https://via.placeholder.com/400x300.png?text=Francia",
    "Italia": "https://via.placeholder.com/400x300.png?text=Italia",
    "Alemania": "https://via.placeholder.com/400x300.png?text=Alemania",
  };

  List<String> filteredCountries = [];
  String searchQuery = "";
  String? selectedCountry; // País seleccionado
  Map<String, String> feedbackMap = {}; // Mapa para almacenar las selecciones

  @override
  void initState() {
    super.initState();
    filteredCountries = countryImages.keys.toList();
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredCountries = countryImages.keys
          .where((country) => country.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleSelection(String country) {
    setState(() {
      selectedCountry = country; // Actualiza el país seleccionado
    });
  }

  void saveFeedback(String? feedback) {
    if (selectedCountry != null && feedback != null) {
      setState(() {
        feedbackMap[selectedCountry!] = feedback; // Almacena la selección
        selectedCountry = null; // Cierra el contenedor después de guardar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galería de Países"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Galería deslizable
              Expanded(
                child: PageView.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountries[index];
                    final imageUrl = countryImages[country]!;
                    return GestureDetector(
                      onTap: () => toggleSelection(country),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.black54,
                            child: Text(
                              country,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Buscador
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Buscar país",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: updateSearch,
                ),
              ),

              // Contenedor de Chips
              if (feedbackMap.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    children: feedbackMap.entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCountry = entry.key; // Al tocar el Chip, muestra el Container
                          });
                        },
                        child: Chip(
                          label: Text("${entry.key}: ${entry.value}"),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              feedbackMap.remove(entry.key); // Elimina el Chip
                            });
                          },
                        ),
                      );
                    }).toList(),
                  )
                ),
            ],
          ),

          // Container flotante
          if (selectedCountry != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Selecciona tu opinión sobre ${selectedCountry!}:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: feedbackMap[selectedCountry],
                        hint: Text("Elige una opción"),
                        items: ["Me gustó", "No me gustó"]
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: saveFeedback,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCountry = null; // Cierra el container
                          });
                        },
                        child: Text("Cancelar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}