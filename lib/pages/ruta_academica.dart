import 'dart:convert';
import 'dart:io';

import 'package:JaveLab/models/contenido.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:http/http.dart' as http;
import 'package:JaveLab/pages/pantalla_clase.dart';
import 'package:carousel_slider/carousel_slider.dart';


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
              icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.yellowAccent),
                        SizedBox(width: 8),
                        Expanded(child: Text('El modelo cognitivista aplicado a Javelab pone énfasis en el diseño y la disposición de contenidos para optimizar el procesamiento mental del aprendizaje. Se centra en hacer que la información sea fácil de entender y retener, mediante una interfaz intuitiva y recursos interactivos que fomentan el análisis crítico y la aplicación práctica del conocimiento.')),

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

void _navigateToDetailScreen(BuildContext context, Contenido item) {
  String urlDynamic =
      Platform.isAndroid ? 'http://192.168.10.34:8080' : 'http://localhost:8080';
  String pdfUrl = '${urlDynamic}/api/blob/download/${item.material}';
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => MyPantallaClase(contenido: item, pdfUrl: pdfUrl),
    ),
  );
}

Future<List<Contenido>> _fetchTemas(int cat) async {
  try {
    // Realiza una solicitud HTTP GET para obtener la lista de Contenido
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.10.34:3011'
        : 'http://localhost:3011';
    final String url = ('${urlDynamic}/contenido/lista-contenidos/${cat}');
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