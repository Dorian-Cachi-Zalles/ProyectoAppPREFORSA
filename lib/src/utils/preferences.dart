import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> saveSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getSwitchState(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ??
        false; // Devuelve false si no se encuentra el valor
  }
}
