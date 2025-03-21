import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/dropdownformulario.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';

class RegistroipsProvider extends ChangeNotifier {
  final String baseUrl = 'http://192.168.137.1:8888/api/IPS';

  Future<Map<String, dynamic>?> fetchLatestRegistroIps() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        notifyListeners();
        return data;
      } else {
        throw Exception('Error al obtener datos');
      }
    } catch (e) {
      print('Error en fetchLatestRegistroIps: $e');
      return null;
    }
  }

  Future<void> updateRegistroIps(String newModalidad, double newCiclo, int newPAinicial, int newPAfinal) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        body: json.encode({      
          'Modalidad': newModalidad,
          'Ciclo': newCiclo,
          'PAinicial': newPAinicial,
          'PAfinal': newPAfinal
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Error al actualizar mensaje');
      }
    } catch (e) {
      print('Error en updateRegistroIps: $e');
    }
  }
}

class RegistroIpsFormScreen extends StatefulWidget {
  @override
  _RegistroIpsFormScreenScreenState createState() => _RegistroIpsFormScreenScreenState();
}

class _RegistroIpsFormScreenScreenState extends State<RegistroIpsFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final Map<String, List<dynamic>> dropOptionsRegistroIps = {
    'Modalidad': ['Normal', 'Prueba'],
  };

  late Future<Map<String, dynamic>?> _RegistroIpsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final RegistroipsProviderProvider = Provider.of<RegistroipsProvider>(context, listen: false);
    _RegistroIpsFuture = RegistroipsProviderProvider.fetchLatestRegistroIps();
  }
  

 @override
Widget build(BuildContext context) {
  return Consumer<RegistroipsProvider>(
    builder: (context, provider, child) {
      return Scaffold(
        body: Column(
          children: [
            Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
           'Fromulario Datos Iniciales',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),         
            GestureDetector(
              onTap:_loadData ,
              child: Text(
                'Actualizar',
                style: TextStyle(
                  color: Colors.blue ,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),          
          const SizedBox(width: 23),
        ],
      ),
    ),
            Expanded( // Agregar Expanded aquí para permitir que FutureBuilder use el espacio restante
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _RegistroIpsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Center(child: Text('Error al cargar datos'));
                    }

                    final data = snapshot.data!;
                    String _Modalidad = data['Modalidad'] ?? '';
                    List<dynamic> opcionesModalidad = dropOptionsRegistroIps['Modalidad'] ?? [];

                    if (!opcionesModalidad.contains(_Modalidad)) {
                      _Modalidad = opcionesModalidad.isNotEmpty ? opcionesModalidad.first : '';
                    }
                    

                    String _Ciclo = data['Ciclo']?.toString() ?? '0';
                    String _PAinicial = data['PAinicial']?.toString() ?? '0';
                    String _PAfinal = data['PAfinal']?.toString() ?? '0';

                    return SingleChildScrollView( // Asegura que el contenido sea desplazable
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              DropdownSimple(

                                
                                name: 'Modalidad',
                                label: 'Modalidad',
                                opciones: 'Modalidad',
                                dropOptions: dropOptionsRegistroIps,
                                textoError: '',
                                valorInicial: _Modalidad,
                              ),
                              const SizedBox(height: 20),
                              CustomInputField(
                                name: 'Ciclo',
                                label: 'Ciclo',
                                valorInicial: _Ciclo,
                                isNumeric: true,
                                isRequired: true,
                              ),
                              const SizedBox(height: 20),
                              CustomInputField(
                                name: 'PAinicial',
                                label: 'PAinicial',
                                valorInicial: _PAinicial,
                                isNumeric: true,
                                isRequired: true,
                              ),
                              const SizedBox(height: 20),
                              CustomInputField(
                                name: 'PAfinal',
                                label: 'PAfinal',
                                valorInicial: _PAfinal,
                                isNumeric: true,
                                isRequired: true,
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 0),
                                child: SizedBox(
                                  height: 53,
                                  width: double.infinity,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 187, 206, 243),
                                          Color.fromARGB(255, 117, 165, 247),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState?.saveAndValidate() ?? false) {
                                          final formData = _formKey.currentState!.value;
                                          await Provider.of<RegistroipsProvider>(context, listen: false)
                                              .updateRegistroIps(
                                            formData['Modalidad'],
                                            double.tryParse(formData['Ciclo']) ?? 0,
                                            int.tryParse(formData['PAinicial']) ?? 0,
                                            int.tryParse(formData['PAfinal']) ?? 0,
                                          );
                                          setState(() {
                                            _RegistroIpsFuture = Provider.of<RegistroipsProvider>(context, listen: false)
                                                .fetchLatestRegistroIps();
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.add, color: Colors.black),
                                      label: const Text(
                                        'GUARDAR REGISTRO',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}