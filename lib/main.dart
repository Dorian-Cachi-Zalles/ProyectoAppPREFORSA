import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_discovery/feature_discovery.dart'; // Importar FeatureDiscovery
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/formulario_principal.dart';
import 'package:proyecto/src/services/bdpreformas.dart';
import 'package:proyecto/src/views/formularios/home_screen.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/Providerids.dart';
import 'package:proyecto/src/widgets/settings_page.dart';

class AppThemes {
  // Tema claro
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color.fromARGB(255, 255, 255, 255),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueAccent,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Color.fromARGB(255, 14, 13, 13),
      backgroundColor: Colors.lightBlue,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(108, 173, 170, 165),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue;
        }
        return Colors.transparent;
      }),
    ),
  );

  // Tema oscuro
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: const Color.fromARGB(255, 51, 47, 47),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
      backgroundColor: Colors.blueGrey,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blueGrey;
        }
        return Colors.transparent;
      }),
    ),
  );
}
 
void main() {
  runApp(
    FeatureDiscovery(
      // Asegurarse de que FeatureDiscovery envuelva toda la aplicación
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => ProviderPesoPromedio()),
          ChangeNotifierProvider(create: (_) => IdsProvider()),
          ChangeNotifierProvider(create: (_) => DatosProviderPrefIPS())

          
        ],        
        child: const MyApp(),
      ),
    ),
  );
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
          final settingsProvider = Provider.of<SettingsProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Configuraciones App',
            theme: settingsProvider.isDarkMode
                ? AppThemes.darkTheme
                : AppThemes.lightTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
