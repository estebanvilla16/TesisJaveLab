import 'dart:convert';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/contenido.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:http/http.dart' as http;
import 'package:JaveLab/pages/pantalla_clase.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:provider/provider.dart';

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

    final List<Map<String, String>> clasesRecomendadas = [
      {'titulo': 'Algoritmos Básicos', 'descripcion': 'Introducción a los algoritmos en Programación 1'},
      {'titulo': 'Cinemática Avanzada', 'descripcion': 'Movimientos complejos en Física Mecánica'},
      {'titulo': 'Límites y Continuidad', 'descripcion': 'Conceptos fundamentales en Cálculo Diferencial'},
    ];

    final List<Map<String, String>> clasesPendientes = [
      {'titulo': 'Estructuras de Datos', 'descripcion': 'Listas, pilas y colas en Programación 1', 'tipo': 'Actividad'},
      {'titulo': 'Leyes de Newton', 'descripcion': 'Aplicaciones prácticas en Física Mecánica', 'tipo': 'Quiz'},
      {'titulo': 'Derivadas', 'descripcion': 'Cómo calcular y aplicar derivadas en Cálculo Diferencial', 'tipo': 'Lectura'},
    ];

    final List<Map<String, String>> monitores = [
      {'nombre': 'Juan Pérez', 'materia': 'Programación 1', 'correo': 'juan.perez@example.com', 'especialidad': 'Algoritmos y Estructuras de Datos', 'actividades': 'Publicación reciente sobre Algoritmos Avanzados'},
      {'nombre': 'Ana Gómez', 'materia': 'Física Mecánica', 'correo': 'ana.gomez@example.com', 'especialidad': 'Dinámica y Cinemática', 'actividades': 'Publicación reciente sobre Dinámica'},
      {'nombre': 'Luis Martínez', 'materia': 'Cálculo Diferencial', 'correo': 'luis.martinez@example.com', 'especialidad': 'Límites y Derivadas', 'actividades': 'Publicación reciente sobre Derivadas'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
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
      bottomNavigationBar: const BottomMenu(), // menú inferior
      endDrawer: const BurgerMenu(), // menú hamburguesa
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
                            SizedBox(width: 8),
                            Expanded(
                                child: Text(
                                    'El modelo cognitivista aplicado a Javelab pone énfasis en el diseño y la disposición de contenidos para optimizar el procesamiento mental del aprendizaje. Se centra en hacer que la información sea fácil de entender y retener, mediante una interfaz intuitiva y recursos interactivos que fomentan el análisis crítico y la aplicación práctica del conocimiento.')),
                          ],
                        ),
                        duration: const Duration(seconds: 10),
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  tooltip: 'Información',
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                height: 200, // Ajusta este valor según tus necesidades
                child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: carouselItems
                      .map((item) => Container(
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
                                        fontWeight: FontWeight.w400),
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
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 75),
              const Divider(), // Separador entre filtros y secciones
              _buildRecomendadasSection(context, clasesRecomendadas),
              const SizedBox(height: 20),
              _buildPendientesSection(context, clasesPendientes),
              const SizedBox(height: 20),
              _buildSeccionRutaAprendizaje(context, 'Programación', 1, Icons.code),
              const SizedBox(height: 20),
              _buildSeccionRutaAprendizaje(context, 'Física Mecánica', 2, Icons.explore),
              const SizedBox(height: 20),
              _buildSeccionRutaAprendizaje(context, 'Cálculo Diferencial', 3, Icons.calculate),
              const SizedBox(height: 20),
              _buildSugerirMonitoresSection(context, monitores),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecomendadasSection(BuildContext context, List<Map<String, String>> clases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clases Recomendadas',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clases.length,
            itemBuilder: (context, index) {
              final clase = clases[index];
              return Container(
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clase['titulo']!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      clase['descripcion']!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // Implementar lógica para ver más detalles de la clase recomendada
                      },
                      child: Text(
                        'Ver más',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPendientesSection(BuildContext context, List<Map<String, String>> clases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clases Pendientes',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: clases.length,
            itemBuilder: (context, index) {
              final clase = clases[index];
              return Container(
                width: 300,
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clase['titulo']!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      clase['descripcion']!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      clase['tipo']!,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        // Implementar lógica para ver más detalles de la clase pendiente
                      },
                      child: Text(
                        'Ver más',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionRutaAprendizaje(BuildContext context, String titulo, int materia, IconData icono) {
    return FutureBuilder<List<Contenido>>(
      future: _fetchTemas(materia),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SeccionRutaAprendizaje(
            titulo: titulo,
            icono: icono,
            progreso: 0.0,
            contenido: snapshot.data ?? [],
            materia: materia,
          );
        }
      },
    );
  }

  Widget _buildSugerirMonitoresSection(BuildContext context, List<Map<String, String>> monitores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugerir Monitores',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        Column(
          children: monitores.map((monitor) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monitor['nombre']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(monitor['materia']!),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.info, color: Colors.blue),
                    onPressed: () {
                      _mostrarDetallesMonitor(context, monitor);
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _mostrarDetallesMonitor(BuildContext context, Map<String, String> monitor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text(
                monitor['nombre']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text(monitor['correo']!),
              ),
              ListTile(
                leading: Icon(Icons.school, color: Colors.blue),
                title: Text(monitor['especialidad']!),
              ),
              ListTile(
                leading: Icon(Icons.assignment, color: Colors.blue),
                title: InkWell(
                  onTap: () {
                    // Implementar lógica para ver la publicación reciente
                  },
                  child: Text(
                    monitor['actividades']!,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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
                // Implementar lógica para contactar al monitor
              },
              child: const Text('Contactar'),
            ),
          ],
        );
      },
    );
  }
}

// clase de ruta y contiene el valor del progreso
class SeccionRutaAprendizaje extends StatefulWidget {
  final String titulo;
  final IconData icono;
  final double progreso;
  final List<Contenido> contenido;
  final int materia;

  const SeccionRutaAprendizaje({
    required this.titulo,
    required this.icono,
    required this.progreso,
    required this.contenido,
    required this.materia,
  });

  @override
  _SeccionRutaAprendizajeState createState() => _SeccionRutaAprendizajeState();
}

class _SeccionRutaAprendizajeState extends State<SeccionRutaAprendizaje> {
  bool _expanded = false;
  double progreso = 0.0;
  late Usuario user;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    user = authService.usuario;
  }

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
          trailing: Text('${(progreso * 100).toInt()}%'),
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
        ),
        LinearProgressIndicator(
          value: progreso,
          backgroundColor: Colors.grey[300],
          color: Theme.of(context).primaryColor,
          minHeight: 5,
        ),
        if (_expanded)
          Column(
            children: widget.contenido.map((contenido) {
              return ListTile(
                title: Text(contenido.titulo),
                subtitle: Text(contenido.descripcion),
                onTap: () async {
                  int idRuta = await fetchRel(user.uid, widget.materia);
                  setState(() {
                    progreso += 1 / widget.contenido.length;
                  });
                  _navigateToDetailScreen(context, contenido, idRuta);
                },
              );
            }).toList(),
          ),
        const Divider(), // Separador entre secciones
      ],
    );
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

void _navigateToDetailScreen(BuildContext context, Contenido item, int idRuta) {
  String pdfUrl = '${Environment.blobUrl}/api/blob/download/${item.material}';
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>
          MyPantallaClase(contenido: item, pdfUrl: pdfUrl, ruta: idRuta),
    ),
  );
}

Future<List<Contenido>> _fetchTemas(int cat) async {
  try {
    final String url =
        ('${Environment.academicUrl}/contenido/lista-contenidos/${cat}');
    final response = await http.get(Uri.parse(url));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Convierte la respuesta JSON en una lista de mapas
      final List<dynamic> contenidoData = jsonDecode(response.body);
      // Crea una lista de Contenido a partir de los datos obtenidos
      final List<Contenido> contenidoList =
          contenidoData.map((data) => Contenido.fromJson(data)).toList();
      // Ahora tienes la lista de Contenido, puedes usarla según necesites
      return contenidoList;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    // Si ocurrió un error durante la solicitud, imprímelo
    return Future.value([]);
  }
}

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
