import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Modelo de datos
class Usuario {
  final int id;
  final String Hora;
  final String PA;
  final double? PesoTotal;

  Usuario({
    required this.id,
    required this.Hora,
    required this.PA,
    this.PesoTotal,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      Hora: json['Hora'],
      PA: json['PA'],
      PesoTotal: json['PesoTotal'] != null ? json['PesoTotal'].toDouble() : null,
    );
  }
}

// Servicio de API
class ApiService {
  static const String url = 'http://192.168.137.1:8888/api/pesosips';

  Future<List<Usuario>> fetchUsuarios() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> jsonData = jsonResponse['data'];
      return jsonData.map((json) => Usuario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}

// DataSource para manejar la paginación
class UsuariosDataSource extends DataTableSource {
  final List<Usuario> usuarios;

  UsuariosDataSource(this.usuarios);

  @override
  DataRow? getRow(int index) {
    if (index >= usuarios.length) return null;
    final usuario = usuarios[index];
    return DataRow(cells: [
      DataCell(Text(usuario.id.toString())),
      DataCell(Text(usuario.Hora)),
      DataCell(Text(usuario.PA)),
      DataCell(Text(usuario.PesoTotal?.toString() ?? 'N/A')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => usuarios.length;
  @override
  int get selectedRowCount => 0;
}


// Widget principal
class UsuariosPaginatedTable extends StatefulWidget {
  const UsuariosPaginatedTable({super.key});

  @override
  createState() => _UsuariosPaginatedTableState();
}

class _UsuariosPaginatedTableState extends State<UsuariosPaginatedTable> {
  late Future<List<Usuario>> futureUsuarios;
  UsuariosDataSource? dataSource;

  @override
  void initState() {
    super.initState();
    futureUsuarios = ApiService().fetchUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios con Paginación')),
      body: FutureBuilder<List<Usuario>>(
        future: futureUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          dataSource ??= UsuariosDataSource(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: PaginatedDataTable(
              header: const Text('Lista de Usuarios'),
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Usuario')),
                DataColumn(label: Text('Correo')),
              ],
              source: dataSource!,
              rowsPerPage: 5, // Número de filas por página
            ),
          );
        },
      ),
    );
  }
}