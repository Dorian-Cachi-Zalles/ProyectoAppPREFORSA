import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/src/views/formularios/preformas%20ips/model_mensaje_prueba.dart';

class MessageService {
  final String baseUrl = "http://192.168.0.100:8000/api/messages";

  // Obtener todos los mensajes
  Future<List<Message>> getMessages() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((data) => Message.fromJson(data)).toList();
    } else {
      throw Exception('Error al obtener mensajes');
    }
  }

  // Obtener un mensaje por ID
  Future<Message> getMessageById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Message.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Mensaje no encontrado');
    }
  }

  // Crear un mensaje
  Future<Message> createMessage(Message message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Error al crear mensaje');
    }
  }

  // Actualizar un mensaje
  Future<void> updateMessage(Message message) async {
    final response = await http.put(
      Uri.parse('$baseUrl/messages/${message.id}'),
      body: json.encode({
        'message': message.message,
        'number': message.number,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el mensaje');
    }
  }

  // Eliminar un mensaje
  Future<void> deleteMessage(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar mensaje');
    }
  }
}
