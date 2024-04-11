import 'package:JaveLab/MainAPP.dart';
import 'package:JaveLab/pages/foro.dart';
import 'package:JaveLab/perfil.dart';
import 'package:JaveLab/rutaAcademica.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BurgerMenu(),
      ),
    );
  }
}

class BurgerMenu extends StatefulWidget {
  const BurgerMenu({Key? key}) : super(key: key);

  @override
  _BurgerMenuState createState() => _BurgerMenuState();
}

class _BurgerMenuState extends State<BurgerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, color: Color(0xFF2c5697), size: 40),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('JaveLab',
                        style: TextStyle(
                            color: Color(0xFF2c5697),
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    Text('Pontificia Universidad Javeriana',
                        style: TextStyle(color: Colors.black54, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFF2c5697)),
            title: Text('Home', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Home'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFF2c5697)),
            title: Text('Perfil', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Perfil'),
          ),
          ListTile(
            leading: Icon(Icons.chat, color: Color(0xFF2c5697)),
            title: Text('Conversaciones', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Conversaciones'),
          ),
          Container(
              height: 1,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(vertical: 4)),
          ListTile(
            leading: Icon(Icons.swap_horiz, color: Color(0xFF2c5697)),
            title: Text('Intercambios', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Intercambios'),
          ),
          ListTile(
            leading: Icon(Icons.forum, color: Color(0xFF2c5697)),
            title: Text('Foro', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Foro'),
          ),
          ListTile(
            leading: Icon(Icons.school, color: Color(0xFF2c5697)),
            title: Text('Ruta académica', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Ruta académica'),
          ),
          ListTile(
            leading: Icon(Icons.people, color: Color(0xFF2c5697)),
            title: Text('Monitorias', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Monitorias'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Color(0xFF2c5697)),
            title: Text('Calendario académico', style: TextStyle(fontSize: 16)),
            onTap: () => navigateToScreen(context, 'Calendario académico'),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[300],
            child: Column(
              children: const [
                Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('JaveLab 2024',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToScreen(BuildContext context, String title) {
    switch (title) {
      case 'Home':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => Principal()));
        break;
      case 'Perfil':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => ProfilePage()));
        break;
      case 'Conversaciones':

        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationsScreen()));
        break;
      case 'Intercambios':

        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationsScreen()));
        break;
      case 'Foro':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Cara6()));
        break;
      case 'Ruta académica':
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PantallaRutaAprendizaje()));
        break;
      case 'Monitorias':

        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationsScreen()));
        break;
      case 'Calendario académico':

        // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ConversationsScreen()));
        break;

      // Incluye los demás casos aquí
      default:
        Navigator.of(context)
            .pop(); // Cierra el drawer si no hay una pantalla definida
    }
  }
}
