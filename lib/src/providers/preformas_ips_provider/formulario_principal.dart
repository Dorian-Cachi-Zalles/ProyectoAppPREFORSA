import 'package:flutter/material.dart';

class ProviderPesoPromedio with ChangeNotifier {
  double _pesoPromedio = 0.0;

  double get pesoPromedio => _pesoPromedio;

  void setPesoPromedio(double value) {
    _pesoPromedio = value;
    notifyListeners();
  }
}
