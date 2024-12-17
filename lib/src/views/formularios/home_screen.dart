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
          'feature_dashboard'
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
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: DescribedFeatureOverlay(
        featureId: 'feature_drawer',
        tapTarget: const Icon(Icons.menu),
        title: const Text('Menú de navegación'),
        description: const Text('Accede al menú para ver más opciones'),
        backgroundColor: Colors.blueAccent,
        child: const CustomDrawer(),
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
                child: DescribedFeatureOverlay(
                  featureId: 'feature_maquinas',
                  tapTarget: const Icon(Icons.build),
                  title: const Text('Acceso a máquinas'),
                  description: const Text('Accede al formulario de preformas.'),
                  backgroundColor: Colors.orangeAccent,
                  child: CustomContainer(
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
                ),
              ),
              const SizedBox(height: 16),
              DescribedFeatureOverlay(
                featureId: 'feature_dashboard',
                tapTarget: const Icon(Icons.dashboard),
                title: const Text('Acceso al Dashboard'),
                description: const Text('Accede al panel de control.'),
                backgroundColor: Colors.redAccent,
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
    );
  }
}
