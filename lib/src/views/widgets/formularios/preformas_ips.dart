import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/models/settings_model.dart';
import 'package:proyecto/src/views/home_screen.dart';
import 'package:proyecto/src/views/settings_page.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_ctrl_pesos.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_datos.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_defectos.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_mat_prima.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_procesos.dart';
import 'package:proyecto/src/views/widgets/formularios/preformas%20ips/screen_temperatura.dart';

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
      ScreenDatos(),
      const ScreenMatPrima(),
      const ScreenDefectos(),
      const ScreenCtrlPesos(),
      const ScreenProcesos(),
      const ScreenTemperatura(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(SettingsModel settingsModel) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.insert_chart),
        title: ("Datos"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.green : Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.category),
        title: ("MP y Aditivos"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.amber : Colors.orange,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bug_report),
        title: ("Defectos"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.purple : Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.line_weight),
        title: ("Pesos"),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.build),
        title: ("Procesos"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.thermostat),
        title: ("Temperatura"),
        activeColorPrimary:
            settingsModel.isDarkMode ? Colors.orange : Colors.red,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<SettingsModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: settingsModel.isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "Preformas IPS",
          style: TextStyle(
            color: settingsModel.isDarkMode ? Colors.white : Colors.black,
          ),
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
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.abc,
                  size: 80,
                  weight: 80,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                leading: const Icon(Icons.sports_handball),
                title: const Text('Inicio'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenPreformasIPS()),
                  );
                },
                leading: const Icon(Icons.sports_handball),
                title: const Text('Preformas IPS-400'),
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Desarrollado por "  "'),
                ),
              ),
            ],
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
        backgroundColor: settingsModel.isDarkMode ? Colors.black : Colors.white,
        isVisible: true,
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
