import 'dart:io';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/ruta.dart';
import 'package:JaveLab/models/tema.dart';
import 'package:JaveLab/models/userxmateria.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/pages/ver_post.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:JaveLab/models/contenido.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JaveLab/pages/pantalla_clase.dart';
import 'package:provider/provider.dart';
import 'package:JaveLab/models/post.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final List<bool> _viewed = List.generate(15, (_) => false);
  List<Contenido> carouselItems = [];
  List<Tema> _carouselItems = [];
  late Usuario user;
  late Future<List<Ruta>> rutas;
  late Future<List<Tema>> temas1;
  late Future<List<Tema>> temas2;
  late Future<List<Tema>> temas3;
  late List<Future<List<Tema>>> temasFutures;
  late List<Post> recentPosts = [];

  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    user = authService.usuario;
    _fetchRecentPosts();
    rutas = _fetchRutas(user.uid);

    rutas.then((userRoutes) {
      setState(() {
        temasFutures =
            userRoutes.map((ruta) => _fetchTemas(ruta.id_ruta)).toList();
      });
    }).catchError((error) {
      print('Error al obtener rutas: $error');
    });
  }

  Future<void> _fetchRecentPosts() async {
    try {
      final String url = '${Environment.foroUrl}/post/lista-posts';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<Post> posts =
            postData.map((data) => Post.fromJson(data)).toList();

        // Ordenar los posts por fecha de forma descendente (más reciente primero)
        posts.sort((a, b) => b.fecha.compareTo(a.fecha));

        // Obtener los 5 posts más recientes
        setState(() {
          recentPosts = posts.take(5).toList();
        });
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener los posts: $error');
    }
  }

  void _markAsViewed(int carouselIndex, int itemIndex) {
    setState(() {
      _viewed[carouselIndex * 5 + itemIndex] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JAVELAB', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        titleTextStyle:const TextStyle (color:Colors.white, fontSize: 30,),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icon/icon.png'),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const BottomMenu(), //Menu inferior
      endDrawer: const BurgerMenu(), // Menu Hamburguesa
      body: FutureBuilder<List<Ruta>>(
        future: rutas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error al cargar las rutas'));
          }

          final List<Ruta> userRoutes = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < userRoutes.length; i++)
                  FutureBuilder<List<Tema>>(
                    future: temasFutures[i],
                    builder: (context, temasSnapshot) {
                      if (temasSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (temasSnapshot.hasError ||
                          temasSnapshot.data == null) {
                        return const Center(
                            child: Text('Error al cargar los temas'));
                      }

                      final List<Tema> temas = temasSnapshot.data!;

                      return FutureBuilder<String>(
                        future: getCarouselTitle(userRoutes[i].id_user_mat),
                        builder: (context, titleSnapshot) {
                          if (titleSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CarouselSection(
                              title:
                                  'Cargando...', // Muestra un mensaje mientras se espera la respuesta
                              items: _buildCarouselItemsList(temas, i),
                              onItemTap: _markAsViewed,
                            );
                          }
                          if (titleSnapshot.hasError) {
                            return CarouselSection(
                              title:
                                  'Error: ${titleSnapshot.error}', // Muestra un mensaje de error si la solicitud falla
                              items: _buildCarouselItemsList(temas, i),
                              onItemTap: _markAsViewed,
                            );
                          }

                          // Si la solicitud se completó correctamente, utiliza el valor devuelto
                          final String carouselTitle =
                              titleSnapshot.data ?? 'Título predeterminado';

                          return CarouselSection(
                            title: carouselTitle,
                            items: _buildCarouselItemsList(temas, i),
                            onItemTap: _markAsViewed,
                          );
                        },
                      );
                    },
                  ),
                CarouselSection(
                  title: 'Publicaciones Recientes',
                  items: _buildRecentPostsCarouselItems(),
                  onItemTap: _markAsViewed,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCarouselItems(int carouselIndex) {
    return List<Widget>.generate(
      5,
      (int itemIndex) => GestureDetector(
        onTap: () => _markAsViewed(carouselIndex, itemIndex),
        child: Card(
          color: _viewed[carouselIndex * 5 + itemIndex]
              ? Colors.grey
              : Colors.white,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Text('Elemento ${itemIndex + 1}',
                style: const TextStyle(fontSize: 16.0)),
          ),
        ),
      ),
    );
  }

  String formatContent(String rawContent) {
    // Reemplazar '\n' con saltos de línea visuales
    return rawContent.replaceAll(r'\n', '\n');
  }

  List<Widget> _buildRecentPostsCarouselItems() {
    return recentPosts.map((post) {
      String nuevo = formatContent(post.contenido);
      List<String> lines = nuevo.split('\n');
      String firstLine =
          lines.firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
      String limitedContent = firstLine.length > 35
          ? firstLine.substring(0, 35) + '...'
          : firstLine;

      return GestureDetector(
        onTap: () => _navigateToPostScreen(context, post.id_post),
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.titulo, style: const TextStyle(fontSize: 30.0)),
                      Text(post.nombre),
                      const SizedBox(height: 16.0),
                      Text(limitedContent),
                      // Agrega más Widgets según sea necesario para mostrar otros datos del Post
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildCarouselItemsList(List<Tema> dataList, int carouselIndex) {
    return dataList.asMap().entries.map((entry) {
      final int itemIndex = entry.key;
      final Tema item = entry.value;
      String limitedTitle = item.titulo.length > 35
          ? item.titulo.substring(0, 35) + '...'
          : item.titulo;

      return GestureDetector(
        onTap: () => _navigateToDetailScreen(context, item),
        child: Card(
          color: _viewed[carouselIndex * 5 + itemIndex]
              ? Colors.grey
              : Colors.white,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget para mostrar la imagen
                Image.asset(
                  'assets/imgs/${item.foto}.png',
                  width: 150, // Ancho deseado de la imagen (ajustable)
                  height: 150, // Alto deseado de la imagen (ajustable)
                  fit: BoxFit
                      .contain, // Ajuste de la imagen dentro del contenedor
                ),
                const SizedBox(width: 16), // Espacio entre la imagen y el texto

                // Widget para mostrar el título y el estado
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(limitedTitle,
                          style: const TextStyle(fontSize: 16.0)),
                      Text(item.estado),
                      // Agregar más Widgets según sea necesario para mostrar otros datos de Contenido
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

Future<String> getCarouselTitle(int rutaId) async {
  String url = '${Environment.academicUrl}/userxmateria/$rutaId';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final UserxMateria xmat = UserxMateria.fromJson(jsonDecode(response.body));
    if (xmat.materia == 1) {
      return 'Introducción a la Programación';
    } else if (xmat.materia == 2) {
      return 'Física Mecánica';
    } else if (xmat.materia == 3) {
      return 'Cálculo Diferencial';
    } else {
      return 'Título predeterminado';
    }
  } else {
    return 'Título predeterminado';
  }
}

Future<void> _navigateToDetailScreen(BuildContext context, Tema item1) async {
  String contenidoUrl =
      ('${Environment.academicUrl}/contenido/${item1.contenido}');
  final responseCont = await http.get(Uri.parse(contenidoUrl));
  if (responseCont.statusCode == 200) {
    final Contenido item = Contenido.fromJson(jsonDecode(responseCont.body));
    String pdfUrl = '${Environment.blobUrl}/api/blob/download/${item.material}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MyPantallaClase(contenido: item, pdfUrl: pdfUrl),
      ),
    );
  } else {
    return;
  }
}

Future<void> _navigateToPostScreen(BuildContext context, int id) async {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PostViewScreen(id: id)));
}

class CarouselSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Function(int, int) onItemTap;

  const CarouselSection({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ),
          CarouselSlider(
            items: items,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              initialPage: 2,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<Ruta>> _fetchRutas(String cat) async {
  try {
    final String url =
        ('${Environment.academicUrl}/userxmateria/lista-relaciones/${cat}');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> postData = jsonDecode(response.body);
      final List<UserxMateria> relaciones =
          postData.map((data) => UserxMateria.fromJson(data)).toList();
      List<Ruta> rutas = [];
      for (final relacion in relaciones) {
        final String url2 =
            ('${Environment.academicUrl}/ruta/ruta-user/${relacion.id_user_mat}');
        final responseRuta = await http.get(Uri.parse(url2));
        if (responseRuta.statusCode == 200) {
          // Verificar que la solicitud fue exitosa
          Ruta ruta = Ruta.fromJson(jsonDecode(responseRuta.body));
          // Añadir la ruta a la lista
          rutas.add(ruta);
        } else {
          print(
              'Error al obtener la ruta del usuario. Código de estado: ${responseRuta.statusCode}');
          // Manejar el error según sea necesario
        }
      }
      return rutas;
    } else {
      return Future.value([]);
    }
  } catch (error) {
    // Si ocurrió un error durante la solicitud, imprímelo
    return Future.value([]);
  }
}

Future<List<Tema>> _fetchTemas(int cat) async {
  try {
    final String url = ('${Environment.academicUrl}/tema/lista-temas/${cat}');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> postData = jsonDecode(response.body);
      final List<Tema> posts =
          postData.map((data) => Tema.fromJson(data)).toList();
      return posts;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    return Future.value([]);
  }
}

class TaskCarouselSection extends CarouselSection {
  const TaskCarouselSection({
    super.key,
    required String title,
    required List<Widget> items,
    required Function(int, int) onViewed,
  }) : super(title: title, items: items, onItemTap: onViewed);
}
