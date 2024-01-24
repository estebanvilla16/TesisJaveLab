import 'package:flutter/material.dart';

/// Flutter code sample for [BottomAppBar].

void main() => runApp(const BottomAppBarExampleApp());

class BottomAppBarExampleApp extends StatelessWidget {
  const BottomAppBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomAppBarExample(),
    );
  }
}

class BottomAppBarExample extends StatefulWidget {
  const BottomAppBarExample({super.key});

  @override
  State<BottomAppBarExample> createState() =>
      _BottomAppBarExampleState();
}

class _BottomAppBarExampleState
    extends State<BottomAppBarExample> {
  int _selectedIndex = 0; // cambia el valor inicial a 0


  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home', // cambia el texto a Home
      style: optionStyle,
    ),

    Text(
      'Index 1: Ruta',
      style: optionStyle,
    ),

    Text(
      'Index 2: Foro', // cambia el texto a Foro
      style: optionStyle,
    ),
    Text(
      'Index 3: Perfil',
      style: optionStyle,
    ),

    Text(
      'Index 4: Mensajes',
      style: optionStyle,
    ),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JaveLab'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomAppBar( // usa el widget BottomAppBar
        color: Color(0xFF2c5697), // agrega un color de fondo a la barra
        child: Row( // usa un widget Row para colocar los ítems de la barra
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // distribuye los ítems de forma uniforme
          children: <Widget>[
            Spacer(), // agrega un espacio a la izquierda del primer ítem
            IconButton( // usa un widget IconButton para crear un ítem con un ícono y una acción
              icon: Icon(Icons.home), // cambia el ícono a home
              color: _selectedIndex == 0 ? Colors.white : Color(0xFFDDDDDD), // cambia el color según el índice seleccionado
              onPressed: () => _onItemTapped(0), // cambia el índice seleccionado al presionar el ítem
            ),
            Spacer(), // agrega un espacio entre el primer y el segundo ítem
            IconButton( // usa otro widget IconButton para crear otro ítem
              icon: Icon(Icons.school),
              color: _selectedIndex == 1 ? Colors.white : Color(0xFFDDDDDD),
              onPressed: () => _onItemTapped(1),
            ),
            Spacer(), // agrega un espacio entre el segundo y el tercer ítem
            IconButton( // usa otro widget IconButton para crear otro ítem
              icon: Icon(Icons.forum_outlined), // cambia el ícono a forum_outlined
              color: _selectedIndex == 2 ? Colors.white : Color(0xFFDDDDDD),
              onPressed: () => _onItemTapped(2),
            ),
            Spacer(), // agrega un espacio entre el tercer y el cuarto ítem
            IconButton( // usa otro widget IconButton para crear otro ítem
              icon: Icon(Icons.account_circle_rounded),
              color: _selectedIndex == 3 ? Colors.white : Color(0xFFDDDDDD),
              onPressed: () => _onItemTapped(3),
            ),
            Spacer(), // agrega un espacio entre el cuarto y el quinto ítem
            IconButton( // usa otro widget IconButton para crear otro ítem
              icon: Icon(Icons.message_outlined),
              color: _selectedIndex == 4 ? Colors.white : Color(0xFFDDDDDD),
              onPressed: () => _onItemTapped(4),
            ),
            Spacer(), // agrega un espacio a la derecha del quinto ítem
          ],
        ),
      ),
    );
  }
}