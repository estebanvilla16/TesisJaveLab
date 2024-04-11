import 'package:JaveLab/models/comentario.dart';
import 'package:JaveLab/models/post.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:JaveLab/pages/editar_post.dart';
import 'package:JaveLab/pages/foro.dart';
import 'package:JaveLab/pages/modificar_com.dart';

class PostViewScreen extends StatefulWidget {
  final int? id;

  const PostViewScreen({Key? key, required this.id}) : super(key: key);

  @override
  _PostViewScreenState createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  late Future<Post> _postFuture;
  TextEditingController comentarioController = TextEditingController();
  late Future<List<Comentario>> _comentariosFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = _fetchPost(widget.id);
    _comentariosFuture = _fetchComs(widget.id!);
  }

  void updateComentarios() {
    setState(() {
      _comentariosFuture = _fetchComs(widget.id!);
    });
  }

  Future<Post> _fetchPost(int? id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/post/$id');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Comentario>> _fetchComs(int idPost) async {
    try {
      // Realiza una solicitud HTTP GET para obtener la lista de Posts
      String urlDynamic = Platform.isAndroid
          ? 'http://192.168.56.1:3010'
          : 'http://localhost:3010';
      final String url = ('$urlDynamic/comentario/lista-comentarios/$idPost');
      final response = await http.get(Uri.parse(url));

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        // Convierte la respuesta JSON en una lista de mapas
        final List<dynamic> postData = jsonDecode(response.body);
        // Crea una lista de Posts a partir de los datos obtenidos
        final List<Comentario> coms =
            postData.map((data) => Comentario.fromJson(data)).toList();
        // Ahora tienes la lista de Posts, puedes usarla según necesites
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      // Si ocurrió un error durante la solicitud, imprímelo
      return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2c5697),
        title: const Text(
          'Javelab',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Post>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final post = snapshot.data!;
            return PostView(
                post: post,
                comentarioController: comentarioController,
                comentariosFuture: _comentariosFuture,
                updateComentarios: updateComentarios);
          }
        },
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final Post post;
  final TextEditingController comentarioController;
  final Future<List<Comentario>> comentariosFuture;
  final VoidCallback updateComentarios;

  const PostView(
      {Key? key,
      required this.post,
      required this.comentarioController,
      required this.comentariosFuture,
      required this.updateComentarios})
      : super(key: key);

  void _deleteComment(int id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/comentario/borrar/$id');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Comentario eliminado: ${response.statusCode}');
    } else {
      print(
          'Error al eliminar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  post.titulo,
                  style: const TextStyle(fontSize: 38.0),
                ), // Aquí iría el título del post
              ), // Aquí iría el título del post
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Editar publicación'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Eliminar publicación'),
                    ),
                  ),
                ],
                onSelected: (String value) {
                  // Manejar la opción seleccionada
                  if (value == 'edit') {
                    // Lógica para editar la publicación
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditarPublicacionScreen(post: post),
                    ));
                  } else if (value == 'delete') {
                    // Lógica para eliminar la publicación
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: const Text(
                              "¿Estás seguro de que quieres eliminar esta publicación?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deletePost(post.id_post);
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Cara6(),
                                ));
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            post.nombre,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            'Fecha: ${DateFormat('yyyy-MM-dd').format(post.fecha)}', // Suponiendo que 'fecha' es de tipo DateTime
            style: const TextStyle(
              fontSize: 20.0,
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
          Text(
            _asignarValorCategoria(post.etiqueta),
            style: const TextStyle(fontSize: 18.0),
          ), // Aquí iría la categoría del post
          const SizedBox(height: 16.0),
          const Text(
            'Contenido del Post',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            post.contenido,
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 20),
          // Sección de comentarios/mensajes
          const Text(
            'Comentarios',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: comentarioController,
            decoration: const InputDecoration(
              hintText: 'Escribe un comentario...',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Lógica para enviar el comentario
                  _crearCom(post.id_post, comentarioController);
                  comentarioController.clear();
                  updateComentarios();
                },
                child: const Text('Enviar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Lógica para cancelar el comentario
                  comentarioController.clear();
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Comentario>>(
            future: comentariosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final comentarios = snapshot.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final comentario = comentarios[index];
                    return ListTile(
                      title: Text(comentario.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comentario.mensaje),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('yyyy-MM-dd').format(comentario.fecha),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Editar comentario'),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Eliminar comentario'),
                            ),
                          ),
                        ],
                        onSelected: (String value) {
                          if (value == 'edit') {
                            // Lógica para editar el comentario
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditarComentarioScreen(com: comentario),
                            ));
                            // Puedes implementar una pantalla de edición de comentarios similar a la de edición de publicaciones
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmar eliminación"),
                                  content: const Text(
                                      "¿Estás seguro de que quieres eliminar este comentario?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteComment(comentario.id_com);
                                        Navigator.of(context).pop();
                                        updateComentarios();
                                      },
                                      child: const Text("Eliminar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _crearCom(int idPost, TextEditingController comentarioController) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/comentario/agregar');

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

    Map<String, dynamic> data = {
      "id_comentador": 1,
      "id_post": idPost,
      "nombre": 'Falcao Garcia',
      "mensaje": comentarioController.text,
      "valoracion": 0,
      "fecha": formattedDate,
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      print('Comentario publicado: ${response.body}');
    } else {
      print(
          'Error al publicar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  void _deletePost(int? id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3010'
        : 'http://localhost:3010';
    final String url = ('$urlDynamic/comentario/borrar-por-post/$id');
    final String url2 = ('$urlDynamic/post/borrar/$id');
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Comentarios eliminados: ${response.statusCode}');
      final response2 = await http.delete(Uri.parse(url2));
      if (response2.statusCode == 200) {
        print('Post eliminado: ${response2.statusCode}');
      } else {
        print(
            'Error al eliminar el post. Código de estado: ${response2.statusCode}');
      }
    } else {
      print(
          'Error al eliminar los comentarios del post. Código de estado: ${response.statusCode}');
    }
  }

  String _asignarValorCategoria(int? categoria) {
    switch (categoria) {
      case 1:
        return 'Programación';
      case 3:
        return 'Física Mecánica';
      case 2:
        return 'Cálculo Diferencial';
      default:
        return "NPI";
    }
  }
}
