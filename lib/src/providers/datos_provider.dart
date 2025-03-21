import 'package:flutter/material.dart';

class DatosProvider with ChangeNotifier {
  String _auxiliar = "";
  String _turno = "";

  String get auxiliar => _auxiliar;
  String get turno => _turno;

  void setDatos(String aux, String tur) {
    _auxiliar = aux;
    _turno = tur;
    notifyListeners();
  }
}
