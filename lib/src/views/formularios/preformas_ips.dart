import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/services/bdpreformas.dart';
import 'package:proyecto/src/views/formularios/home_screen.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/cosas/para%20hacer%20pruebas.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/defe.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/principio.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/registroips.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_ctrl_MP.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_procesos.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/sharepreference.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/temp.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/Providerids.dart';
import 'package:proyecto/src/widgets/settings_page.dart';
import 'package:proyecto/src/views/formularios/preformas%20ips/screen_ctrl_pesos.dart';


class ScreenPreformasIPS extends StatefulWidget {
  const ScreenPreformasIPS({super.key});

  @override
  State<ScreenPreformasIPS> createState() => _ScreenPreformasIPSState();
}

class _ScreenPreformasIPSState extends State<ScreenPreformasIPS> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      RegistroIpsFormScreen(),
      ScreenListDatosMPIPS(),     
      ScreenListDatosDEFIPS(),
      ScreenListDatosPESOSIPS(),
      ScreenListDatosPROCEIPS(),
      ScreenListDatosTEMPIPS(),
    ];
  }  

  List<PersistentBottomNavBarItem> _navBarsItems(SettingsModel settingsModel) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.insert_chart),
        title: ("DATOS INICIALES"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.green : Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category),
        title: ("MP Y ADITIVOS"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.amber : Colors.orange,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bug_report),
        title: ("DEFECTOS"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.purple : Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.monitor_weight_outlined),
        title: ("PESOS"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.build),
        title: ("PROCESO"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.thermostat),
        title: ("TEMPERATURA"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.orange : Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override  
  Widget build(BuildContext context) {
    final provider = Provider.of<IdsProvider>(context);
    final settingsModel = Provider.of<SettingsModel>(context);
    return MultiProvider(
        providers: [
         ChangeNotifierProvider(create: (_) => MessageProvider()..fetchLatestMessage()),
         ChangeNotifierProvider(create: (_) => RegistroipsProvider()..fetchLatestRegistroIps()),
          ChangeNotifierProvider(create: (_) => Registroips2Provider()..fetchLatestRegistroIps()),           
          ChangeNotifierProvider(create: (_) => EditProviderDatosPESOSIPS()),
          ChangeNotifierProvider(create: (_) => DatosPESOSIPSProvider2()), 
          
        ],
        child: Scaffold(
         appBar: PreferredSize(
  preferredSize: const Size.fromHeight(85), // Altura personalizada
  child: AppBar(
    backgroundColor: settingsModel.isDarkMode
        ? Colors.black
        : const Color.fromARGB(255, 255, 255, 255),
    flexibleSpace: Stack(
      children: [
        const Image(
          image: AssetImage('images/PREFIPS.png'),
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(            
            children: [
              SizedBox(height: 30),
              Text(
                "Inyección de",
                style: TextStyle(
                  color: settingsModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Preformas IPS-400",
                style: TextStyle(
                  color: settingsModel.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    centerTitle: true,
    iconTheme: IconThemeData(
      color: settingsModel.isDarkMode ? Colors.white : Colors.black,
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>SettingsPage()),
          );
        },
      ),
    ],
  ),
),
drawer: Container(
  color: Colors.black54,
  child: SafeArea(
    child: ListTileTheme(
      textColor: Colors.white,
      iconColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.abc, size: 80),
            ),
            // Agregamos un SingleChildScrollView para evitar problemas de scroll
            Expanded(
              child: Column(
                children: [
                  ListTile(
                            onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                                    );
                                  },                                
                            leading: const Icon(Icons.sports_handball),
                            title: Text('INICIO'),
                          ),

                  Expanded(
                    child: ListView.builder(                      
                      itemCount: provider.idsRegistrosList.length,
                      itemBuilder: (context, index) {
                        final  registro = provider.idsRegistrosList[index];
                        final List<Map<String, dynamic>> menu = [
                          {'title': 'IPS-400', 'screen': const ScreenPreformasIPS(), 'estado': null},
                          {'title': 'I5', 'screen': null, 'estado': null},
                          {'title': 'CCM', 'screen': null, 'estado': null},
                          {'title': 'COLORACAP', 'screen': null, 'estado': null},
                          {'title': 'YUTZUMI', 'screen': null, 'estado': null},
                          {'title': 'IT 2 HX-258', 'screen': null, 'estado': null},
                          {'title': 'SOPLADO', 'screen': null, 'estado': null},
                        ];  
                         if (registro.estado) {
                          menu[index]['estado'] = true; 
                        } else {
                          menu[index]['estado'] = false;
                        }                    
                        // Filtramos los elementos cuya propiedad 'estado' es true
                        final visibleMenuItems = menu.where((item) => item['estado'] == true).toList();
                    
                        // Si no hay elementos visibles, no generamos la lista para ese registro
                        if (visibleMenuItems.isEmpty) {
                          return const SizedBox(); // Retorna un SizedBox vacío si no hay elementos visibles
                        }
                    
                        // Generamos los ListTile solo para los registros visibles
                        return Column(
                          children: visibleMenuItems.map((item) {
                            return ListTile(
                              onTap: item['screen'] != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => item['screen']),
                                      );
                                    }
                                  : null, // Si no hay pantalla asociada, no hace nada
                              leading: const Icon(Icons.sports_handball),
                              title: Text(item['title']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 12, color: Colors.white54),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Text('Desarrollado por "  "'),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
          body: PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(settingsModel),
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardAppears: true,
            backgroundColor:
                settingsModel.isDarkMode ? Colors.black : Colors.white,
            isVisible: true,            
            navBarStyle: NavBarStyle.style9,
          ),
        ));
  }
}
