import 'package:JaveLab/models/comentario.dart';
import 'package:JaveLab/models/post.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/pages/perfil_user.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:JaveLab/pages/editar_post.dart';
import 'package:JaveLab/pages/foro.dart';
import 'package:JaveLab/pages/modificar_com.dart';
import 'package:JaveLab/global/enviroment.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isLiked = false;
  bool isDisliked = false;
  bool isFavorited = false;
  int likes = 0;
  int dislikes = 0;

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
      final String url = ('${Environment.foroUrl}/comentario/lista-comentarios/$idPost');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<Comentario> coms = postData.map((data) => Comentario.fromJson(data)).toList();
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      return Future.value([]);
    }
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        isDisliked = false;
        likes++;
        dislikes = dislikes > 0 ? dislikes - 1 : 0;
      } else {
        likes--;
      }
    });
  }

  void _toggleDislike() {
    setState(() {
      isDisliked = !isDisliked;
      if (isDisliked) {
        isLiked = false;
        dislikes++;
        likes = likes > 0 ? likes - 1 : 0;
      } else {
        dislikes--;
      }
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
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
              user: user,
              isLiked: isLiked,
              isDisliked: isDisliked,
              isFavorited: isFavorited,
              toggleLike: _toggleLike,
              toggleDislike: _toggleDislike,
              toggleFavorite: _toggleFavorite,
              likes: likes,
              dislikes: dislikes,
            );
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
  final bool isLiked;
  final bool isDisliked;
  final bool isFavorited;
  final VoidCallback toggleLike;
  final VoidCallback toggleDislike;
  final VoidCallback toggleFavorite;
  final int likes;
  final int dislikes;

  const PostView({
    Key? key,
    required this.post,
    required this.comentarioController,
    required this.comentariosFuture,
    required this.updateComentarios,
    required this.user,
    required this.isLiked,
    required this.isDisliked,
    required this.isFavorited,
    required this.toggleLike,
    required this.toggleDislike,
    required this.toggleFavorite,
    required this.likes,
    required this.dislikes,
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
      print('Error al eliminar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  String formatContent(String rawContent) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
         
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.titulo,
                      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                          fontSize: 18.0,
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
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Categoría',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _asignarValorCategoria(widget.post.etiqueta),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 20),
                    if (widget.post.material != "null")
                      ElevatedButton.icon(
                        onPressed: () => _downloadPDF(widget.post.material, context),
                        icon: const Icon(Icons.attach_file, size: 20),
                        label: const Text('Descargar archivo', style: TextStyle(fontSize: 16)),
                      ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up,
                              color: widget.isLiked ? Colors.blue : Colors.grey),
                          onPressed: widget.toggleLike,
                        ),
                        Text('${widget.likes}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.thumb_down,
                              color: widget.isDisliked ? Colors.red : Colors.grey),
                          onPressed: widget.toggleDislike,
                        ),
                        Text('${widget.dislikes}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.favorite,
                              color: widget.isFavorited ? Colors.red : Colors.grey),
                          onPressed: widget.toggleFavorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Contenido del Post',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            formatContent(widget.post.contenido),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 20),
          const Text(
            'Comentarios',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCommentInput(),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
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
              _crearCom(widget.post.id_post, widget.comentarioController, widget.user, _file);
              widget.comentarioController.clear();
              widget.updateComentarios();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("¡Comentario publicado!"),
                ),
              );
            },
            child: const Text('Publicar comentario'),
          ),
          const SizedBox(height: 10),
          _buildCommentList(),
          const SizedBox(height: 20),
          const Text(
            'Posts Recomendados',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildRecommendedPosts(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
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
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  String? filePath = result.files.single.path;
                  if (filePath != null) {
                    setState(() {
                      _file = File(filePath);
                    });
                  }
                }
              },
              child: const Icon(Icons.attach_file),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_file != null)
          Container(
            width: 300,
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
      ],
    );
  }

  Widget _buildCommentList() {
    return FutureBuilder<List<Comentario>>(
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
              return _buildCommentItem(comentario);
            },
          );
        }
      },
    );
  }

  Widget _buildCommentItem(Comentario comentario) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
    
        ),
        title: Text(comentario.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('yyyy-MM-dd').format(comentario.fecha)),
            const SizedBox(height: 4.0),
            Text(comentario.mensaje),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (comentario.material != "null" && comentario.material != null)
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {
                  String mat = comentario.material!;
                  _downloadPDF(mat, context);
                },
              ),
            if (widget.user.uid == comentario.id_comentador)
              PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditarComentarioScreen(com: comentario),
                    ));
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: const Text("¿Estás seguro de que quieres eliminar este comentario?"),
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
  }

  List<Widget> _buildTagWidgets(String? tags) {
    if (tags == null || tags.isEmpty) {
      return [];
    }

    List<String> tagList = tags.split(',');

    return tagList.map((tag) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey[300],
        ),
        child: Text(
          tag.trim(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14.0),
        ),
      );
    }).toList();
  }

  String getFileNameWithId(String filePath, int id) {
    String fileName = path.basename(filePath);
    String extension = path.extension(fileName);
    String fileNameWithoutExtension = path.basenameWithoutExtension(fileName);
    return '$fileNameWithoutExtension - $id$extension';
  }

  Future<void> _uploadFile(File file, int id) async {
    try {
      String fileName = getFileNameWithId(file.path, id);
      final url = '${Environment.blobUrl}/api/blob/upload/foro';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      var modifiedFile = http.MultipartFile(
        'file',
        file.openRead(),
        file.lengthSync(),
        filename: fileName,
      );
      request.files.add(modifiedFile);
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Archivo subido exitosamente');
        _modificarCom(fileName, id);
      } else {
        print('Error al subir el archivo. Código de estado: ${response.statusCode}');
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
    final response = await http.put(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    if (response.statusCode == 200) {
      print('Comentario modificado: ${response.body}');
    } else {
      print('Error al modificar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> _downloadPDF(String nombre, BuildContext context) async {
    String url = ('${Environment.blobUrl}/api/blob/downloadForo/$nombre');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final downloadDir = await getExternalStorageDirectory();
      final file = await File('${downloadDir!.path}/$nombre').writeAsBytes(bytes);
      OpenFile.open(file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo descargar el PDF'),
        ),
      );
    }
  }

  void _crearCom(int idPost, TextEditingController comentarioController, Usuario user, File? file) async {
    final String url = ('${Environment.foroUrl}/comentario/agregar');
    String userId = user.uid;
    String nombreCompleto = '${user.nombre} ${user.apellido}';
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());
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
      print('Error al publicar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  void _deletePost(int? id) async {
    final String url = ('${Environment.foroUrl}/comentario/borrar-por-post/$id');
    final String url2 = ('${Environment.foroUrl}/post/borrar/$id');
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Comentarios eliminados: ${response.statusCode}');
      final response2 = await http.delete(Uri.parse(url2));
      if (response2.statusCode == 200) {
        print('Post eliminado: ${response2.statusCode}');
      } else {
        print('Error al eliminar el post. Código de estado: ${response2.statusCode}');
      }
    } else {
      print('Error al eliminar los comentarios del post. Código de estado: ${response.statusCode}');
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

  Widget _buildRecommendedPosts() {
    final List<Post> recommendedPosts = [
      Post(
        id_post: 1,
        id_op: '1',
        nombre: 'Autor Ejemplo 1',
        titulo: 'Post Ejemplo 1',
        contenido: 'Contenido breve del post 1...',
        fecha: DateTime.now(),
        etiqueta: 1,
        tags: 'Tag1, Tag2',
        material: 'null',
        video: 'null',
        valoracion: 0,
      ),
      Post(
        id_post: 2,
        id_op: '2',
        nombre: 'Autor Ejemplo 2',
        titulo: 'Post Ejemplo 2',
        contenido: 'Contenido breve del post 2...',
        fecha: DateTime.now(),
        etiqueta: 2,
        tags: 'Tag1, Tag3',
        material: 'null',
        video: 'null',
        valoracion: 0,
      ),
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      items: recommendedPosts.map((post) {
        return Builder(
          builder: (BuildContext context) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    Text('Autor: ${post.nombre}'),
                    const SizedBox(height: 8.0),
                    Text(post.contenido),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navegar al detalle del post
                        },
                        child: const Text('Ver más', style: TextStyle(color: Colors.lightBlue)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
