//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de perfil de usuario
import 'dart:convert';

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/usuario.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Theme.of(context).primaryColor,
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
                    const CircleAvatar(
                      radius: 100,
                      backgroundImage:
                          AssetImage('assets/icon/foto_perfil.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _changeProfilePicture,
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
                              Icon(Icons.person,
                                  size: 20, color: Colors.black54),
                              SizedBox(width: 5),
                              FutureBuilder<void>(
                                future: _userDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text(
                                        'Cargando...'); // Muestra un indicador de carga mientras se obtiene el usuario
                                  }
                                  return Text(
                                    '${user.nombre} ${user.apellido}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {
                              // Acción para iniciar un chat
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: <Widget>[
                          Icon(Icons.work, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            'Monitor',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Row(
                        children: <Widget>[
                          Icon(Icons.school, size: 20, color: Colors.black54),
                          SizedBox(width: 5),
                          Text(
                            'Pensamiento Algorítmico',
                            style: TextStyle(
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
              const SizedBox(height: 20),
              //Caja de comentarios al perfil del usuario
              const Text('Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              FutureBuilder<List<FeedbackCom>>(
                future: _comentariosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final comentarios = snapshot.data!;
                    // Limitar la cantidad de comentarios a 5
                    final limitedComentarios = comentarios.length > 5
                        ? comentarios.sublist(0, 5)
                        : comentarios;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: limitedComentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = limitedComentarios[index];
                        return Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              '${comentario.nombre}: ${comentario.mensaje}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              '${comentario.valor}/5',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Escribir feedback',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _filledStars = i;
                            });
                          },
                          onHover: (hovering) {
                            if (hovering) {
                              setState(() {
                                _filledStars = i;
                              });
                            }
                          },
                          child: Icon(
                            Icons.star,
                            color:
                                i <= _filledStars ? Colors.amber : Colors.grey,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                focusNode: _feedbackFocusNode,
                maxLines: 3,
                onChanged: (message) {
                  setState(() {
                    _feedbackMessage = message;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Escribe tu feedback aquí...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _postFeedback,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff365b6d),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text('Post Feedback'),
                ),
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
        "receptor": "223",
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
      final String url = ('${Environment.foroUrl}/feedback/lista-feedback');
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
