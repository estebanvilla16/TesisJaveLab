import 'dart:convert';
import 'dart:io';

import 'package:JaveLab/models/contenido.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_menu.dart';
import 'widgets/burgermenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruta de Aprendizaje',
      theme: ThemeData(
        primaryColor: const Color(0xFF2c5697),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PantallaRutaAprendizaje(),
    );
  }
}

class PantallaRutaAprendizaje extends StatelessWidget {
  const PantallaRutaAprendizaje({Key? key});

  @override
  Widget build(BuildContext context) {
    final List<String> carouselItems = [
      '1. Interfaz Centrada en el Usuario: El uso de colores, tipografías, y una barra de progreso en rutaAcademica facilita la navegación y enfoca la atención en el aprendizaje.',
      '2. Flexibilidad de Aprendizaje: El diseño soporta aprendizaje asincrónico, permitiendo a los estudiantes aprender a su ritmo y en su horario.',
      '3. Interacción y Reflexión: Comentarios de usuarios y videos interactivos promueven la participación activa y el aprendizaje colaborativo.',
      '4. Orientación Educativa: Tooltips y pantallas de introducción explican el diseño pedagógico, fomentando la comprensión del usuario.',
      '5. Acceso Eficiente a Contenido: Búsqueda y filtros avanzados optimizan el acceso a recursos educativos, alineándose con principios cognitivistas.',
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        leading: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Implementar la funcionalidad de notificaciones
          },
        ),

        title: const Text(
          'Mi Ruta de Aprendizaje',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: const [],
      ),
      bottomNavigationBar: const BottomMenu(), // menu inferior
      endDrawer: const BurgerMenu(), //menu hamburguesa
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Container(

              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  //buscador
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  // Implementar la funcionalidad de búsqueda
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.blueGrey),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
                        SizedBox(width: 8),
                        Expanded(child: Text('El modelo cognitivista aplicado a Javelab pone énfasis en el diseño y la disposición de contenidos para optimizar el procesamiento mental del aprendizaje. Se centra en hacer que la información sea fácil de entender y retener, mediante una interfaz intuitiva y recursos interactivos que fomentan el análisis crítico y la aplicación práctica del conocimiento.')),

                      ],
                    ),

                    duration: Duration(seconds: 10),
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    behavior: SnackBarBehavior.floating,
                  ),


                );
              },
              tooltip: 'Información',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _mostrarFiltroAvanzado(context);
                },
                child: const Text('Filtro Avanzado'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200, // Ajusta este valor según tus necesidades
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: carouselItems.map((item) => Container(
                        child: Center(
                          // Usar una Column para colocar el icono encima del texto
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Hace que la Columna ocupe solo el espacio necesario
                            children: [
                              Icon(
                                Icons.apps_sharp, // Elige el icono que prefieras
                                color: Colors.blueGrey, // Color del icono
                                size: 19.0, // Tamaño del icono
                              ),
                              Text(
                                item,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(12.0),
                        margin: EdgeInsets.all(8.0),
                      )).toList(),
                    ),
                  ),
                  const Text(

                    'Último Capítulo Visto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Bloque rectangular para mostrar el último capítulo visto
                  Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Último Capítulo Visto'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recomendaciones',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Bloque rectangular para mostrar las recomendaciones
                  Container(
                    height: 100,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Text('Recomendaciones'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(), // Separador entre filtros y secciones
            FutureBuilder<List<Contenido>>(
              future: _fetchTemas(1), // Categoría de programación
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SeccionRutaAprendizaje(
                    titulo: 'Programación', // Título de la sección
                    icono: Icons.code, // Icono relacionado con la programación
                    progreso:
                        0.0, // Por ahora no tenemos información de progreso
                    contenido: snapshot.data ??
                        [], // Lista de contenido obtenida del servidor
                  );
                }
              },
            ),
            const SizedBox(height: 16), // Espacio entre secciones
            FutureBuilder<List<Contenido>>(
              future: _fetchTemas(2), // Categoría de física
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SeccionRutaAprendizaje(
                    titulo: 'Física Mecánica', // Título de la sección
                    icono: Icons.explore, // Icono similar a física
                    progreso:
                        0.0, // Por ahora no tenemos información de progreso
                    contenido: snapshot.data ??
                        [], // Lista de contenido obtenida del servidor
                  );
                }
              },
            ),
            const SizedBox(height: 16), // Espacio entre secciones
            FutureBuilder<List<Contenido>>(
              future: _fetchTemas(3), // Categoría de cálculo
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return SeccionRutaAprendizaje(
                    titulo: 'Cálculo Diferencial', // Título de la sección
                    icono: Icons.calculate, // Icono relacionado con el cálculo
                    progreso:
                        0.0, // Por ahora no tenemos información de progreso
                    contenido: snapshot.data ??
                        [], // Lista de contenido obtenida del servidor
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// clase de ruta y contiene el valor del progreso
class SeccionRutaAprendizaje extends StatefulWidget {
  final String titulo;
  final IconData icono;
  final double progreso;
  final List<Contenido> contenido;

  const SeccionRutaAprendizaje({
    required this.titulo,
    required this.icono,
    required this.progreso,
    required this.contenido,
  });

  @override
  _SeccionRutaAprendizajeState createState() => _SeccionRutaAprendizajeState();
}

class _SeccionRutaAprendizajeState extends State<SeccionRutaAprendizaje> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            widget.icono,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            widget.titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          trailing: Text('${(widget.progreso * 100).toInt()}%'),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
        if (_expanded)
          Column(
            children: widget.contenido.map((contenido) {
              return ListTile(
                title: Text(contenido.titulo),
                subtitle: Text(contenido.descripcion),
                onTap: () {
                  // Implementar la funcionalidad al hacer clic en el contenido
                  _navigateToDetailScreen(context, contenido);
                },
              );
            }).toList(),
          ),
        const Divider(), // Separador entre secciones
      ],
    );
  }
}

