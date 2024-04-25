//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de creacion de intercambios.
import 'package:flutter/material.dart';
import 'widgets/burgermenu.dart';
import 'widgets/bottom_menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Intercambios'),
        ),
        body: const Cara12(),
        bottomNavigationBar: const BottomMenu(),
        endDrawer: const BurgerMenu(),
      ),
    );
  }
}

class Cara12 extends StatefulWidget {
  const Cara12({Key? key}) : super(key: key);

  @override
  _Cara12State createState() => _Cara12State();
}

class _Cara12State extends State<Cara12> {
  late List<bool> isSelected;
  String selectedOption = '';

  @override
  void initState() {
    super.initState();
    isSelected = [false, false]; // Ningún icono seleccionado por defecto
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            color: const Color(0xFF2c5697),
            width: double.infinity,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Crear Intercambio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.yellow, // Línea amarilla
            height: 10.0,
            width: double.infinity,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título del Intercambio',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del título negro
                        ),
                      ),
                      Text(
                        '* Ingrese el título del intercambio',
                        style: TextStyle(
                          color: Colors.red, // Color del asterisco rojo
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32.0, // Reducir la altura de la caja de texto del título
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[100], // Fondo gris claro de la caja de texto
                    ),
                    child: const Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categoría',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del título negro
                        ),
                      ),
                      Text(
                        '* Seleccione una categoría',
                        style: TextStyle(
                          color: Colors.red, // Color del asterisco rojo
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Instrumentos universitarios', child: Text('Instrumentos universitarios')),
                      DropdownMenuItem(value: 'Apuntes', child: Text('Apuntes')),
                      DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                    ],
                    onChanged: (String? value) {
                      // Lógica para guardar la categoría seleccionada
                    },
                  ),
                  const SizedBox(height: 8.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ubicación',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del título negro
                        ),
                      ),
                      Text(
                        'En Bogotá, Colombia',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32.0, // Reducir la altura de la caja de texto de ubicación
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[100], // Fondo gris claro de la caja de texto
                    ),
                    child: const Center(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contacto',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color del título negro
                        ),
                      ),
                      Text(
                        '+57 (123) 456-7890',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 32.0, // Reducir la altura de la caja de texto de contacto
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[100], // Fondo gris claro de la caja de texto
                    ),
                    child: const Center(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: Text(
                      'Adjuntar Imagen',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Color del título negro
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Lógica para insertar imagen (aún no implementada)
                    },
                    child: const Text(
                      '    Insertar Imagen',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue, // Color del enlace
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Propósito del Post',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Color del título negro
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ToggleButtons(
                          isSelected: isSelected,
                          onPressed: (int index) {
                            setState(() {
                              isSelected = List.generate(isSelected.length, (i) => i == index);
                              selectedOption = isSelected[0] ? 'Regalo' : 'Intercambio';
                            });
                          },
                          fillColor: Theme.of(context).primaryColor,
                          selectedColor: Colors.white,
                          borderColor: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                          children: const [
                            Column(
                              children: [
                                Icon(Icons.card_giftcard),
                                Text('Regalo'),
                              ],
                            ), // Icono para "Regalo"
                            Column(
                              children: [
                                Icon(Icons.swap_horiz),
                                Text('Intercambio'),
                              ],
                            ), // Icono para "Intercambio"
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (selectedOption.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Seleccionado: $selectedOption',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(width: 8.0),
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              // Mostrar información sobre la opción seleccionada
                              //el proposito nos permite determinar si la persona busca algo a cambio o regalar su objeto o contenido
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(selectedOption),
                                    content: Text('Seleccion la alternativa segun tu necesidad; Regalo o intercambio si esperas algo al respecto $selectedOption.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                    child: Text(
                      'Contenido del Post',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Color del título negro
                      ),
                    ),
                  ),
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[100], // Fondo gris claro del cuadro de texto
                    ),
                    child: const TextField( //Informacion de lo que requiere intercambiar
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Escribe el contenido de tu post',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para el botón "Publicar"
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0), // Bordes rectos
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF2c5697),
                        ),
                        //Publicar valida la informacion requerida para postear y publica el intercambio
                        child: const Text(
                          'Publicar',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para el botón "Cancelar"
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0), // Bordes rectos
                          ),
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                        child: const Text( //Cancelar regresa a la sesion anterior perdiendo la informacion diligenciada en el form
                          'Cancelar',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
