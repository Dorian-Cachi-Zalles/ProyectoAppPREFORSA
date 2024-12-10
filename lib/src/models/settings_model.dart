import 'package:flutter/material.dart';

class SettingsModel extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 14.0;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  // Método para cambiar el tema
  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners(); // Notificar a todos los listeners sobre el cambio
  }

  // Método para cambiar el tamaño de la fuente
  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners(); // Notificar a todos los listeners sobre el cambio
  }
}
