import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class DatosInicialesIps {
  final int? id;
  final bool hasErrors;  
  final double PesoPromedio;
  final double Saldos;
  final double CajasControladas;

  // Constructor de la clase
  const DatosInicialesIps({
    this.id,
    required this.hasErrors,    
    required this.PesoPromedio,
    required this.Saldos,
    required this.CajasControladas
  });

  // Factory para crear una instancia desde un Map
  factory DatosInicialesIps.fromMap(Map<String, dynamic> map) {
    return DatosInicialesIps(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,      
      PesoPromedio: map['PesoPromedio'] as double,
      Saldos: map['Saldos'] as double,
      CajasControladas: map['CajasControladas'] as double
    );
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,      
      'PesoPromedio': PesoPromedio,
      'Saldos': Saldos,
      'CajasControladas': CajasControladas
    };
  }

  // Método copyWith
  DatosInicialesIps copyWith({
    int? id,
    bool? hasErrors,
    double? PesoPromedio, double? Saldos, double? CajasControladas
  }) {
    return DatosInicialesIps(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,      
      PesoPromedio: PesoPromedio ?? this.PesoPromedio,
      Saldos: Saldos ?? this.Saldos,
      CajasControladas: CajasControladas ?? this.CajasControladas
    );
  }
}

class MessageProvider extends ChangeNotifier {
  final String baseUrl = 'http://192.168.0.100:8000/api/';

  Future<Map<String, dynamic>?> fetchLatestMessage() async {
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
      print('Error en fetchLatestMessage: $e');
      return null;
    }
  }

  Future<void> updateMessage(String newMessage, int newNumber, String tipos, bool teGusta) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        body: json.encode({
          'message': newMessage,
          'number': newNumber,
          'tipos': tipos,
          'te_gusta': teGusta
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception('Error al actualizar mensaje');
      }
    } catch (e) {
      print('Error en updateMessage: $e');
    }
  }
}

class MessageFormScreen extends StatefulWidget {
  @override
  _MessageFormScreenState createState() => _MessageFormScreenState();
}

class _MessageFormScreenState extends State<MessageFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  late Future<Map<String, dynamic>?> _messageFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _messageFuture = messageProvider.fetchLatestMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _messageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error al cargar datos'));
          }

          final data = snapshot.data!;
          String _message = data['message'] ?? '';
          String _number = data['number']?.toString() ?? '0';
          String _tipos = data['tipos'] ?? 'Opción 1';
          bool _teGusta = (data['te_gusta'] == 1);

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'message',
                    initialValue: _message,
                    decoration: InputDecoration(labelText: 'Mensaje'),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'number',
                    initialValue: _number,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Número'),
                  ),

                  SizedBox(height: 10),
                  FormBuilderDropdown(
                    name: 'tipos',
                    initialValue: _tipos,
                    decoration: InputDecoration(labelText: 'Tipos'),
                    items: ['Opción 1', 'Opción 2', 'Opción 3']
                        .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                        .toList(),
                  ),
                  SizedBox(height: 10),
                  FormBuilderCheckbox(
                    name: 'te_gusta',
                    initialValue: _teGusta,
                    title: Text('¿Te gusta?'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState!.value;
                        await Provider.of<MessageProvider>(context, listen: false)
                            .updateMessage(
                          formData['message'],
                          int.tryParse(formData['number']) ?? 0,
                          formData['tipos'],
                          formData['te_gusta'],
                        );
                        setState(() {
                          _messageFuture = Provider.of<MessageProvider>(context, listen: false).fetchLatestMessage();
                        });
                      }
                    },
                    child: Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: Text('Actualizar'),
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

