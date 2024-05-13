import 'package:JaveLab/pages/ver_post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/post.dart';

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
  late TextEditingController _etiquetaController;
  late String mat;
  late int id;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.post.titulo);
    _contenidoController = TextEditingController(text: widget.post.contenido);
    _etiquetaController = TextEditingController(text: widget.post.tags);
    mat = widget.post.material ??
        ""; // Inicializa con post.material o vacío si es null
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
              'Etiquetas:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _etiquetaController,
              decoration: const InputDecoration(
                hintText: 'Ingrese las etiquetas de la publicación',
              ),
            ),
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
            if (widget.post.material != "null")
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: mat),
                      decoration: const InputDecoration(
                        hintText: 'Material adjunto',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _confirmarEliminarMaterial(context);
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String nuevoTitulo = _tituloController.text;
                    String nuevoContenido = _contenidoController.text;
                    String nuevaEtiqueta = _etiquetaController.text;
                    _modificarPost(nuevoTitulo, nuevoContenido, nuevaEtiqueta,
                        id, mat, widget.post.material);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostViewScreen(id: widget.post.id_post)));
                  },
                  child: const Text('Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
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

  void _modificarPost(String nuevoTitulo, String nuevoContenido,
      String nuevaEtiqueta, int id, String mat, String filename) async {
    final String url = '${Environment.foroUrl}/post/actualizar/$id';

    Map<String, dynamic> data = {
      "titulo": nuevoTitulo,
      "contenido": nuevoContenido,
      "material": mat,
      "tags": nuevaEtiqueta,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Post modificado: ${response.body}');
      if (mat == "null") {
        final String url2 =
            ('${Environment.blobUrl}/api/blob/delete/$filename');
        final response2 = await http.delete(Uri.parse(url2));

        if (response2.statusCode == 200) {
          print('Archivo eliminado: ${response2.body}');
        } else {
          print('Error al eliminar el archivo: ${response2.body}');
        }
      }
    } else {
      print(
          'Error al modificar el post. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> _confirmarEliminarMaterial(BuildContext context) async {
    bool confirmado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Material Adjunto'),
          content:
              const Text('¿Está seguro de eliminar este material adjunto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma la eliminación
              },
              child: const Text('Sí'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela la eliminación
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmado) {
      setState(() {
        mat = "null"; // Actualiza la variable de material a "null"
      });
    }
  }
}
