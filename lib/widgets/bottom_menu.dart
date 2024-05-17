import 'package:JaveLab/pages/instructivo_foro.dart';
import 'package:JaveLab/pages/instructivo_ruta_academica.dart';
import 'package:JaveLab/pages/main_app.dart';
import 'package:JaveLab/pages/usuarios_page.dart';
import 'package:JaveLab/pages/perfil.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:provider/provider.dart';

class YourContentWidget extends StatelessWidget {
  const YourContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your Content'),
    );
  }
}

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;
  late Usuario user;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    user = authService.usuario;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Principal()));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  OnboardingScreen()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  ForumOnboardingScreen()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UsuariosPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildNavBarItem(Icons.home, 0),
          buildNavBarItem(Icons.school, 1),
          buildNavBarItem(Icons.forum_outlined, 2),
          buildNavBarItem(Icons.account_circle_rounded, 3),
          buildNavBarItem(Icons.message_outlined, 4),
        ],
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon,
          color: _selectedIndex == index ? Colors.blue : Colors.grey),
      onPressed: () => _onItemTapped(index),
    );
  }
}

// Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Home Screen")),
    );
  }
}

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("School")),
      body: const Center(child: Text("School Screen")),
    );
  }
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forum")),
      body: const Center(child: Text("Forum Screen")),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: const Center(child: Text("Account Screen")),
    );
  }
}

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: const Center(child: Text("Messages Screen")),
    );
  }
}
