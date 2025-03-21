import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/checkboxformulario.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosPESOSIPSProvider2 with ChangeNotifier {
  SharedPreferences? _prefs;
  bool isLoading = true; // Nueva bandera para controlar la carga
  
  String hora = "";
  double pesoTotal = 0.0;
  int hasErrors = 0;

  DatosPESOSIPSProvider2() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
    isLoading = false; // Indicar que los datos ya se cargaron
    notifyListeners(); 
  }

  void _loadData() {
    if (_prefs == null) return;
    hasErrors = _prefs!.getInt("hasErrors") ?? 0;
    hora = _prefs!.getString("hora") ?? "";
    pesoTotal = _prefs!.getDouble("pesoTotal") ?? 0.0;
  }

  Future<void> updateData({int? hasErrors, String? hora, double? pesoTotal}) async {
    if (_prefs == null) return;

    if (hasErrors != null) {
      await _prefs!.setInt("hasErrors", hasErrors);
      this.hasErrors = hasErrors;
    }
    if (hora != null) {
      await _prefs!.setString("hora", hora);
      this.hora = hora;
    }
    if (pesoTotal != null) {
      await _prefs!.setDouble("pesoTotal", pesoTotal);
      this.pesoTotal = pesoTotal;
    }

    notifyListeners(); 
  }

  Future<void> clearData() async {
    if (_prefs == null) return;
    await _prefs!.clear();
    hora = "";
    pesoTotal = 0.0;
    hasErrors = 0;
    notifyListeners();
  }
}

class RegistroIpsFormScreen2 extends StatefulWidget {
  @override
  _RegistroIpsFormScreen2State createState() => _RegistroIpsFormScreen2State();
}

class _RegistroIpsFormScreen2State extends State<RegistroIpsFormScreen2> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<DatosPESOSIPSProvider2>(context, listen: false)._initPrefs(),
      builder: (context, snapshot) {
        return Consumer<DatosPESOSIPSProvider2>(
          builder: (context, provider, child) {
            return Scaffold(
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.isLoading) // Mostrar solo si está cargando
                        Center(child: CircularProgressIndicator())
                      else ...[
                        CustomInputField(
                          name: 'Hora',
                          label: 'Hora',
                          valorInicial: provider.hora, 
                          isRequired: true,
                          onChanged: (value) {
                            provider.updateData(hora: value);
                          },
                        ),
                        CustomInputField(
                          name: 'PesoTotal',
                          label: 'Peso Total',
                          valorInicial: provider.pesoTotal.toString(),
                          isNumeric: true,
                          isRequired: true,
                          onChanged: (value) {
                            provider.updateData(pesoTotal: double.tryParse(value!) ?? 0.0);
                          },
                        ),
                        CheckboxSimple(
                          name: 'haserror',
                          label: 'Has Error',
                          valorInicial: provider.hasErrors == 1,
                          onChanged: (value) {
                            provider.updateData(hasErrors: value! ? 1 : 0);
                          },
                        ),
                        const SizedBox(height: 20),

                        /// ***Mostrar los datos guardados***
                        Text("Datos guardados:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Hora: ${provider.hora}"),
                        Text("Peso Total: ${provider.pesoTotal}"),
                        Text("Has Errors: ${provider.hasErrors}"),

                     
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
