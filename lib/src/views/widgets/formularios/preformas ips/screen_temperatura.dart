import 'package:flutter/material.dart';

void main() => runApp(const ScreenTemperatura());

class ScreenTemperatura extends StatefulWidget {
  const ScreenTemperatura({super.key});

  @override
  State<ScreenTemperatura> createState() => _ScreenTemperaturaState();
}

class _ScreenTemperaturaState extends State<ScreenTemperatura> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
