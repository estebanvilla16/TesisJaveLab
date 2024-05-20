import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalle del Repositorio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Desactivar el modo debug
      home: ViewRepositoryScreen(
        repository: {
          'author': 'Ana Rodríguez',
          'subject': 'Programación 1',
          'title': 'Proyecto Final',
          'description': 'Proyecto final del curso de Programación 1. Este proyecto implementa un sistema de gestión de tareas usando Python y una base de datos SQLite. Incluye funcionalidades como crear, editar y eliminar tareas, así como asignar prioridades y fechas de vencimiento.',
          'file': 'Proyecto_Final_Programacion1.zip',
        },
        recommendedRepositories: [
          {
            'title': 'Taller 1',
            'subject': 'Cálculo Diferencial',
            'description': 'Taller de límites y derivadas',
            'author': 'Ana Rodríguez',
          },
          {
            'title': 'Parcial 2',
            'subject': 'Física Mecánica',
            'description': 'Segundo parcial del semestre',
            'author': 'Carlos Gómez',
          },
          {
            'title': 'Tarea 3',
            'subject': 'Programación 1',
            'description': 'Tarea sobre estructuras de datos',
            'author': 'María López',
          },
        ],
      ),
    );
  }
}

class ViewRepositoryScreen extends StatelessWidget {
  final Map<String, String> repository;
  final List<Map<String, String>> recommendedRepositories;

  ViewRepositoryScreen({required this.repository, required this.recommendedRepositories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Repositorio'),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/profile_placeholder.png'),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repository['author']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                repository['subject']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        repository['title']!,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        repository['description']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Archivo adjunto:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                          title: Text(repository['file']!),
                          subtitle: Text('Tamaño: 5MB'),
                          trailing: Icon(Icons.download, color: Colors.blue),
                          onTap: () {
                            // Lógica para descargar el archivo
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.favorite_border),
                            label: Text('Favoritos'),
                            onPressed: () {
                              // Lógica para agregar a favoritos
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.thumb_up_alt_outlined),
                            label: Text('Recomendar'),
                            onPressed: () {
                              // Lógica para recomendar
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Repositorios Recomendados:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedRepositories.length,
                  itemBuilder: (context, index) {
                    final repo = recommendedRepositories[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 300,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repo['title']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              repo['description']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  repo['author']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward, color: Colors.blue),
                              ],
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
      ),
    );
  }
}
