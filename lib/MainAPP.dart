import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'bottom_menu.dart';
import 'burgermenu.dart';
import 'package:JaveLab/models/contenido.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:JaveLab/pages/ver_contenido.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JAVELAB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2c5697),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.blue.shade900),
          headlineMedium: const TextStyle(color: Color(0xFF2c5697)),
          labelLarge: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF2c5697),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<bool> _viewed = List.generate(15, (_) => false);
  List<Contenido> _carouselItems = [];

  void initState() {
    super.initState();
    _fetchTemas(2).then((data) {
      setState(() {
        _carouselItems = data;
      });
    });
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
        backgroundColor: const Color(0xFF2c5697),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/icon/icon.png'),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const BottomMenu(), //Menu inferior
      endDrawer: const BurgerMenu(), // Menu Hamburguesa
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselSection(
              title: 'Ruta de Aprendizaje',
              items: _buildCarouselItemsList(_carouselItems, 0),
              onItemTap: _markAsViewed,
            ),
            CarouselSection(
              title: 'Publicaciones Recientes',
              items: _buildCarouselItems(1),
              onItemTap: _markAsViewed,
            ),
            TaskCarouselSection(
              title: 'Actividades Pendientes',
              items: _buildTaskCarouselItems(),
              onViewed: _markAsViewed,
            ),
          ],
        ),
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

  List<Widget> _buildCarouselItemsList(
      List<Contenido> dataList, int carouselIndex) {
    return dataList.asMap().entries.map((entry) {
      final int itemIndex = entry.key;
      final Contenido item = entry.value;

      return GestureDetector(
        onTap: () => _navigateToDetailScreen(context, item),
        child: Card(
          color: _viewed[carouselIndex * 5 + itemIndex]
              ? Colors.grey
              : Colors.white,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titulo, style: const TextStyle(fontSize: 16.0)),
                Text(item.descripcion),
                // Agregar más Widgets según sea necesario para mostrar otros datos de Contenido
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTaskCarouselItems() {
    int totalTasks = 5;
    int completedTasks = _viewed.where((viewed) => viewed).length;
    double progress = completedTasks / totalTasks;

    return List<Widget>.generate(
      totalTasks,
      (int itemIndex) {
        bool isCompleted = _viewed[itemIndex];
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Card(
              color: isCompleted ? Colors.white : Colors.white,
              elevation: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Actividad ${itemIndex + 1}',
                        style: const TextStyle(fontSize: 16.0)),
                    const Spacer(),
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.cancel,
                      color: isCompleted ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            if (itemIndex == totalTasks - 1)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade400,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

void _navigateToDetailScreen(BuildContext context, Contenido item) {
  String pdfUrl = 'http://localhost:8080/api/blob/download/${item.material}';
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) =>
          ContenidoDetailScreen(contenido: item, pdfUrl: pdfUrl),
    ),
  );
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

Future<List<Contenido>> _fetchTemas(int cat) async {
  try {
    // Realiza una solicitud HTTP GET para obtener la lista de Posts
    String urlDynamic = Platform.isAndroid
        ? 'http://192.168.56.1:3011'
        : 'http://localhost:3011';
    final String url = ('${urlDynamic}/contenido/lista-contenidos/${cat}');
    final response = await http.get(Uri.parse(url));

    // Verifica si la solicitud fue exitosa (código de estado 200)
    if (response.statusCode == 200) {
      // Convierte la respuesta JSON en una lista de mapas
      final List<dynamic> postData = jsonDecode(response.body);
      // Crea una lista de Posts a partir de los datos obtenidos
      final List<Contenido> posts =
          postData.map((data) => Contenido.fromJson(data)).toList();
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

class TaskCarouselSection extends CarouselSection {
  const TaskCarouselSection({
    super.key,
    required String title,
    required List<Widget> items,
    required Function(int, int) onViewed,
  }) : super(title: title, items: items, onItemTap: onViewed);
}
