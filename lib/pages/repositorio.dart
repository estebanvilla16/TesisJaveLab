import 'package:JaveLab/pages/crearRepo.dart';
import 'package:JaveLab/pages/ver_post.dart';
import 'package:JaveLab/pages/ver_repo.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repositorio Académico',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Desactivar el modo debug
      home: RepositoryHomeScreen(),
    );
    
  }
  
}

class RepositoryHomeScreen extends StatelessWidget {
  final List<Map<String, String>> repositories = [
    {
      'title': 'Parcial 1',
      'subject': 'Cálculo Diferencial',
      'description': 'Primer parcial del semestre',
      'author': 'Juan Pérez'
    },
    {
      'title': 'Taller 3',
      'subject': 'Física Mecánica',
      'description': 'Taller sobre dinámica',
      'author': 'María López'
    },
    {
      'title': 'Proyecto Final',
      'subject': 'Programación 1',
      'description': 'Proyecto final del curso',
      'author': 'Carlos Gómez'
    },
    {
      'title': 'Taller 1',
      'subject': 'Cálculo Diferencial',
      'description': 'Taller de límites y derivadas',
      'author': 'Ana Rodríguez'
    },
    {
      'title': 'Proyecto Parcial',
      'subject': 'Física Mecánica',
      'description': 'Proyecto sobre leyes de Newton',
      'author': 'Luis Hernández'
    },
    {
      'title': 'Quiz 1',
      'subject': 'Cálculo Diferencial',
      'description': 'Primer quiz del semestre',
      'author': 'Carlos Sánchez'
    },
    {
      'title': 'Laboratorio 1',
      'subject': 'Física Mecánica',
      'description': 'Laboratorio de movimiento',
      'author': 'Laura Méndez'
    },
    {
      'title': 'Tarea 1',
      'subject': 'Programación 1',
      'description': 'Tarea sobre estructuras de datos',
      'author': 'Pedro Ruiz'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            SizedBox(width: 10),
            Text('Repositorio Académico'),
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido al Repositorio Académico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Encuentra y comparte recursos para tus materias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar en el repositorio...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: repositories.map((repo) {
                return Builder(
                  builder: (BuildContext context) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(repo['title']!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Text(repo['subject']!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              SizedBox(height: 10),
                              Text(repo['description']!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              SizedBox(height: 10),
                              Text('Autor: ${repo['author']!}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blueAccent, backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text('Ver más'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildSubjectTile(context, 'Cálculo Diferencial'),
                  buildSubjectTile(context, 'Física Mecánica'),
                  buildSubjectTile(context, 'Programación 1'),
                ],
              ),
            ),
            buildInstructions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateRepositoryScreen()),
            );
        },
      ),
    );
  }

  Widget buildSubjectTile(BuildContext context, String subject) {
    final List<Map<String, String>> filteredRepos = repositories
        .where((repo) => repo['subject'] == subject)
        .take(8)
        .toList();

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: Icon(Icons.folder, color: Colors.blue),
        title: Text(subject),
        children: filteredRepos.map((repo) {
          return ListTile(
            title: Text(repo['title']!),
            subtitle: Text(repo['description']!),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewRepositoryScreen(repository: {'author': 'Ana Rodríguez',
          'subject': 'Programación 1',
          'title': 'Proyecto Final',
          'description': 'Proyecto final del curso de Programación 1. Este proyecto implementa un sistema de gestión de tareas usando Python y una base de datos SQLite. Incluye funcionalidades como crear, editar y eliminar tareas, así como asignar prioridades y fechas de vencimiento.',
          'file': 'Proyecto_Final_Programacion1.zip',}, recommendedRepositories: [{
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
          },],)),
            );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructivo de Uso',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.add, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Para crear un repositorio, haga clic en el botón "+" en la esquina inferior derecha.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.format_list_bulleted, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Complete el formulario seleccionando la materia, tipo de archivo, y agregue un comentario.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.upload_file, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Haga clic en "Seleccionar Archivo" para subir su documento.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Una vez completado el formulario, haga clic en "Crear Repositorio".',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.search, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Puede buscar y ver repositorios en la pantalla principal.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructivo de Uso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Instructivo de Uso',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.add, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Para crear un repositorio, haga clic en el botón "+" en la esquina inferior derecha.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.format_list_bulleted, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Complete el formulario seleccionando la materia, tipo de archivo, y agregue un comentario.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.upload_file, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Haga clic en "Seleccionar Archivo" para subir su documento.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Una vez completado el formulario, haga clic en "Crear Repositorio".',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.search, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Puede buscar y ver repositorios en la pantalla principal.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
