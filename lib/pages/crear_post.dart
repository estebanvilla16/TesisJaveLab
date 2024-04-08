
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';



class Cara8 extends StatefulWidget {
  const Cara8({Key? key}) : super(key: key);

  @override
  _Cara8State createState() => _Cara8State();
}

class _Cara8State extends State<Cara8> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController etiquetasController = TextEditingController();
  TextEditingController contenidoController = TextEditingController();
  String categoriaSeleccionada = "Programación"; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Lógica para ir hacia atrás
                    },
                  ),
                  const Text(
                    'Título',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Material(
                // Material wrapper
                child: TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    hintText: 'Título de tu Post',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: categoriaSeleccionada,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Programación',
                    child: Text('Programación'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Física Mecánica',
                    child: Text('Física Mecánica'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Cálculo Diferencial',
                    child: Text('Cálculo Diferencial'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    categoriaSeleccionada = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Etiquetas',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Material(
                // Material wrapper
                child: TextField(
                  controller: etiquetasController,
                  decoration: const InputDecoration(
                    hintText: 'Agrega etiquetas (separadas por comas)',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Contenido del Post',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Material(
                // Material wrapper
                child: TextField(
                  controller: contenidoController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Escribe el contenido de tu post',
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para el botón "Publicar"
                      _publicarPost(tituloController, contenidoController,
                          categoriaSeleccionada);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2c5697),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    child: const Text(
                      'Publicar',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  OutlinedButton(
                    onPressed: () {
                      // Lógica para el botón "Cancelar"
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2c5697)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF2c5697),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void _publicarPost(
    TextEditingController tituloController,
    TextEditingController contenidoController,
    String categoriaSeleccionada) async {
  String urlDynamic = Platform.isAndroid
      ? 'http://192.168.10.40:3010'
      : 'http://localhost:3010';
  final String url = ('$urlDynamic/post/agregar');

  String formattedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

  int etiqueta = _asignarValorCategoria(categoriaSeleccionada);

  Map<String, dynamic> data = {
    "id_op": 1,
    "etiqueta": etiqueta,
    "titulo": tituloController.text,
    //"categoria": categoriaSeleccionada,
    //"etiquetas": etiquetasController.text,
    "contenido": contenidoController.text,
    "material": 'null',
    "video": 'null',
    "valoracion": 0,
    "fecha": formattedDate,
    "nombre": 'Pepito Perez'
  };

 

  final response = await http.post(Uri.parse(url),
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

  if (response.statusCode == 201) {
    print('Post publicado: ${response.body}');
  } else {
    print(
        'Error al publicar el post. Código de estado: ${response.statusCode}');
  }
}

int _asignarValorCategoria(String? categoria) {
  switch (categoria) {
    case 'Programación':
      return 1;
    case 'Física Mecánica':
      return 3;
    case 'Cálculo Diferencial':
      return 2;
    default:
      return 0;
  }
}
