import 'dart:io';
import 'package:JaveLab/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class EditarPublicacionScreen extends StatefulWidget {
  final Post post;

  const EditarPublicacionScreen({Key? key, required this.post})
      : super(key: key);

  @override
  _EditarPublicacionScreenState createState() =>
      _EditarPublicacionScreenState();
}

class _EditarPublicacionScreenState extends State<EditarPublicacionScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;
  late int id;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.post.titulo);
    _contenidoController = TextEditingController(text: widget.post.contenido);
    id = widget.post.id_post;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Publicación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Título:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el título de la publicación',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Contenido:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contenidoController,
              maxLines: null, // Permite varias líneas
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Ingrese el contenido de la publicación',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Lógica para confirmar la edición
                    String nuevoTitulo = _tituloController.text;
                    String nuevoContenido = _contenidoController.text;
                    _modificarPost(nuevoTitulo, nuevoContenido, id);
                    // Aquí debes realizar la actualización del post con los nuevos valores
                    Navigator.pop(context); // Cerrar la pantalla de edición
                  },
                  child: const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para cancelar la edición
                    Navigator.pop(context); // Cerrar la pantalla de edición
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.red, // Cambia el color del botón a rojo
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _modificarPost(String nuevoTitulo, String nuevoContenido, int id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.10.7:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/post/actualizar/$id');

    Map<String, dynamic> data = {
      "titulo": nuevoTitulo,
      "contenido": nuevoContenido,
    };

    print(data);

    final response = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Post modificado: ${response.body}');
    } else {
      print(
          'Error al modificar el post. Código de estado: ${response.statusCode}');
    }
  }
}
