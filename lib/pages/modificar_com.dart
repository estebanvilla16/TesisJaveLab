import 'package:JaveLab/models/comentario.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class EditarComentarioScreen extends StatefulWidget {
  final Comentario com;

  const EditarComentarioScreen({Key? key, required this.com}) : super(key: key);

  @override
  _EditarComentarioScreenState createState() => _EditarComentarioScreenState();
}

class _EditarComentarioScreenState extends State<EditarComentarioScreen> {
  late TextEditingController _contenidoController;
  late int id;

  @override
  void initState() {
    super.initState();
    _contenidoController = TextEditingController(text: widget.com.mensaje);
    id = widget.com.id_com;
  }

  @override
  void dispose() {
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
            const SizedBox(height: 16.0),
            const Text(
              'Contenido:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contenidoController,
              maxLines: null,
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
                    String nuevoContenido = _contenidoController.text;
                    _modificarCom(nuevoContenido, id);
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

  void _modificarCom(String nuevoContenido, int id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://10.195.49.54:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/comentario/actualizar/$id');

    Map<String, dynamic> data = {
      "mensaje": nuevoContenido,
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
