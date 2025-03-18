import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class DatosPrefIPS {
  final int? id;
  final int idRegistro;  
  final bool hasSend;
  

  // Constructor de la clase
  const DatosPrefIPS(
      {this.id,
      required this.idRegistro,     
      required this.hasSend
      });

  // Factory para crear una instancia desde un Map
  factory DatosPrefIPS.fromMap(Map<String, dynamic> map) {
    return DatosPrefIPS(
        id: map['id'] as int?,
        idRegistro: map['idRegistro'] as int,
        hasSend: map['hasSend'] == 1
        );        
  }

  // Método para convertir la instancia a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'idRegistro': idRegistro,
      'hasSend': hasSend ? 1 : 0,
      
    };
  }

  // Método copyWith
  DatosPrefIPS copyWith(
      {int? id,
      int? idRegistro,
      bool? hasSend,
      }) {
    return DatosPrefIPS(
        id: id ?? this.id,
        idRegistro: idRegistro ?? this.idRegistro,       
        hasSend: hasSend ?? this.hasSend
        );
        
  }
}

class MessageProvider extends ChangeNotifier {
  final String baseUrl = 'http://192.168.0.100:8000/api/prueba';

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

  Future<void> updateMessage(String newMessage, bool newNumber, String tipos, bool teGusta) async {
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
          bool _number = data['number'] ?? false;
          String _tipos = data['tipos'] ?? 'Opción 1';
          bool _teGusta = data['te_gusta'] ?? false;

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
                  FormBuilderCheckbox(
                    name: 'number',
                    initialValue: _number,
                    title: Text('Número habilitado'),
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
                          formData['number'],
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

