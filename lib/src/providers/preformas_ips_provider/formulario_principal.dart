import 'package:flutter/material.dart';

class ProviderPesoPromedio with ChangeNotifier {
   double _pesoNeto = 0.0;

  double get pesoNeto => _pesoNeto;

  set pesoNeto(double value) {
    _pesoNeto = value;
    notifyListeners();
  }
}

