//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de perfil de usuario
import 'dart:convert';

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/pages/perfil_user.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';

import 'package:JaveLab/models/feedback.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FocusNode _feedbackFocusNode = FocusNode();
  int _filledStars = 0; //0 estrellas por defecto
  String _feedbackMessage = '';
  DateTime? _feedbackDate; //fecha actual
  late Future<List<FeedbackCom>> _comentariosFuture; // Future para comentarios
  late Usuario user;
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    // Llama al método para cargar los comentarios en el inicio
    _comentariosFuture = _fetchComs();
    _userDataFuture = _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    setState(() {
      user = usuario;
    });
  }

  void _changeProfilePicture() {
    print('Cambiar foto de perfil');
  }

  void _postFeedback() async {
    setState(() {
      _feedbackDate = DateTime.now();
    });
    await _crearCom(_feedbackMessage, _filledStars);
    updateComentarios(); // Llamar a la función para actualizar los comentarios
  }

  @override
  void dispose() {
    _feedbackFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: Text(
                        usuario.nombre.substring(0, 2),
                        style: const TextStyle(fontSize: 75),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: const Color(0xffffde59),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Icon(Icons.person,
                                  size: 20, color: Colors.black54),
                              const SizedBox(width: 5),
                              FutureBuilder<void>(
                                future: _userDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                        'Cargando...'); // Muestra un indicador de carga mientras se obtiene el usuario
                                  }
                                  return Text(
                                    '${user.nombre} ${user.apellido}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pushNamed(context, 'editar');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.email,
                              size: 20, color: Colors.black54),
                          const SizedBox(width: 5),
                          Text(
                            usuario.correo,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.book,
                              size: 20, color: Colors.black54),
                          const SizedBox(width: 5),
                          Text(
                            'Semestre: ${usuario.semestre}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //Caja de comentarios al perfil del usuario
              const SizedBox(height: 20),
              const Text('Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FutureBuilder<List<FeedbackCom>>(
                future: _comentariosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final comentarios = snapshot.data ?? [];
                    if (comentarios.isEmpty) {
                      return const Text("No hay comentarios disponibles");
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = comentarios[index];
                        return ListTile(
                          title: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ProfileUserPage(
                                    uidHost: comentario.comentador),
                              ));
                            },
                            child: Text(
                              comentario.nombre,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comentario.mensaje),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text("No hay comentarios para mostrar");
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
    );
  }

  void updateComentarios() {
    setState(() {
      _comentariosFuture = _fetchComs();
    });
  }

  Future<void> _crearCom(String mensaje, int valoracion) async {
    try {
      final String url = ('${Environment.foroUrl}/feedback/agregar');
      String nombreCompleto = '${user.nombre} ${user.apellido}';

      Map<String, dynamic> data = {
        "comentador": user.uid,
        "receptor": user.uid,
        "nombre": nombreCompleto,
        "mensaje": mensaje,
        "valoracion": valoracion,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print('Comentario publicado: ${response.body}');
        setState(() {
          _feedbackMessage = '';
          _filledStars = 0;
        });
        updateComentarios();
      } else {
        print(
            'Error al publicar el comentario. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al publicar el comentario: $error');
    }
  }

  Future<List<FeedbackCom>> _fetchComs() async {
    try {
      final String url =
          ('${Environment.foroUrl}/feedback/receptor/${user.uid}');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<FeedbackCom> coms =
            postData.map((data) => FeedbackCom.fromJson(data)).toList();
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      return [];
    }
  }
}
