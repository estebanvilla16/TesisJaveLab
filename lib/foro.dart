import 'package:JaveLab/crear_post.dart';
import 'package:JaveLab/models/post.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:JaveLab/pages/ver_post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Cara6(),
    );
  }
}

class Cara6 extends StatelessWidget {
  const Cara6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF2c5968);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro | Academico'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Foro',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Categorías',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 280.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 10.0),
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Busque un post...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            SectionWidget(
              title: 'Calculo Diferencial',
              description: '5 posts',
              backgroundColor: primaryColor,
              icon: Icons.calculate,
              category: 2, // Icono relacionado
            ),
            SectionWidget(
              title: 'Física Mecánica',
              description: '5 posts',
              backgroundColor: primaryColor,
              icon: Icons.build,
              category: 3, // Icono relacionado
            ),
            SectionWidget(
              title: 'Programacion I',
              description: '5 posts',
              backgroundColor: primaryColor,
              icon: Icons.code,
              category: 1, // Icono relacionado
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Cara8(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: const Text(
                    'Nuevo Post',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: const Text(
                    'Intercambio',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class SectionWidget extends StatefulWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final IconData icon; // Icono relacionado
  final int category; // Agrega un atributo para la categoría

  const SectionWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.icon, // Icono relacionado
    required this.category, // Categoría requerida para la llamada a _fetchPosts
  }) : super(key: key);

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon,
                  color: _isExpanded
                      ? Colors.white
                      : Colors.black), // Icono relacionado
              const SizedBox(width: 8.0),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: _isExpanded ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Text(
            widget.description,
            style: TextStyle(
              fontSize: 20.0,
              color: _isExpanded ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: widget.backgroundColor,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: [
        if (_isExpanded)
          FutureBuilder<List<Post>>(
            future: _fetchPosts(
                widget.category), // Utiliza el futuro de la lista de posts
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // Construye la lista de ListTile utilizando la lista de posts obtenida
                print(snapshot.data);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.map((post) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              post.titulo,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              // Agregar lógica para acceder al post
                              int? id = post.id_post;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PostViewScreen(id: id)));
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostViewScreen(post: post),
                                ),
                              );*/
                            },
                          ),
                        ],
                      ),
                      subtitle:
                          Text('Fecha: ${post.fecha}, Persona: ${post.nombre}'),
                    );
                  }).toList(),
                );
              }
            },
          ),
      ],
    );
  }
}

Future<List<Post>> _fetchPosts(int cat) async {
  try {
    // Realiza una solicitud HTTP GET para obtener la lista de Posts
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3010'
        : 'http://localhost:3010';
    final String url = ('${urlDynamic}/post/lista-posts/${cat}');
    final response = await http.get(Uri.parse(url));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Convierte la respuesta JSON en una lista de mapas
      final List<dynamic> postData = jsonDecode(response.body);
      // Crea una lista de Posts a partir de los datos obtenidos
      final List<Post> posts =
          postData.map((data) => Post.fromJson(data)).toList();
      // Ahora tienes la lista de Posts, puedes usarla según necesites
      return posts;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    // Si ocurrió un error durante la solicitud, imprímelo
    return Future.value([]);
  }
}
