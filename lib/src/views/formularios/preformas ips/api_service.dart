import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.18:8000/api/messages'; // URL base

  // Método actualizado para enviar message y number
  Future<void> sendMessage(String message, int number) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'message': message,
        'number': number, // Agregamos el número al cuerpo de la solicitud
      }),
    );

    if (response.statusCode == 201) { // Cambiado a 201 para reflejar la respuesta del servidor
      print('Message sent successfully!');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
