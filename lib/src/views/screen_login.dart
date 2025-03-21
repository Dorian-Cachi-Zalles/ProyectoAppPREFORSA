import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/providers/datos_provider.dart';
import 'package:proyecto/src/views/formularios/home_screen.dart'; // Asegúrate de importar tu pantalla HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController auxiliarController = TextEditingController();
  final TextEditingController turnoController = TextEditingController();

  @override
  void dispose() {
    auxiliarController.dispose();
    turnoController.dispose();
    super.dispose();
  }

  void _login() {
    if (auxiliarController.text.isNotEmpty && turnoController.text.isNotEmpty) {
      Provider.of<DatosProvider>(context, listen: false)
          .setDatos(auxiliarController.text, turnoController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen()), // Redirige a HomeScreen
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, llena todos los campos"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('images/LABO.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.darken),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logopre.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: auxiliarController, // Asignamos el controlador
                    decoration: const InputDecoration(
                      labelText: "Auxiliar",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: turnoController, // Asignamos el controlador
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Turno",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _login, // Llama a la función _login
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "INGRESAR",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
