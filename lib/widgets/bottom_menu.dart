import 'package:flutter/material.dart';


class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key}) : super(key: key);

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
  if (index != _selectedIndex) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'inicio');
        break;
      case 1:
        Navigator.pushNamed(context, 'login');
        break;
      case 2:
        Navigator.pushNamed(context, 'foro');
        break;
      case 3:
        Navigator.pushNamed(context, 'perfil');
        break;
      case 4:
        Navigator.pushNamed(context, 'usuarios');
        break;
    }
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
      icon: Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.grey),
      onPressed: () => _onItemTapped(index),
    );
  }
}
