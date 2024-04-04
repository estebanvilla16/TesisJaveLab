//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de de ruta de aprenzizaje
import 'package:flutter/material.dart';
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
  const PantallaRutaAprendizaje({super.key});

  @override
  Widget build(BuildContext context) {
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
                decoration: InputDecoration( //buscador
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: secciones.length,
              itemBuilder: (context, index) {
                return SeccionRutaAprendizaje(
                  titulo: secciones[index]['titulo'],
                  icono: secciones[index]['icono'],
                  progreso: secciones[index]['progreso'],
                  contenido: secciones[index]['contenido'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
//clase de ruta y contiene el valor del progreso
class SeccionRutaAprendizaje extends StatefulWidget {
  final String titulo;
  final IconData icono;
  final double progreso;
  final List<CapituloContenido> contenido;

  const SeccionRutaAprendizaje({super.key, 
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

  int _calcularCapitulosVistos() {
    return widget.contenido.where((capitulo) => capitulo.visto).length;
  }

  double _calcularProgreso() {
    final totalCapitulos = widget.contenido.length;
    final capitulosVistos = _calcularCapitulosVistos();
    return totalCapitulos != 0 ? capitulosVistos / totalCapitulos : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final progreso = _calcularProgreso();
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
          trailing: Text('${(progreso * 100).toInt()}%'),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
        if (_expanded)
          Column(
            children: widget.contenido
                .asMap()
                .map((index, capitulo) {
              return MapEntry(
                index,
                CapituloContenidoWidget(
                  capitulo: capitulo,
                  isLast: index == widget.contenido.length - 1,
                  onMarcarVisto: () {
                    setState(() {
                      capitulo.visto = !capitulo.visto;
                    });
                  },
                ),
              );
            })
                .values
                .toList(),
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
