//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de clase segun corresponde a la ruta de aprendizaje

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:file_picker/file_picker.dart'; // Importa la librería para seleccionar archivos
import 'widgets/bottom_menu.dart';
import 'widgets/burgermenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            foregroundColor: Colors.white, backgroundColor: const Color(0xFF2C5697),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Pantalla clase', style: TextStyle(fontSize: 20)),
        actions: const [],

      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: const DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Link del video tomado desde la BD
            YoutubeVideoPlayerWidget(videoUrl: 'https://www.youtube.com/watch?v=bo9Z_pgByQY'),
            TabBar(
              tabs: [
                Tab(text: 'Actividades'),
                Tab(text: 'Info de Clase'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  VideoTab(),
                  ClassInfoTab(),
                ],
              ),
            ),
            CourseProgressBar(progress: 0.6), // Cambia el valor según el progreso real del curso
          ],
        ),
      ),
    );
  }
}

class VideoTab extends StatelessWidget {
  const VideoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

            ),

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
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom, // Puedes especificar el tipo de archivo que deseas permitir
                  allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'], // Extensiones permitidas
                );

                if (result != null) {
                  PlatformFile file = result.files.first;
                  // Aquí puedes manejar el archivo seleccionado, por ejemplo, mostrar su nombre o realizar alguna acción con él.
                  print('Archivo seleccionado: ${file.name}');
                }
              },
              icon: const Icon(Icons.attach_file, size: 20),
              label: const Text('Adjuntar archivo', style: TextStyle(fontSize: 16)),
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
            const Text( //Comentarios (caja de comentarios)
              'Comentarios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const CommentsSection(accentColor: Colors.black),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder for next video navigation
              },
              icon: const Icon(Icons.navigate_next, size: 20),
              label: const Text('Siguiente capítulo', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
//Informacion de la clase
class ClassInfoTab extends StatelessWidget {
  const ClassInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información de la Clase',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          // Agrega detalles de la clase de forma jerárquica y clara
          Text(
            'Título de la Clase:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Clase 1',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Descripción:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'En esta clase, aprenderás ...',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Instructor:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Profesor Juan Pérez',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Duración:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '4 semanas',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Fecha de Inicio:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '15 de Febrero de 2024',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
//Clase que implementa los videos para el import respectivo
class YoutubeVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _YoutubeVideoPlayerWidgetState createState() => _YoutubeVideoPlayerWidgetState();
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

  const CommentsSection({super.key, required this.accentColor});

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 4.0;

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      final newComment = Comment(
        userName: "Usuario ${comments.length + 1}",
        comment: _commentController.text,
        dateTime: DateTime.now(),
        rating: _currentRating,
      );
      setState(() {
        comments.add(newComment);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onPressed: _addComment,
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
          itemSize: 20, // Ajusta el tamaño de las estrellas
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
        ...comments.map((comment) => Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.accentColor,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              comment.comment,
              style: const TextStyle(fontSize: 16),
            ),
            subtitle: Text(
              "${comment.userName}, ${DateFormat('dd/MM/yyyy').format(comment.dateTime)} - ${comment.rating.toStringAsFixed(1)} stars",
              style: const TextStyle(fontSize: 12),
            ),
          ),
        )),
      ],
    );
  }
}

class Comment {
  String userName;
  String comment;
  DateTime dateTime;
  double rating;

  Comment({required this.userName, required this.comment, required this.dateTime, required this.rating});
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
