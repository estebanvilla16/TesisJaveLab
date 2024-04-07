//Trabajo Realizado para proyecto de grado - JaveLab.
//CODIGO DE MENU INFERIOR DE LA APLICACION

import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20.0), // espacio superior contenedor
        child: const YourContentWidget(),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 10.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Iconos del navbar se usan los nativos de flutter
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
      icon: Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.grey),
      onPressed: () => _onItemTapped(index),
    ); //Index para saber que item fue seleccionado
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}
