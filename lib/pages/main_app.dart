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
  late Usuario user;
  late Future<List<Ruta>> rutas;
  late Future<List<Tema>> temas1;
  late Future<List<Tema>> temas2;
  late Future<List<Tema>> temas3;
  late List<Future<List<Tema>>> temasFutures;
  late List<Post> recentPosts = [];

  @override
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

        posts.sort((a, b) => b.fecha.compareTo(a.fecha));

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
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30,),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icon/icon.png'),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: FutureBuilder<List<Ruta>>(
        future: rutas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error al cargar las rutas'));
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
                        return const Center(child: CircularProgressIndicator());
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
                                  'Cargando...',
                              items: _buildCarouselItemsList(temas, i),
                              onItemTap: _markAsViewed,
                            );
                          }
                          if (titleSnapshot.hasError) {
                            return CarouselSection(
                              title:
                                  'Error: ${titleSnapshot.error}',
                              items: _buildCarouselItemsList(temas, i),
                              onItemTap: _markAsViewed,
                            );
                          }

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
                _buildNewsletterSection(),
                _buildNewsBlogSection(),
                _buildQuizzesSection(),
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
    return rawContent.replaceAll(r'\n', '\n');
  }

  List<Widget> _buildRecentPostsCarouselItems() {
    return recentPosts.map((post) {
      String nuevo = formatContent(post.contenido);
      List<String> lines = nuevo.split('\n');
      String firstLine =
          lines.firstWhere((line) => line.trim().isNotEmpty, orElse: () => '');
      String limitedContent = firstLine.length > 35
          ? '${firstLine.substring(0, 35)}...'
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
                CircleAvatar(
                  
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.titulo, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                      Text('Por ${post.nombre}', style: const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 8.0),
                      Text(limitedContent),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment, color: Colors.grey),
                            onPressed: () {},
                          ),
                          TextButton(
                            onPressed: () => _navigateToPostScreen(context, post.id_post),
                            child: const Text('Ver más'),
                          ),
                        ],
                      ),
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
          ? '${item.titulo.substring(0, 35)}...'
          : item.titulo;

      return GestureDetector(
        onTap: () async {
          updateRutaEstado(item.estado, item.id_tema);
          int idRuta = await fetchRel(user.uid, carouselIndex);
          _navigateToDetailScreen(context, item, idRuta);
        },
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
                Image.asset(
                  'assets/imgs/${item.foto}.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(limitedTitle,
                          style: const TextStyle(fontSize: 16.0)),
                      Text(item.estado),
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

  Widget _buildNewsletterSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Newsletter', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              const Text(
                'Suscríbete a nuestro boletín para recibir las últimas novedades y actualizaciones.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Suscribirse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsBlogSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Noticias / Blog', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildBlogPostTile('Nueva actualización del curso de Cálculo Diferencial', 'John Doe', 5, 10),
              _buildBlogPostTile('Importancia de la Física Mecánica en la Ingeniería', 'Jane Smith', 3, 8),
              _buildBlogPostTile('Consejos para mejorar tus habilidades en Programación 1', 'Alex Brown', 7, 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlogPostTile(String title, String author, int comments, int likes) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: const NetworkImage('https://via.placeholder.com/150'), // Replace with actual author image URL
                radius: 25,
              ),
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Por $author'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Ver más'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.grey),
                const SizedBox(width: 4),
                Text('$likes Likes'),
                const SizedBox(width: 16),
                Icon(Icons.comment, color: Colors.grey),
                const SizedBox(width: 4),
                Text('$comments Comments'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizzesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quices', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          _buildQuizTile('Cálculo Diferencial', Icons.calculate),
          _buildQuizTile('Física Mecánica', Icons.science),
          _buildQuizTile('Programación 1', Icons.code),
        ],
      ),
    );
  }

  Widget _buildQuizTile(String subject, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(subject),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => _navigateToQuizScreen(context, subject),
    );
  }

  Future<void> _navigateToQuizScreen(BuildContext context, String subject) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizScreen(subject: subject),
      ),
    );
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

