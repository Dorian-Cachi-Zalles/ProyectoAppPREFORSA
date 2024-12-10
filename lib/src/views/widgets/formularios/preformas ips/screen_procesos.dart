import 'package:flutter/material.dart';

void main() => runApp(const ScreenProcesos());

class ScreenProcesos extends StatefulWidget {
  const ScreenProcesos({super.key});

  @override
  State<ScreenProcesos> createState() => _ScreenProcesosState();
}

class _ScreenProcesosState extends State<ScreenProcesos> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('hola'),
    );
  }
}
