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
                  children: [
                    Text(
                      'JaveLab',
                      style: TextStyle(
                        color: Color(0xFF2c5697),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pontificia Universidad Javeriana',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Iconos nativos de material flutter.
          buildMenuItem(context, Icons.home, 'Home'),
          buildMenuItem(context, Icons.person, 'Perfil'),
          buildMenuItem(context, Icons.chat, 'Conversaciones'),
          buildMenuDivider(),
          buildMenuItem(context, Icons.swap_horiz, 'Intercambios'),
          buildMenuItem(context, Icons.forum, 'Foro'),
          buildMenuItem(context, Icons.school, 'Ruta académica'),
          buildMenuItem(context, Icons.people, 'Monitorias'),
          buildMenuItem(context, Icons.calendar_today, 'Calendario académico'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[300],
            child: Column(
              children: const [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            color: _isHovered
                                ? Colors.black.withOpacity(0.85) // Más oscuro
                                : Colors.grey.withOpacity(0.85), // Más oscuro
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Cerrar Sesión',
                            style: TextStyle(
                              color: _isHovered
                                  ? Colors.black.withOpacity(0.85) // Más oscuro
                                  : Colors.grey.withOpacity(0.85), // Más oscuro
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            //Detectanis si se pasa el click por encima para generar efectos de color
                            color: _isHovered ? Colors.black : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            //Copyright
                            'JaveLab 2024',
                            style: TextStyle(
                              color: _isHovered ? Colors.black : Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      onHover: (isHovered) {
        setState(() {
          _isHovered = isHovered;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        color: _isHovered ? Colors.grey[400] : Colors.white,
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2c5697),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuDivider() {
    return Container(
      height: 1,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