class CapituloContenido {
  final String titulo;
  final String descripcion;
  final List<Video> videos;
  final List<ArchivoAdjunto> archivosAdjuntos;
  bool visto; // Estado del capítulo

  CapituloContenido({
    required this.titulo,
    required this.descripcion,
    required this.videos,
    required this.archivosAdjuntos,
    this.visto = false, // Por defecto, el capítulo no está visto
  });
}

class CapituloContenidoWidget extends StatelessWidget {
  final CapituloContenido capitulo;
  final bool isLast;
  final VoidCallback onMarcarVisto;

  const CapituloContenidoWidget({
    Key? key,
    required this.capitulo,
    required this.isLast,
    required this.onMarcarVisto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onMarcarVisto,
          child: Row(
            children: [
              Icon(
                capitulo.visto ? Icons.check : Icons.remove_red_eye,
                color: capitulo.visto ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  capitulo.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            capitulo.descripcion,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 8),
        ...capitulo.videos.map((video) {
          return ListTile(
            title: Text(video.titulo),
            onTap: () {
              // Implementar la funcionalidad para reproducir el video
            },
          );
        }).toList(),
        ...capitulo.archivosAdjuntos.map((archivo) {
          return ListTile(
            title: Text(archivo.titulo),
            onTap: () {
              // Implementar la funcionalidad para abrir el archivo adjunto
            },
          );
        }).toList(),
        if (!isLast) const Divider(), // Separador entre capítulos (excepto para el último)
      ],
    );
  }
}

class Video {
  final String titulo;
  final String url;

  Video({required this.titulo, required this.url});
}

class ArchivoAdjunto {
  final String titulo;
  final String url;

  ArchivoAdjunto({required this.titulo, required this.url});
}

// Datos de ejemplo
final List<Map<String, dynamic>> secciones = [
  {
    'titulo': 'Pensamiento Algorítmico',
    'icono': Icons.code, // Icono relacionado con la programación
    'progreso': 0.6,
    'contenido': List.generate(
      10,
          (index) => CapituloContenido(
        titulo: 'Capítulo ${index + 1}: Algoritmos básicos',
        descripcion:
        'En este capítulo aprenderás los conceptos básicos de algoritmos con ejemplos prácticos.',
        videos: [
          Video(
            titulo: 'Introducción a los algoritmos',
            url: 'https://www.youtube.com/watch?v=VIDEO_ID',
          ),
        ],
        archivosAdjuntos: [
          ArchivoAdjunto(
            titulo: 'Presentación',
            url: 'URL_PRESENTACION',
          ),
        ],
      ),
    ),
  },
  {
    'titulo': 'Física Mecánica',
    'icono': Icons.explore, // Icono similar a física
    'progreso': 0.3,
    'contenido': List.generate(
      10,
          (index) => CapituloContenido(
        titulo: 'Capítulo ${index + 1}: Leyes de Newton',
        descripcion:
        'En este capítulo explorarás las leyes fundamentales de la física mecánica con ejemplos de la vida real.',
        videos: [
          Video(
            titulo: 'Ley de la inercia',
            url: 'https://www.youtube.com/watch?v=VIDEO_ID',
          ),
        ],
        archivosAdjuntos: [
          ArchivoAdjunto(
            titulo: 'PDF',
            url: 'URL_PDF',
          ),
        ],
      ),
    ),
  },
  {
    'titulo': 'Cálculo Diferencial',
    'icono': Icons.calculate, // Icono relacionado con el cálculo
    'progreso': 0.8,
    'contenido': List.generate(
      10,
          (index) => CapituloContenido(
        titulo: 'Capítulo ${index + 1}: Derivadas',
        descripcion:
        'En este capítulo estudiarás las derivadas y sus aplicaciones en problemas del mundo real.',
        videos: [
          Video(
            titulo: 'Introducción a las derivadas',
            url: 'https://www.youtube.com/watch?v=VIDEO_ID',
          ),
        ],
        archivosAdjuntos: [
          ArchivoAdjunto(
            titulo: 'Ejercicios prácticos',
            url: 'URL_EJERCICIOS',
          ),
        ],
      ),
    ),
  },
];

void _mostrarFiltroAvanzado(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Filtro Avanzado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Por título'),
              value: false,
              onChanged: (newValue) {},
            ),
            CheckboxListTile(
              title: const Text('Por capítulo'),
              value: false,
              onChanged: (newValue) {},
            ),
            CheckboxListTile(
              title: const Text('Por contenido'),
              value: false,
              onChanged: (newValue) {},
            ),
            CheckboxListTile(
              title: const Text('Por materia'),
              value: false,
              onChanged: (newValue) {},
            ),
            CheckboxListTile(
              title: const Text('Por palabras clave'),
              value: false,
              onChanged: (newValue) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aplicar filtros
              Navigator.of(context).pop();
            },
            child: const Text('Aplicar'),
          ),
        ],
      );
    },
  );
}
