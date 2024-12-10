import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: Builder(
        builder: (context) {
          // Obtener la configuración del modelo para aplicar al tema
          final settingsModel = Provider.of<SettingsModel>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Configuraciones App',
            theme:
                settingsModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
