//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de clase segun corresponde a la ruta de aprendizaje

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:JaveLab/models/contenido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:file_picker/file_picker.dart'; // Importa la librería para seleccionar archivos
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:JaveLab/models/comentariotema.dart';

class MyPantallaClase extends StatelessWidget {
  final Contenido contenido;
  final String pdfUrl;

  const MyPantallaClase(
      {Key? key, required this.contenido, required this.pdfUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2C5697),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF2C5697),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[500],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2C5697),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
      home: MyWidget(item: contenido, pdfUrl: pdfUrl),
    );
  }
}

class MyWidget extends StatelessWidget {
  final Contenido item;
  final String pdfUrl;

  const MyWidget({Key? key, required this.item, required this.pdfUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla clase', style: TextStyle(fontSize: 20)),
        actions: const [],
      ),
      bottomNavigationBar: BottomMenu(),
      endDrawer: BurgerMenu(),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Link del video tomado desde la BD
            YoutubeVideoPlayerWidget(videoUrl: item.video),
            TabBar(
              tabs: [
                Tab(text: 'Actividades'),
                Tab(text: 'Info de Clase'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  VideoTab(pdfUrl: pdfUrl, item: item),
                  ClassInfoTab(item: item),
                ],
              ),
            ),
            CourseProgressBar(
                progress:
                    0.6), // Cambia el valor según el progreso real del curso
          ],
        ),
      ),
    );
  }
}

class VideoTab extends StatelessWidget {
  final String pdfUrl;
  final Contenido item;

  const VideoTab({Key? key, required this.pdfUrl, required this.item})
      : super(key: key);

  Future<void> _downloadPDF(BuildContext context, String pdfUrl) async {
    final response = await http.get(Uri.parse(pdfUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Obtiene la ruta del directorio de descargas
      final downloadDir = await getExternalStorageDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.pdf'; // Nombre de archivo único

      // Guardar el archivo en el directorio de descargas
      final pdfFile =
          await File('${downloadDir!.path}/$fileName').writeAsBytes(bytes);

      // Abrir el archivo PDF
      OpenFile.open(pdfFile.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo descargar el PDF'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Descripción del documento adjunto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Este es un documento PDF que contiene información adicional sobre el tema del video. Puedes descargarlo y revisarlo para obtener más detalles.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _downloadPDF(context, pdfUrl),
              icon: const Icon(Icons.attach_file, size: 20),
              label:
                  const Text('Descargar PDF', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Características del documento adjunto:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '- Contiene información adicional sobre el tema del video.\n'
              '- Formato: PDF\n'
              '- Tamaño: 2.5 MB\n'
              '- Autor: Desconocido\n'
              '- Fecha de creación: 10/02/2024',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              //Comentarios (caja de comentarios)
              'Comentarios',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            CommentsSection(accentColor: Colors.black, item: item),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for next video navigation
              },
              icon: const Icon(Icons.navigate_next, size: 20),
              label: const Text('Siguiente capítulo',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

//Informacion de la clase
class ClassInfoTab extends StatelessWidget {
  final Contenido item;
  const ClassInfoTab({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de la Clase',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 10),
          // Agrega detalles de la clase de forma jerárquica y clara
          const Text(
            'Título de la Clase:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            item.titulo,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            'Descripción:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            item.descripcion,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

//Clase que implementa los videos para el import respectivo
class YoutubeVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoPlayerWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  _YoutubeVideoPlayerWidgetState createState() =>
      _YoutubeVideoPlayerWidgetState();
}

class _YoutubeVideoPlayerWidgetState extends State<YoutubeVideoPlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: const YoutubePlayerFlags(autoPlay: false, loop: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        _controller.addListener(() {});
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CommentsSection extends StatefulWidget {
  final Color accentColor;
  final Contenido item;

  const CommentsSection({
    Key? key,
    required this.accentColor,
    required this.item,
  }) : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  late Future<List<ComentarioTema>> comments;
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 4.0;

  @override
  void initState() {
    super.initState();
    comments = _fetchComments();
  }

  void updateComments() {
    setState(() {
      comments = _fetchComments();
    });
  }

  Future<List<ComentarioTema>> _fetchComments() async {
    try {
      String urlDynamic = Platform.isAndroid
          ? 'http://192.168.10.34:3011'
          : 'http://localhost:3011';
      final String url =
          ('$urlDynamic/comentariotema/lista-comentarios/${widget.item.id_contenido}');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<ComentarioTema> coms =
            postData.map((data) => ComentarioTema.fromJson(data)).toList();
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener comentarios: $error');
      return Future.value([]);
    }
  }

  void _deleteComment(int id) async {
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.10.34:3011'
        : 'http://localhost:3011';
    final String url = ('$urlDynamic/comentariotema/borrar/$id');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Comentario eliminado: ${response.statusCode}');
    } else {
      print(
          'Error al eliminar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  void _crearComs() async {
    if (_commentController.text.isNotEmpty) {
      String urlDynamic = Platform.isAndroid
          ? 'http://192.168.10.34:3011'
          : 'http://localhost:3011';
      final String url = ('$urlDynamic/comentariotema/agregar');

      String formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now().toLocal());

      Map<String, dynamic> data = {
        "id_comentador": 1,
        "id_tema": widget.item.id_contenido,
        "nombre": 'Falcao Garcia',
        "mensaje": _commentController.text,
        "valoracion": _currentRating.toInt(),
        "fecha": formattedDate,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Comentario publicado: ${response.body}');
        updateComments();
      } else {
        print(
            'Error al publicar el comentario. Código de estado: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Añade un comentario...',
                contentPadding: const EdgeInsets.all(12),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: widget.accentColor),
                  onPressed: _crearComs,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 20,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: widget.accentColor,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _currentRating = rating;
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<ComentarioTema>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: widget.accentColor,
                            child:
                                const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            comment.mensaje,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            "${comment.nombre}, ${DateFormat('dd/MM/yyyy').format(comment.fecha)} - ${comment.valoracion} stars",
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) {
                              if (value == 'edit') {
                                // Implementar la lógica para editar el comentario
                              } else if (value == 'delete') {
                                _deleteComment(comment.id_com);
                                updateComments();
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Editar'),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Eliminar'),
                                ),
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
          ),
        ],
      ),
    );
  }
}

class CourseProgressBar extends StatelessWidget {
  final double progress; //

  const CourseProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[300],
      ),
      child: Row(
        children: [
          Text(
            'Progreso: ${(progress * 100).toInt()}%',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 16,
            width: MediaQuery.of(context).size.width * progress,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blue, // Color de la barra de progreso
            ),
          ),
        ],
      ),
    );
  }
}
