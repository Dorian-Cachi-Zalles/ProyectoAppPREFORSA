import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto/src/models/settings_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _dataTrackingEnabled = true;
  bool _soundEnabled = true;
  bool _isSpanish = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Cargar las preferencias de SharedPreferences
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _dataTrackingEnabled = prefs.getBool('dataTrackingEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
      _isSpanish = prefs.getBool('isSpanish') ?? true;
    });
  }

  // Guardar las preferencias
  void _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setBool('dataTrackingEnabled', _dataTrackingEnabled);
    prefs.setBool('soundEnabled', _soundEnabled);
    prefs.setBool('isSpanish', _isSpanish);
  }

  @override
  Widget build(BuildContext context) {
    // Acceder al modelo de configuración del tema y el tamaño de texto
    final settingsModel = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuraciones"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Guardar preferencias al salir de la configuración
            _savePreferences();

            // Actualizar el tema y el tamaño de la fuente en el modelo
            settingsModel.setTheme(settingsModel.isDarkMode);
            settingsModel.setFontSize(settingsModel.fontSize);

            // Volver a la pantalla anterior
            Navigator.pop(context);
          },
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Modo oscuro'),
                leading: const Icon(Icons.brightness_6),
                initialValue: settingsModel.isDarkMode,
                onToggle: (bool value) {
                  setState(() {
                    settingsModel.setTheme(value); // Cambiar tema
                  });
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Notificaciones'),
                leading: const Icon(Icons.notifications),
                initialValue: _notificationsEnabled,
                onToggle: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _savePreferences();
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Seguimiento de datos'),
                leading: const Icon(Icons.track_changes),
                initialValue: _dataTrackingEnabled,
                onToggle: (bool value) {
                  setState(() {
                    _dataTrackingEnabled = value;
                  });
                  _savePreferences();
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Sonido'),
                leading: const Icon(Icons.volume_up),
                initialValue: _soundEnabled,
                onToggle: (bool value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                  _savePreferences();
                },
              ),
              SettingsTile.switchTile(
                title: const Text('Idioma (Español/English)'),
                leading: const Icon(Icons.language),
                initialValue: _isSpanish,
                onToggle: (bool value) {
                  setState(() {
                    _isSpanish = value;
                  });
                  _savePreferences();
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Ajustes de texto'),
            tiles: [
              SettingsTile(
                title: const Text('Tamaño de texto'),
                leading: const Icon(Icons.text_fields),
                trailing: Slider(
                  min: 10,
                  max: 30,
                  divisions: 10,
                  value: settingsModel.fontSize,
                  onChanged: (double value) {
                    settingsModel
                        .setFontSize(value); // Cambiar tamaño de fuente
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
