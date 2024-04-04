//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de post
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
        ),
      ),
      home: const PostPage(),
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final Post post = Post(
    //header del post con la info del usuario que hace el post
    userName: 'Nombre Estudiante',
    role: 'Estudiante',
    userProfilePic: 'https://fg.ull.es/idiomas/wp-content/uploads/sites/13/2022/07/male-user-profile-picture-1-240x240-compressor-150x150-1-1.png',
    content: 'Este es el contenido del post, puede ser bastante extenso y diseñado para imitar el estilo y la funcionalidad de un foro moderno como el de Platzi.',
    attachments: ['https://via.placeholder.com/400x300'],
    postDate: DateTime.now(),
    comments: [
      Comment(userName: 'Comentarista 1', userComment: '¡Gran post!', rating: 5),
      Comment(userName: 'Comentarista 2', userComment: 'Muy informativo, gracias.', rating: 4),
    ],
  );

  final TextEditingController _commentController = TextEditingController();
  int _userRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.isNotEmpty && _userRating != 0) {
      setState(() {
        post.comments.add(Comment(userName: 'Nuevo Usuario', userComment: _commentController.text, rating: _userRating));
        _commentController.clear();
        _userRating = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles Post - [NombrePost]' , style: TextStyle(color: Colors.blue))),
      bottomNavigationBar: const BottomMenu(), //Menu inferior
      endDrawer: const BurgerMenu(), //Menu hamburguesa
      body: SingleChildScrollView(
        child: Column( //seleccion de feedback star 1 a 5
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(post: post),
            const ToolBar(),
            PostContent(content: post.content),
            PostAttachments(attachments: post.attachments),
            const Divider(),
            PostComments(comments: post.comments),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _commentController, //Caja de comentarios
                    decoration: const InputDecoration(hintText: 'Escribe un comentario...', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 8),
                  RatingBar(
                    initialRating: _userRating,
                    onRatingChanged: (rating) {
                      setState(() {
                        _userRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _submitComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5697),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Enviar Comentario', style: TextStyle(color: Colors.white)),
                  ),

                  const SizedBox(height: 20), //Sugerencia de post relacionados
                  Text("Posts Sugeridos", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 160,
                          child: Card(
                            child: Wrap(
                              children: [
                                Image.network("https://via.placeholder.com/150"),
                                ListTile(
                                  title: Text("Post ${index + 1}"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.report, color: Colors.red), onPressed: () {}),
          IconButton(icon: const Icon(Icons.thumb_up, color: Colors.green), onPressed: () {}),
          IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.blue), onPressed: () {}),
          IconButton(icon: const Icon(Icons.security, color: Colors.amber), onPressed: () {}),
        ],
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  final Post post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(post.userProfilePic)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(post.role, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
              ],
            ),
          ),
          Text('${post.postDate.year}-${post.postDate.month}-${post.postDate.day}', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class PostContent extends StatelessWidget {
  final String content;

  const PostContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(content));
  }
}

class PostAttachments extends StatelessWidget {
  final List<String> attachments;

  const PostAttachments({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Column(children: attachments.map((url) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.network(url),
    )).toList());
  }
}

class PostComments extends StatelessWidget {
  final List<Comment> comments;

  const PostComments({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: comments.map((comment) => ListTile(
        title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(comment.userComment),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(Icons.star, color: index < comment.rating ? Colors.amber : Colors.grey, size: 20);
          }),
        ),
      )).toList(),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int initialRating;
  final Function(int) onRatingChanged;

  const RatingBar({super.key, required this.initialRating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(index < initialRating ? Icons.star : Icons.star_border),
          color: Colors.amber,
          onPressed: () => onRatingChanged(index + 1),
        );
      }),
    );
  }
}

class Post {
  final String userName;
  final String role;
  final String userProfilePic;
  final String content;
  final List<String> attachments;
  final DateTime postDate;
  final List<Comment> comments;

  Post({required this.userName, required this.role, required this.userProfilePic, required this.content, required this.attachments, required this.postDate, required this.comments});
}

class Comment {
  final String userName;
  final String userComment;
  final int rating;

  Comment({required this.userName, required this.userComment, required this.rating});
}
