import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/settings_page.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas_ips.dart';
import 'package:proyecto/src/widgets/custom_drawer.dart';
import 'package:proyecto/src/widgets/custom_container_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista de comunicados
  final List<String> comunicados = [
    "Comunicado 1: Actualización del sistema",
    "Comunicado 2: Nueva funcionalidad disponible",
    "Comunicado 3: Mantenimiento programado"
  ];

  @override
  Widget build(BuildContext context) {
    // Acceder al estado gestionado por Provider
    final settingsModel = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PREFORSA"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Llamamos al CustomDrawer aquí
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    'Control de calidad',
                    style: TextStyle(
                      fontSize: settingsModel.fontSize + 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        color: Colors.orangeAccent,
                        icon: Icons.build,
                        text: "Maquinas",
                        fontSize: settingsModel.fontSize,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScreenPreformasIPS(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomContainer(
                        color: Colors.blueAccent,
                        icon: Icons.person,
                        text: "Gestion de \nParametros",
                        fontSize: settingsModel.fontSize,
                        onTap: () {
                          // Agrega la navegación correspondiente
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomContainer(
                        color: const Color.fromARGB(255, 29, 163, 58),
                        icon: Icons.bug_report,
                        text: "Descripcion de \n     Defectos",
                        fontSize: settingsModel.fontSize,
                        onTap: () {
                          // Agrega la navegación correspondiente
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomContainer(
                        color: Colors.redAccent,
                        icon: Icons.dashboard,
                        text: "Dashboard",
                        fontSize: settingsModel.fontSize,
                        onTap: () {
                          // Agrega la navegación correspondiente
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Comunicados',
                    style: TextStyle(
                      fontSize: settingsModel.fontSize + 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Lista de comunicados con Dismissible
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comunicados.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(comunicados[index]),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      setState(() {
                        comunicados.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Eliminaste un comunicado"),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          comunicados[index],
                          style: TextStyle(fontSize: settingsModel.fontSize),
                        ),
                        leading: const Icon(Icons.notifications),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
