//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de Gestion de la aplicacion para usuarios con permisos adm
import 'package:flutter/material.dart';
import 'widgets/bottom_menu.dart'; // Asumiendo que este archivo define un widget para el menú inferior
import 'widgets/burgermenu.dart'; // Asumiendo que este archivo define un widget para el menú lateral

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Panel de Gestión Unificado',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue),
        fontFamily: 'OpenSans',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14.0),
        ),
        scaffoldBackgroundColor: Colors.grey[200], // Establece el color de fondo para todos los Scaffold
      ),
      home: const ManagementDashboard(),
    );
  }
}

class ManagementDashboard extends StatefulWidget {
  const ManagementDashboard({super.key});

  @override
  _ManagementDashboardState createState() => _ManagementDashboardState();
}

class _ManagementDashboardState extends State<ManagementDashboard> {
  final List<ManagementPanelItem> _data = generateManagementPanelItems();
  ManagementAction? selectedAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Gestión'),
      ),
      body: SingleChildScrollView(
        child: _buildExpansionPanelList(),
      ),
      bottomNavigationBar: const BottomMenu(), //Menu Inferior
      endDrawer: const BurgerMenu(), // Menu hamburguesa
    );
  }

  Widget _buildExpansionPanelList() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: -1,
      children: _data.map<ExpansionPanelRadio>((ManagementPanelItem item) {
        return ExpansionPanelRadio(
          value: item.id,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListBody(
              children: item.expandedValue.map<Widget>((ManagementAction action) {
                return ListTile(
                  title: Text(action.label),
                  leading: Icon(action.icon),
                  onTap: () {
                    setState(() {
                      selectedAction = action;
                    });
                    if (action.onTap != null) {
                      action.onTap!(context);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

void blockUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Bloquear usuario'),
        content: const Text('¿Estás seguro de bloquear a este usuario?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirmar bloqueo'),
            onPressed: () {
              print('Bloqueando al usuario...');
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class ManagementPanelItem {
  int id;
  List<ManagementAction> expandedValue;
  String headerValue;

  ManagementPanelItem({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });
}

class ManagementAction {
  String label;
  IconData icon;
  void Function(BuildContext)? onTap;

  ManagementAction({required this.label, required this.icon, this.onTap});
}
// Panel de gestion
List<ManagementPanelItem> generateManagementPanelItems() {
  return [
    ManagementPanelItem(
      id: 1,
      headerValue: 'Gestionar ruta académica',
      expandedValue: [ //opcion de panel desplegable
        ManagementAction(label: 'Agregar capítulo', icon: Icons.add, onTap: blockUser),
        ManagementAction(label: 'Editar capítulo', icon: Icons.edit, onTap: blockUser),
        ManagementAction(label: 'Eliminar capítulo', icon: Icons.delete, onTap: blockUser),
      ],
    ),
    ManagementPanelItem(
      id: 2,
      headerValue: 'Gestionar usuarios',
      expandedValue: [//opcion de panel desplegable
        ManagementAction(label: 'Bloquear usuario', icon: Icons.block, onTap: blockUser),
        ManagementAction(label: 'Desbloquear usuario', icon: Icons.lock_open, onTap: blockUser),
        ManagementAction(label: 'Eliminar usuario', icon: Icons.delete_forever, onTap: blockUser),
      ],
    ),
    ManagementPanelItem(//opcion de panel desplegable
      id: 3,
      headerValue: 'Gestionar intercambios',
      expandedValue: [
        ManagementAction(label: 'Aprobar intercambio', icon: Icons.check, onTap: blockUser),
        ManagementAction(label: 'Rechazar intercambio', icon: Icons.close, onTap: blockUser),
      ],
    ),
    ManagementPanelItem(
      id: 4,
      headerValue: 'Gestionar Foro',
      expandedValue: [//opcion de panel desplegable
        ManagementAction(label: 'Agregar a ruta académica', icon: Icons.add, onTap: blockUser),
        ManagementAction(label: 'Editar Post', icon: Icons.edit, onTap: blockUser),
        ManagementAction(label: 'Eliminar Post', icon: Icons.delete, onTap: blockUser),
      ],
    ),
  ];
}