Future<void> _navigateToDetailScreen(
    BuildContext context, Tema item1, int idRuta) async {
  String contenidoUrl =
      ('${Environment.academicUrl}/contenido/${item1.contenido}');
  final responseCont = await http.get(Uri.parse(contenidoUrl));
  if (responseCont.statusCode == 200) {
    final Contenido item = Contenido.fromJson(jsonDecode(responseCont.body));
    String pdfUrl = '${Environment.blobUrl}/api/blob/download/${item.material}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MyPantallaClase(contenido: item, pdfUrl: pdfUrl, ruta: idRuta),
      ),
    );
  } else {
    return;
  }
}

Future<int> fetchRel(String usuario, int materia) async {
  String url1 =
      ('${Environment.academicUrl}/userxmateria/lista-relaciones/${usuario}/${materia}');
  final response1 = await http.get(Uri.parse(url1));
  if (response1.statusCode == 200) {
    int id = jsonDecode(response1.body)['id_user_mat'];
    String url2 = ('${Environment.academicUrl}/ruta/ruta-user/$id');
    final response2 = await http.get(Uri.parse(url2));
    if (response2.statusCode == 200) {
      int idRuta = jsonDecode(response2.body)['id_ruta'];
      return idRuta;
    } else {
      print('Error en conseguir la ruta del usuario respecto a esta materia');
      return Future.value(0);
    }
  } else {
    print('Error en conseguir la relacion de usuario y materia');
    return Future.value(0);
  }
}

Future<void> updateRutaEstado(String estado, int id) async {
  if (estado == "No visto") {
    estado = "Visto";
    final String url = '${Environment.academicUrl}/tema/actualizar/$id';
    Map<String, dynamic> data = {"estado": estado};
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print('Tema actualizado con éxito');
      return;
    } else {
      print(
          'Error al actualizar el tema. Código de estado: ${response.statusCode}');
      return;
    }
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
            child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
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
          Ruta ruta = Ruta.fromJson(jsonDecode(responseRuta.body));
          rutas.add(ruta);
        } else {
          print(
              'Error al obtener la ruta del usuario. Código de estado: ${responseRuta.statusCode}');
        }
      }
      return rutas;
    } else {
      return Future.value([]);
    }
  } catch (error) {
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

class QuizScreen extends StatelessWidget {
  final String subject;

  const QuizScreen({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$subject Quiz'),
      ),
      body: QuizBody(subject: subject),
    );
  }
}

class QuizBody extends StatefulWidget {
  final String subject;

  const QuizBody({required this.subject});

  @override
  _QuizBodyState createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  final Map<int, String> _answers = {};
  final List<Map<String, Object>> _questions = [];

