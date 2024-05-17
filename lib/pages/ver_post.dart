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
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;


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

class PostView extends StatefulWidget {
  final Post post;
  final TextEditingController comentarioController;
  final Future<List<Comentario>> comentariosFuture;
  final VoidCallback updateComentarios;
  final Usuario user;

  const PostView({
    Key? key,
    required this.post,
    required this.comentarioController,
    required this.comentariosFuture,
    required this.updateComentarios,
    required this.user,
  }) : super(key: key);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> { 

  File? _file;

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
                        widget.post.titulo,
                        style: const TextStyle(fontSize: 38.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProfileUserPage(uidHost: widget.post.id_op),
                          ));
                        },
                        child: Text(
                          widget.post.nombre,
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
                        children: _buildTagWidgets(widget.post.tags),
                      ),
                      Text(
                        'Fecha: ${DateFormat('yyyy-MM-dd').format(widget.post.fecha)}',
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
                        _asignarValorCategoria(widget.post.etiqueta),
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
          if (widget.post.material != "null")
            ElevatedButton.icon(
              onPressed: () => _downloadPDF(widget.post.material, context),
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
            formatContent(widget.post.contenido),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // Ancho específico para el TextField
                child: TextField(
                  controller: widget.comentarioController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un comentario...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    String? filePath = result.files.single.path;
                    if (filePath != null) {
                      setState(() {
                        _file = File(filePath);
                      });
                    }
                  }
                },
                child: const Text('->'),
              ),
            ],
          ),
          if (_file != null)
            Container(
              width: 300, // Ancho específico para el ListTile
              height: 50,
              child: ListTile(
                title: Text('Archivo Adjunto: ${_file!.path}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _file = null;
                    });
                  },
                ),
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
                  _crearCom(widget.post.id_post, widget.comentarioController,
                  widget.user, _file);
              widget.comentarioController.clear();
              widget.updateComentarios();
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
                  widget.comentarioController.clear();
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Comentario>>(
            future: widget.comentariosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final comentarios = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    final comentario = comentarios[index];
                    return Card(
                      child: ListTile(
                        title: Text(comentario.mensaje),
                        subtitle: Text(comentario.fecha.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (comentario.material != "null" &&
                                comentario.material != null)
                              ElevatedButton.icon(
                                onPressed: () {
                                  String mat = comentario.material!;
                                  _downloadPDF(mat, context);
                                },
                                icon: const Icon(Icons.attach_file, size: 20),
                                label: const Text('',
                                    style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            if (widget.user.uid == comentario.id_comentador)
                              PopupMenuButton<String>(
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditarComentarioScreen(
                                              com: comentario),
                                    ));
                                  } else if (value == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Confirmar eliminación"),
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
                                                _deleteComment(
                                                    comentario.id_com);
                                                Navigator.of(context).pop();
                                                widget.updateComentarios();
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

String getFileNameWithId(String filePath, int id) {
    String fileName =
        path.basename(filePath); // Obtiene el nombre del archivo con extensión
    String extension =
        path.extension(fileName); // Obtiene la extensión del archivo
    String fileNameWithoutExtension = path.basenameWithoutExtension(
        fileName); // Obtiene el nombre del archivo sin extensión

    // Concatena el nombre del archivo sin extensión, el ID y la extensión
    return '$fileNameWithoutExtension - $id$extension';
  }

  Future<void> _uploadFile(File file, int id) async {
    try {
      String fileName = getFileNameWithId(file.path, id);
      final url = '${Environment.blobUrl}/api/blob/upload/foro';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Crea un nuevo archivo con el nombre modificado
      var modifiedFile = http.MultipartFile(
        'file',
        file.openRead(),
        file.lengthSync(),
        filename: fileName, // Usa el nuevo nombre del archivo
      );

      // Agrega el archivo modificado a la solicitud
      request.files.add(modifiedFile);

      // Envía la solicitud y espera la respuesta
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo subido exitosamente');
        _modificarCom(fileName, id);
        // Aquí puedes manejar la lógica después de subir el archivo
      } else {
        print(
            'Error al subir el archivo. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

void _modificarCom(String nuevoMaterial, int id) async {
    final String url = ('${Environment.foroUrl}/comentario/actualizar/$id');

    Map<String, dynamic> data = {
      "material": nuevoMaterial,
    };

    print(data);

    final response = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Comentario modificado: ${response.body}');
    } else {
      print(
          'Error al modificar el comentario. Código de estado: ${response.statusCode}');
    }
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
      Usuario user, File? file) async {
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
      "material": "null",
    };

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      print('Comentario publicado: ${response.body}');
      int comId = jsonDecode(response.body)['id_com'];
      if (file != null) {
        _uploadFile(_file!, comId);
      }
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
