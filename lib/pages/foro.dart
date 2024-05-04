import 'package:JaveLab/pages/crear_post.dart';
import 'package:JaveLab/models/post.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:JaveLab/pages/ver_post.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Cara6 extends StatelessWidget {
  const Cara6({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF2c5968);

    final List<String> carouselItems = [
      '1. Experiencia Intuitiva: Diseñamos una interfaz centrada en el estudiante, asegurando una navegación intuitiva que facilita el aprendizaje efectivo.',
      '2. Psicología del Color: Utilizamos colores estratégicamente para mejorar la concentración y retención de información, optimizando así el entorno de aprendizaje.',
      '3. Diseño Efectivo: La disposición lógica y la navegación fácil promueven un acceso sin esfuerzo a contenidos educativos importantes.',
      '4. Flexibilidad en Aprendizaje: Nuestra aplicación favorece el aprendizaje asincrónico, ofreciendo flexibilidad para estudiar en cualquier momento y lugar.',
      '5. Participación Activa: Fomentamos la interacción y reflexión en foros y videos, mejorando la participación y el intercambio de conocimientos.',
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Tooltip(message: 'Bienvenido al Foro Académico', child:  Text('Foro | Academico')),

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
                  const Tooltip(
                    message: 'Sección principal del foro',
                    child:  Text(
                      'Foro',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Tooltip(
                    message: 'Explora las categorías del foro',
                    child:  Text(
                      'Categorías',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
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
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
                        SizedBox(width: 8),
                        Expanded(child: Text('La aplicación integra el modelo pedagógico de pares con una interfaz intuitiva que utiliza colores estratégicamente para mejorar el aprendizaje y la retención. La disposición y navegación de los elementos, alineadas con principios de psicología visual, facilitan una experiencia de usuario fluida, mientras que el posicionamiento efectivo enfatiza contenido clave, apoyando así el enfoque colaborativo y la interacción efectiva entre pares..')),

                      ],
                    ),

                    duration: const Duration(seconds: 10),
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    behavior: SnackBarBehavior.floating,
                  ),


                );
              },
              tooltip: 'Información',
            ),
            SectionWidget(

              title: 'Calculo Diferencial',
              description: 'Explora temas de Cálculo Diferencial',
              backgroundColor: primaryColor.withOpacity(0.7),
              icon: Icons.calculate,
              category: 2, // Icono relacionado

            ),


            SectionWidget(
              title: 'Física Mecánica',
              description: 'Descubre los fundamentos de la Física Mecánica',
              backgroundColor: primaryColor.withOpacity(0.6),
              icon: Icons.build,
              category: 3, // Icono relacionado
            ),
            SectionWidget(
              title: 'Programacion I',
              description: 'Aprende los principios básicos de la programación',
              backgroundColor: primaryColor.withOpacity(0.5),
              icon: Icons.code,
              category: 1, // Icono relacionado
            ),
            const SizedBox(height: 16.0),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Tooltip(
                  message: 'Crea un nuevo post en el foro',

                  child: ElevatedButton(

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

                ),

                const SizedBox(width: 16.0),
                Tooltip(
                  message: 'Participa en intercambios dentro del foro',
                  child: ElevatedButton(
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

                ),

              ],

            ),
            SizedBox(
              height: 200, // Ajusta este valor según tus necesidades
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: carouselItems.map((item) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.all(8.0),
                  child: Center(
                    // Usar una Column para colocar el icono encima del texto
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Hace que la Columna ocupe solo el espacio necesario
                      children: [
                        const Icon(
                          Icons.question_answer, // Elige el icono que prefieras
                          color: Colors.deepPurple, // Color del icono
                          size: 19.0, // Tamaño del icono
                        ),
                        Text(
                          item,
                          style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
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
  final IconData icon;
  final int category;

  const SectionWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.icon,
    required this.category,
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
      title: Tooltip(
        message: widget.description,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(

              children: [

                Icon(widget.icon, color: _isExpanded ? Colors.white : Colors.black),
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
            future: _fetchPosts(widget.category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
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
                            tooltip: 'Ver detalles del post',
                            onPressed: () {
                              int? id = post.id_post;
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostViewScreen(id: id)));
                            },
                          ),
                        ],
                      ),
                      subtitle: Text('Fecha: ${post.fecha}, Persona: ${post.nombre}'),
                      textColor: Colors.white,
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

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}



Future<List<Post>> _fetchPosts(int cat) async {
  try {
    String urlDynamic = Platform.isAndroid ? 'http://10.195.49.54:3010' : 'http://localhost:3010';
    final String url = ('$urlDynamic/post/lista-posts/$cat');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> postData = jsonDecode(response.body);
      final List<Post> posts = postData.map((data) => Post.fromJson(data)).toList();
      return posts;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    return Future.value([]);
  }

}