  @override
  void initState() {
    super.initState();
    if (widget.subject == 'Cálculo Diferencial') {
      _questions.addAll([
        {
          'question': '¿Cuál es la derivada de x^2?',
          'options': ['A. 2x', 'B. x^2', 'C. x', 'D. 2'],
          'correct': 'A. 2x'
        },
        {
          'question': '¿Qué es una integral definida?',
          'options': ['A. Una suma infinita', 'B. Un área bajo la curva', 'C. Una derivada', 'D. Ninguna de las anteriores'],
          'correct': 'B. Un área bajo la curva'
        },
        {
          'question': '¿Cuál es la derivada de cos(x)?',
          'options': ['A. -sin(x)', 'B. sin(x)', 'C. cos(x)', 'D. -cos(x)'],
          'correct': 'A. -sin(x)'
        },
        {
          'question': '¿Qué representa la pendiente de la tangente en un punto de una curva?',
          'options': ['A. La integral', 'B. La derivada', 'C. El valor de la función', 'D. Ninguna de las anteriores'],
          'correct': 'B. La derivada'
        },
        {
          'question': '¿Qué es una antiderivada?',
          'options': ['A. Una suma infinita', 'B. Una función cuyo derivado es la función original', 'C. Un área bajo la curva', 'D. Ninguna de las anteriores'],
          'correct': 'B. Una función cuyo derivado es la función original'
        },
      ]);
    } else if (widget.subject == 'Física Mecánica') {
      _questions.addAll([
        {
          'question': '¿Qué describe la segunda ley de Newton?',
          'options': ['A. Inercia', 'B. Acción y reacción', 'C. Fuerza y aceleración', 'D. Gravitación'],
          'correct': 'C. Fuerza y aceleración'
        },
        {
          'question': '¿Qué unidad se usa para medir la fuerza?',
          'options': ['A. Joule', 'B. Newton', 'C. Pascal', 'D. Watt'],
          'correct': 'B. Newton'
        },
        {
          'question': '¿Qué es la inercia?',
          'options': ['A. La tendencia de un objeto a mantenerse en reposo o en movimiento', 'B. La resistencia al cambio de velocidad', 'C. La aceleración de un objeto', 'D. Ninguna de las anteriores'],
          'correct': 'A. La tendencia de un objeto a mantenerse en reposo o en movimiento'
        },
        {
          'question': '¿Cuál es la fórmula de la velocidad?',
          'options': ['A. v = d/t', 'B. v = t/d', 'C. v = d*t', 'D. v = t*d'],
          'correct': 'A. v = d/t'
        },
        {
          'question': '¿Qué es la aceleración?',
          'options': ['A. El cambio de posición', 'B. El cambio de velocidad', 'C. El cambio de dirección', 'D. Ninguna de las anteriores'],
          'correct': 'B. El cambio de velocidad'
        },
      ]);
    } else if (widget.subject == 'Programación 1') {
      _questions.addAll([
        {
          'question': '¿Qué significa "int" en programación?',
          'options': ['A. Entero', 'B. Decimal', 'C. Carácter', 'D. Cadena'],
          'correct': 'A. Entero'
        },
        {
          'question': '¿Qué estructura se usa para repetir un bloque de código?',
          'options': ['A. if', 'B. for', 'C. switch', 'D. case'],
          'correct': 'B. for'
        },
        {
          'question': '¿Qué es un bucle infinito?',
          'options': ['A. Un bucle que nunca termina', 'B. Un bucle que se ejecuta una sola vez', 'C. Un bucle que se ejecuta dos veces', 'D. Ninguna de las anteriores'],
          'correct': 'A. Un bucle que nunca termina'
        },
        {
          'question': '¿Qué palabra clave se utiliza para declarar una variable en Python?',
          'options': ['A. var', 'B. let', 'C. int', 'D. Ninguna de las anteriores'],
          'correct': 'D. Ninguna de las anteriores'
        },
        {
          'question': '¿Qué es un IDE?',
          'options': ['A. Un entorno de desarrollo integrado', 'B. Un tipo de variable', 'C. Una función', 'D. Ninguna de las anteriores'],
          'correct': 'A. Un entorno de desarrollo integrado'
        },
      ]);
    }
  }

  void _submitQuiz() {
    int score = 0;
    _answers.forEach((index, answer) {
      if (answer == _questions[index]['correct']) {
        score++;
      }
    });
    _showResultDialog(score);
  }

  void _showResultDialog(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resultado del Quiz'),
          content: Text('Obtuviste $score de ${_questions.length} respuestas correctas.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _questions[index]['question'] as String,
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        ...(_questions[index]['options'] as List<String>).map((option) {
                          return RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: _answers[index],
                            onChanged: (value) {
                              setState(() {
                                _answers[index] = value as String;
                              });
                            },
                            secondary: _answers[index] != null
                                ? (_answers[index] == _questions[index]['correct']
                                    ? (_answers[index] == option
                                        ? const Icon(Icons.check_circle, color: Colors.green)
                                        : const Icon(Icons.cancel, color: Colors.red))
                                    : (_answers[index] == option
                                        ? const Icon(Icons.cancel, color: Colors.red)
                                        : null))
                                : null,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submitQuiz,
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
