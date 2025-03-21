import json

# Mapeo de widgets para el formulario
widget_type_map = {
    1: "FormBuilderTextField",
    2: "FormBuilderDropdown<String>",
    3: "FormBuilderCheckbox",
    4: "FormBuilderSlider",
    5: "FormBuilderDropdown<int>"
}

# Configuración de la clase
class_config = {
    "class_name": "Registroips2",
    "table_name": "Registroips2",
    "fields": [
        {"name": "Modalidad", "type": "String", "widget_type": 2, "required": True},
        {"name": "Ciclo", "type": "double", "widget_type": 1, "required": True},
        {"name": "PAinicial", "type": "int", "widget_type": 1, "required": True},
        {"name": "PAfinal", "type": "int", "widget_type": 1, "required": True},        
    ],
}

# Asignar el tipo de widget a cada campo
for field in class_config["fields"]:
    widget_type_number = field["widget_type"]
    field["widget_type"] = widget_type_map.get(widget_type_number, "FormBuilderTextField")

# Plantilla del proveedor
provider_template = """
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/widgets/dropdownformulario.dart';
import 'package:proyecto/src/widgets/textosimpleformulario.dart';

class {provider_name} with ChangeNotifier {{
  final String baseUrl = 'http://192.168.137.1:8888/api/IPS';

  Future<Map<String, dynamic>?> fetchLatestRegistroIps() async {{
    try {{
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {{
        final data = json.decode(response.body)['data'];
        notifyListeners();
        return data;
      }} else {{
        throw Exception('Error al obtener datos');
      }}
    }} catch (e) {{
      print('Error en fetchLatestRegistroIps: $e');
      return null;
    }}
  }}

  Future<void> updateRegistroIps({fields}) async {{
    try {{
      final response = await http.put(
        Uri.parse(baseUrl),
        body: json.encode({{ {to_mapAPI} }}),
        headers: {{'Content-Type': 'application/json'}},
      );

      if (response.statusCode == 200) {{
        notifyListeners();
      }} else {{
        throw Exception('Error al actualizar mensaje');
      }}
    }} catch (e) {{
      print('Error en updateRegistroIps: $e');
    }}
  }}
}}
"""

# Función para generar campos de la clase Dart
def generate_field(field):
    return f"{field['type']} new{field['name']},"

# Función para generar el mapa para la API
def generate_to_mapAPI(fields): 
    return ",\n      ".join(f'"{f["name"]}": new{f["name"]}' for f in fields)

class_name = class_config["class_name"]
fields = [generate_field(f) for f in class_config["fields"]]
fields_str = "\n  ".join(fields)
to_mapAPI = generate_to_mapAPI(class_config["fields"])

provider_name = f"{class_name}Provider"

# Generar código del proveedor
provider_code = provider_template.format(
    provider_name=provider_name,
    fields=fields_str,
    to_mapAPI=to_mapAPI
)

print(provider_code)

def generate_dart_code(class_config):
    table_name = class_config["table_name"]
    fields = class_config["fields"]
    class_name = class_config["class_name"]

    dart_code = f"""

class {class_name}FormScreen extends StatefulWidget {{
  @override
  _{class_name}FormScreenState createState() => _{class_name}FormScreenState();
}}

class _{class_name}FormScreenState extends State<{class_name}FormScreen> {{
  final _formKey = GlobalKey<FormBuilderState>();

  final Map<String, List<dynamic>> dropOptions{class_name} = {{
    'Modalidad': ['Normal', 'Prueba'],
  }};

  late Future<Map<String, dynamic>?> _{class_name}Future;

  @override
  void initState() {{
    super.initState();
    _loadData();
  }}

  void _loadData() {{
  final {class_name}ProviderProvider = Provider.of<{class_name}Provider>(context, listen: false);
    _{class_name}Future = {class_name}ProviderProvider.fetchLatestRegistroIps(); 
  
  }}

  @override
  Widget build(BuildContext context) {{
  return Consumer<{class_name}Provider>(
    builder: (context, provider, child) {{      
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Text(
                  'Formulario Datos Iniciales',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _loadData,
                  child: Text(
                    'Actualizar',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 23),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _{class_name}Future,
                builder: (context, snapshot) {{
                  if (snapshot.connectionState == ConnectionState.waiting) {{
                    return Center(child: CircularProgressIndicator());
                  }}
                  if (snapshot.hasError || !snapshot.hasData) {{
                    return Center(child: Text('Error al cargar datos'));
                  }}

                  final data = snapshot.data!;
                    // Generar variables de estado para cada campo
    """

    for field in fields:
        field_name = field["name"]
        dart_code += f"                  String _{field_name} = data['{field_name}']?.toString() ?? '';\n"

    dart_code += """

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
    """

    for field in fields:
        field_name = field["name"]
        field_type = field["type"]
        widget_type = field["widget_type"]

        if widget_type == "FormBuilderTextField":
            dart_code += f"""
            CustomInputField(
            name: '{field_name}',
            label: '{field_name}',
            valorInicial: _{field_name},
            isNumeric: true,
            isRequired: true,),
            """

        elif widget_type.startswith("FormBuilderDropdown"):
            dart_code += f"""
            DropdownSimple(
            name: '{field_name}',
            label: '{field_name.capitalize()}',
            opciones: '{field_name}',
            dropOptions: dropOptions{class_name},
            textoError: ' ',
            valorInicial: _{field_name},              
            ),
            """

        elif widget_type == "FormBuilderSlider":
            dart_code += f"""
            FormBuilderSlider(
              name: '{field_name}',
              initialValue: (data['{field_name}'] as num?)?.toDouble() ?? 0.0,
              min: 0,
              max: 100,
              divisions: 10,
              decoration: InputDecoration(labelText: '{field_name.capitalize()}'),
            ),
            """

        elif widget_type == "FormBuilderCheckbox":
            dart_code += f"""
            CheckboxSimple(
              label: '{field_name.capitalize()}',
              name: '{field_name}',
              valorInicial: (data['{field_name}'] as bool?) ?? false,
            ),
            """

    dart_code += f"""
                          ],
                        ),
                      ),
                    ),
                  );
                }},
              ),
            ),
          ),
        ],
      ),
    );
 }});
}}}}
"""
    return dart_code

dart_code = generate_dart_code(class_config)
print(dart_code)