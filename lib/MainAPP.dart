import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'bottom_menu.dart';
import 'burgermenu.dart';
import 'package:JaveLab/models/contenido.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JAVELAB App',
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
      home: const Principal(),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final List<bool> _viewed = List.generate(15, (_) => false);
  List<Contenido> _carouselItems = [];

  @override
  void initState() {
    super.initState();
    _fetchTemas(2).then((data) {
      setState(() {
        _carouselItems = data;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _showIntroDialog());
  }

  void _showIntroDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bienvenido a JAVELAB'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Exploramos principios cognitivistas y de aprendizaje colaborativo.'),
                Text('Descubre cómo utilizar esta app para tu aprendizaje.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Entendido'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
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
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
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

  void _markAsViewed(int carouselIndex, int itemIndex) {
    setState(() {
      _viewed[carouselIndex * 5 + itemIndex] = true;
    });
    _showSnackBar(' ${itemIndex + 1} marcado como visto');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<List<Contenido>> _fetchTemas(int cat) async {
    try {
      String urlDynamic = Platform.isAndroid ? 'http://192.168.56.1:3011' : 'http://localhost:3011';
      final String url = '${urlDynamic}/contenido/lista-contenidos/$cat';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<Contenido> posts = postData.map((data) => Contenido.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      return Future.value([]);
    }
  }

  List<Widget> _buildCarouselItems(int carouselIndex) {
    return List<Widget>.generate(
      5,
          (int itemIndex) => GestureDetector(
        onTap: () => _markAsViewed(carouselIndex, itemIndex),
        child: Card(
          color: _viewed[carouselIndex * 5 + itemIndex] ? Colors.grey : Colors.white,
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Text('Elemento ${itemIndex + 1}', style: const TextStyle(fontSize: 16.0)),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCarouselItemsList(List<Contenido> dataList, int carouselIndex) {
    return dataList.asMap().entries.map((entry) {
      final int itemIndex = entry.key;
      final Contenido item = entry.value;

      return GestureDetector(
        onTap: () => _markAsViewed(carouselIndex, itemIndex),
        child: Card(
          color: _viewed[carouselIndex * 5 + itemIndex] ? Colors.grey : Colors.white,
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
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Actividad ${itemIndex + 1}', style: const TextStyle(fontSize: 16.0)),
                    const Spacer(),
                    Icon(isCompleted ? Icons.check_circle : Icons.cancel, color: isCompleted ? Colors.green : Colors.red),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CarouselSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final Function(int, int) onItemTap;

  const CarouselSection({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

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

class TaskCarouselSection extends CarouselSection {
  const TaskCarouselSection({
    Key? key,
    required String title,
    required List<Widget> items,
    required Function(int, int) onViewed,
  }) : super(key: key, title: title, items: items, onItemTap: onViewed);
}
