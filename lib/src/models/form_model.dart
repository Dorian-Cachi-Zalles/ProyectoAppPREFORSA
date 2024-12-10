import 'package:flutter/material.dart';

class FormModel extends ChangeNotifier {
  Map<String, dynamic> _formData = {};

  Map<String, dynamic> get formData => _formData;

  void updateField(String name, dynamic value) {
    _formData[name] = value;
    notifyListeners(); // Notifica a los widgets que usan este modelo
  }

  void setInitialValues(Map<String, dynamic> values) {
    _formData = values;
    notifyListeners();
  }
}
