import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/dashboard.dart';
import 'package:proyecto/src/views/descripcion_defectos.dart';
import 'package:proyecto/src/widgets/settings_page.dart';
import 'package:proyecto/src/views/formularios/preformas_ips.dart';
import 'package:proyecto/src/widgets/custom_drawer.dart';
import 'package:proyecto/src/widgets/custom_container_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> comunicados = [
    "Comunicado 1: Actualización del sistema",
    "Comunicado 2: Nueva funcionalidad disponible",
    "Comunicado 3: Mantenimiento programado"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const [
          'feature_settings',
          'feature_drawer',
          'feature_maquinas',
          'feature_parametros',
          'feature_defectos',
          'feature_dashboard',
          'feature_comunicados'
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PREFORSA"),
        centerTitle: true,
        actions: [
          DescribedFeatureOverlay(
            featureId: 'feature_settings',
            tapTarget: const Icon(Icons.settings),
            title: const Text('Ajustes'),
            description:
                const Text('Accede a la configuración de la aplicación'),
            backgroundColor: Colors.blueAccent,
            targetColor: Colors.white,
            textColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              FeatureDiscovery.discoverFeatures(
                context,
                const [
                  'feature_settings',
                  'feature_drawer',
                  'feature_maquinas',
                  'feature_parametros',
                  'feature_defectos',
                  'feature_dashboard',
                  'feature_comunicados'
                ],
              );
            },
          ),
        ],
      ),
      drawer: const DescribedFeatureOverlay(
        featureId: 'feature_drawer',
        tapTarget: Icon(Icons.menu),
        title: Text('Menú de navegación'),
        description: Text('Accede al menú para ver más opciones'),
        backgroundColor: Colors.blueAccent,
        targetColor: Colors.white,
        textColor: Colors.white,
        child: CustomDrawer(),
      ),
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
                      DescribedFeatureOverlay(
                        featureId: 'feature_maquinas',
                        tapTarget: const Icon(Icons.build),
                        title: const Text('Acceso a máquinas'),
                        description: const Text(
                          'Accede al formulario de preformas para registrar nuevas entradas.',
                        ),
                        backgroundColor: Colors.orangeAccent,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color: Colors.orangeAccent,
                          icon: Icons.build,
                          text: "Maquinas",
                          fontSize: settingsModel.fontSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenPreformasIPS(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      DescribedFeatureOverlay(
                        featureId: 'feature_parametros',
                        tapTarget: const Icon(Icons.settings_suggest),
                        title: const Text('Gestión de parámetros'),
                        description: const Text(
                            'Configura y gestiona los parámetros del sistema.'),
                        backgroundColor: Colors.blueAccent,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color: Colors.blueAccent,
                          icon: Icons.settings_suggest,
                          text: "Gestion de\nParametros",
                          fontSize: settingsModel.fontSize,
                          onTap: () {},
                        ),
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
                      DescribedFeatureOverlay(
                        featureId: 'feature_defectos',
                        tapTarget: const Icon(Icons.bug_report),
                        title: const Text('Descripción de defectos'),
                        description: const Text(
                          'Consulta información sobre defectos y su impacto en la calidad.',
                        ),
                        backgroundColor: Colors.green,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color: const Color.fromARGB(255, 29, 163, 58),
                          icon: Icons.bug_report,
                          text: "Descripcion de\n     Defectos",
                          fontSize: settingsModel.fontSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenDescDefec(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      DescribedFeatureOverlay(
                        featureId: 'feature_dashboard',
                        tapTarget: const Icon(Icons.dashboard),
                        title: const Text('Panel de control'),
                        description: const Text(
                          'Accede al dashboard para ver estadísticas e informes.',
                        ),
                        backgroundColor: Colors.redAccent,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color: Colors.redAccent,
                          icon: Icons.dashboard,
                          text: "Dashboard",
                          fontSize: settingsModel.fontSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenDashboard(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 30),
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
              DescribedFeatureOverlay(
                featureId: 'feature_comunicados',
                tapTarget: const Icon(Icons.notifications),
                title: const Text('Área de comunicados'),
                description: const Text(
                  'Consulta los comunicados importantes sobre el sistema y el mantenimiento.',
                ),
                backgroundColor: Colors.purple,
                targetColor: Colors.white,
                textColor: Colors.white,
                child: ListView.builder(
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
                      },
                      background: Container(color: Colors.green),
                      secondaryBackground: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(comunicados[index]),
                        leading: const Icon(Icons.notifications),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
