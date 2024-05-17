import 'package:JaveLab/models/comentario.dart';
import 'package:JaveLab/models/post.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/pages/perfil_user.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:JaveLab/pages/editar_post.dart';
import 'package:JaveLab/pages/foro.dart';
import 'package:JaveLab/pages/modificar_com.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:JaveLab/global/enviroment.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:JaveLab/widgets/trending.dart';


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
  late Usuario user;

  @override
  void initState() {
    super.initState();
    _postFuture = _fetchPost(widget.id);
    _comentariosFuture = _fetchComs(widget.id!);
    final authService = Provider.of<AuthService>(context, listen: false);
    user = authService.usuario;
  }

  void updateComentarios() {
    setState(() {
      _comentariosFuture = _fetchComs(widget.id!);
    });
  }

  Future<Post> _fetchPost(int? id) async {
    final String url = ('${Environment.foroUrl}/post/$id');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Comentario>> _fetchComs(int idPost) async {
    try {
      final String url =
          ('${Environment.foroUrl}/comentario/lista-comentarios/$idPost');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<Comentario> coms =
            postData.map((data) => Comentario.fromJson(data)).toList();
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
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
                updateComentarios: updateComentarios,
                user: user);
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
  final Usuario user;

  const PostView(
      {Key? key,
      required this.post,
      required this.comentarioController,
      required this.comentariosFuture,
      required this.updateComentarios,
      required this.user})
      : super(key: key);

  void _deleteComment(int id) async {
    final String url = ('${Environment.foroUrl}/comentario/borrar/$id');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Comentario eliminado: ${response.statusCode}');
    } else {
      print(
          'Error al eliminar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  String formatContent(String rawContent) {
    // Reemplazar '\n' con saltos de línea visuales
    return rawContent.replaceAll(r'\n', '\n');
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.titulo,
                        style: const TextStyle(fontSize: 38.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfileUserPage(uidHost: post.id_op),
                          ));
                        },
                        child: Text(
                          post.nombre,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: _buildTagWidgets(post.tags),
                      ),
                      Text(
                        'Fecha: ${DateFormat('yyyy-MM-dd').format(post.fecha)}',
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
                      Text(
                        _asignarValorCategoria(post.etiqueta),
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(width: 20), // Espacio entre el contenido y el TrendingChart
                TrendingChart(
                  score: 10, // Puedes ajustar estos valores según lo que desees mostrar
                  isUpvoted: true,
                  isDownvoted: false,
                  upvotes: [3, 5, 2, 7, 4],
                  downvotes: [1, 0, 2, 1, 3],
                  onUpvotePressed: () {
                    // Lógica cuando se presiona el botón de upvote
                  },
                  onDownvotePressed: () {
                    // Lógica cuando se presiona el botón de downvote
                  },
                ),
              ],
            ),
          
          const SizedBox(height: 20),
          if (post.material != "null")
            ElevatedButton.icon(
              onPressed: () => _downloadPDF(post.material, context),
              icon: const Icon(Icons.attach_file, size: 20),
              label: const Text('Descargar archivo',
                  style: TextStyle(fontSize: 16)),
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
          Text(
            formatContent(post.contenido),
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
                onPressed: () async {
                  // Lógica para enviar el comentario
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircularProgressIndicator(),
                          Text("Publicando comentario..."),
                        ],
                      ),
                    ),
                  );
                  _crearCom(post.id_post, comentarioController, user);
                  comentarioController.clear();
                  updateComentarios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Comentario publicado!"),
                    ),
                  );
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
                      title: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfileUserPage(
                                uidHost: comentario.id_comentador),
                          ));
                        },
                        child: Text(
                          comentario.nombre,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
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
                          if (comentario.id_comentador ==
                              user.uid) // Control de acceso para editar y borrar comentario
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Editar comentario'),
                              ),
                            ),
                          if (comentario.id_comentador ==
                              user.uid) // Control de acceso para editar y borrar comentario
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete),
                                title: Text('Eliminar comentario'),
                              ),
                            ),
                        ].where((item) => item != null).toList(),
                        onSelected: (String value) {
                          if (value == 'edit') {
                            // Lógica para editar el comentario
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditarComentarioScreen(com: comentario),
                            ));
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

  List<Widget> _buildTagWidgets(String? tags) {
    if (tags == null || tags.isEmpty) {
      return [];
    }

    List<String> tagList = tags.split(',');

    return tagList.map((tag) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.lightBlue,
        ),
        child: Text(
          tag.trim(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      );
    }).toList();
  }

  Future<void> _downloadPDF(String nombre, BuildContext context) async {
    String url = ('${Environment.blobUrl}/api/blob/downloadForo/$nombre');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Obtiene la ruta del directorio de descargas
      final downloadDir = await getExternalStorageDirectory();
      final file =
          await File('${downloadDir!.path}/$nombre').writeAsBytes(bytes);

      // Abrir el archivo PDF
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo descargar el PDF'),
        ),
      );
    }
  }

  void _crearCom(int idPost, TextEditingController comentarioController,
      Usuario user) async {
    final String url = ('${Environment.foroUrl}/comentario/agregar');

    String userId = user.uid;
    String nombreCompleto = '${user.nombre} ${user.apellido}';

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

    Map<String, dynamic> data = {
      "id_comentador": userId,
      "id_post": idPost,
      "nombre": nombreCompleto,
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
    final String url =
        ('${Environment.foroUrl}/comentario/borrar-por-post/$id');
    final String url2 = ('${Environment.foroUrl}/post/borrar/$id');
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
