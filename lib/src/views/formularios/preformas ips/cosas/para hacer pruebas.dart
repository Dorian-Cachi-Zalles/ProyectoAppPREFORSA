import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/dropdownformulario.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';

class Registroips2Provider with ChangeNotifier {
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

  Future<void> updateRegistroIps(String newModalidad,
  double newCiclo,
  int newPAinicial,
  int newPAfinal,) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        body: json.encode({ "Modalidad": newModalidad,
      "Ciclo": newCiclo,
      "PAinicial": newPAinicial,
      "PAfinal": newPAfinal }),
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



class Registroips2FormScreen extends StatefulWidget {
  @override
  _Registroips2FormScreenState createState() => _Registroips2FormScreenState();
}

class _Registroips2FormScreenState extends State<Registroips2FormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final Map<String, List<dynamic>> dropOptionsRegistroips2 = {
    'Modalidad': ['Normal', 'Prueba'],
  };

  late Future<Map<String, dynamic>?> _Registroips2Future;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
  final Registroips2ProviderProvider = Provider.of<Registroips2Provider>(context, listen: false);
    _Registroips2Future = Registroips2ProviderProvider.fetchLatestRegistroIps();

  }

  @override
  Widget build(BuildContext context) {
  return Consumer<Registroips2Provider>(
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
                  'Formulario Datos Iniciales',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _loadData,
                  child: Text(
                    'Actualizar',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 23),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _Registroips2Future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text('Error al cargar datos'));
                  }

                  final data = snapshot.data!;
                    // Generar variables de estado para cada campo
                      String _Modalidad = data['Modalidad']?.toString() ?? '';
                  String _Ciclo = data['Ciclo']?.toString() ?? '';
                  String _PAinicial = data['PAinicial']?.toString() ?? '';
                  String _PAfinal = data['PAfinal']?.toString() ?? '';


                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [

            DropdownSimple(
            name: 'Modalidad',
            label: 'Modalidad',
            opciones: 'Modalidad',
            dropOptions: dropOptionsRegistroips2,
            textoError: ' ',
            valorInicial: _Modalidad,
            ),

            CustomInputField(
            name: 'Ciclo',
            label: 'Ciclo',
            valorInicial: _Ciclo,
            isNumeric: true,
            isRequired: true,),

            CustomInputField(
            name: 'PAinicial',
            label: 'PAinicial',
            valorInicial: _PAinicial,
            isNumeric: true,
            isRequired: true,),

            CustomInputField(
            name: 'PAfinal',
            label: 'PAfinal',
            valorInicial: _PAfinal,
            isNumeric: true,
            isRequired: true,),

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
 });
}}