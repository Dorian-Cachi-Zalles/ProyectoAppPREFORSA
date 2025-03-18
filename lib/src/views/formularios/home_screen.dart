import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/dashboard.dart';
import 'package:proyecto/src/views/descripcion_defectos.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/cosas/api_service.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/Providerids.dart';
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

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final ApiService apiService = ApiService();

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
          'feature_ControlAguas',
          'feature_registros',
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
      key: _scaffoldKey,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [           
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('images/LABO.jpg'), // Imagen de fondo
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(                
                children: [
                  SizedBox(height: 35,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.menu, size: 32.0),
                              onPressed: () {
                               _scaffoldKey.currentState?.openDrawer();                            
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.settings, size: 32.0),
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
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, right:16,top:  16),
                    height: 120,
                    width: double.infinity,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenido al',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3558), // Color azul oscuro
                          ),
                        ),
                        Text(
                          'Sistema de Control de Calidad',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Color(0xFF486581), // Color gris azulado
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Placeholder para el logo
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding:
                         const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Alinear contenido al inicio
                      children: [
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'images/logopre.png'), // Logo PREFORSA
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .start, // Alinear contenido al inicio
                      children: [
                        GestureDetector(
                          onTap: () {
    String message = 'Comida';
    int number = 34;
    ApiService().sendMessage(message,number);
  },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 116, 218, 33),
                                  Color.fromARGB(255, 134, 173, 177)
                                ], // Colores del degradado
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                  30.0), // Bordes redondeados
                            ),
                            child: Text(
                              'Inicie el tutorial',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Opciones',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),])),
                  SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DescribedFeatureOverlay(
                        featureId: 'feature_registros',
                        tapTarget: const Icon(Icons.chrome_reader_mode_outlined),
                        title: const Text('Descripción de defectos'),
                        description: const Text(
                          'Consulta información sobre defectos y su impacto en la calidad.',
                        ),
                        backgroundColor: Colors.green,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color1:  const Color.fromARGB(255, 29, 163, 58),
                           color2: const Color.fromARGB(255, 18, 95, 34),
                          icon: Icons.bug_report,
                          text: "Registro de\n estado de Lineas",
                          fontSize: settingsModel.fontSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenEstadoRegistros(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
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
                          color1: Color(0xFFFFD700),
                          color2: Color(0xFFFFA500),
                          icon: Icons.content_paste_search_outlined,
                          text: "Control de Linea",
                          fontSize: settingsModel.fontSize,
                        onTap: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Consumer<IdsProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.all(8),
              width: 300,
              height: 400,
              child: provider.idsRegistrosList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.idsRegistrosList.length,
                      itemBuilder: (context, index) {
                        final datos = provider.idsRegistrosList[index];

                        // Verificamos si `estado` es true para mostrar el nombre
                        if (!datos.estado) return const SizedBox.shrink();

                        // Mapa de IDs con sus respectivas pantallas
                        final Map<int, Widget Function(BuildContext)> pantallas = {
                          1: (context) => const ScreenPreformasIPS(),
                          2: (context) => ScreenPreformasIPS(),
                          3: (context) => const ScreenPreformasIPS(),
                        };

                        return ListTile(
                          title: Text(datos.nombre!),
                          leading: const Icon(Icons.linear_scale_rounded),
                          onTap: () {
                            Navigator.pop(context); // Cierra el diálogo antes de navegar
                            if (pantallas.containsKey(datos.id)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: pantallas[datos.id]!),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Pantalla no definida para este ID")),
                              );
                            }
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text("No hay registros"),
                    ),
            );
          },
        ),
      );
    },
  );
},


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
                        featureId: 'feature_ControlAguas',
                        tapTarget: const Icon(Icons.settings_suggest),
                        title: const Text('Control de Agua'),
                        description: const Text(
                            'Registro Control de Aguas.'),
                        backgroundColor: Colors.blueAccent,
                        targetColor: Colors.white,
                        textColor: Colors.white,
                        child: CustomContainer(
                          color1: const Color(0xFF1E90FF),
                          color2: const Color.fromARGB(255, 50, 98, 117),
                          icon: Icons.water_drop,
                          text: "Control de Aguas",
                          fontSize: settingsModel.fontSize,
                          onTap: () {},
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
                          color1: Colors.redAccent,
                           color2: const Color.fromARGB(255, 158, 51, 51),
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
              const SizedBox(height: 10),             
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comunicados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
             
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
        SizedBox(height: 25),
      ])
      )
      );
  }
  }

