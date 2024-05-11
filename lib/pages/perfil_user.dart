import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/usuarios_service.dart';
import 'package:JaveLab/models/feedback.dart';
import 'package:JaveLab/widgets/bottom_menu.dart';
import 'package:JaveLab/widgets/burgermenu.dart';

class ProfileUserPage extends StatefulWidget {
  final String uidHost;

  const ProfileUserPage({Key? key, required this.uidHost}) : super(key: key);

  @override
  _ProfilePageUserState createState() => _ProfilePageUserState();
}

class _ProfilePageUserState extends State<ProfileUserPage> {
  final FocusNode _feedbackFocusNode = FocusNode();
  int _filledStars = 0;
  String _feedbackMessage = '';
  DateTime? _feedbackDate;
  late Future<List<FeedbackCom>> _comentariosFuture;
  late Usuario user;
  late Future<void> _userDataFuture;
  Usuario? user1;
  final userService = UsuariosService();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
    _fetchHostData(widget.uidHost);
    _comentariosFuture = _fetchComs(widget.uidHost);
  }

  Future<Usuario?> _fetchHostData(String hostid) async {
    try {
      user1 = await userService.getUsuario(widget.uidHost);
      setState(() {
        _refreshController.refreshCompleted();
      });
      return user1;
    } catch (error) {
      print('Error al obtener datos del usuario: $error');
      return null;
    }
  }

  Future<List<FeedbackCom>> _fetchComs(String uid) async {
    try {
      final String url = ('${Environment.foroUrl}/feedback/receptor/$uid');
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> postData = jsonDecode(response.body);
        final List<FeedbackCom> coms =
            postData.map((data) => FeedbackCom.fromJson(data)).toList();
        return coms;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (error) {
      return Future.value([]);
    }
  }

  Future<void> _fetchUserData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final usuario = authService.usuario;
    setState(() {
      user = usuario;
    });
  }

  void updateComentarios() {
    setState(() {
      _comentariosFuture = _fetchComs(widget.uidHost);
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
  }

  @override
  void dispose() {
    _feedbackFocusNode.dispose();
    _refreshController.dispose();
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
                child: FutureBuilder<Usuario?>(
                  future: _fetchHostData(widget.uidHost),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return CircleAvatar(
                        radius: 100,
                        child: Text(
                          snapshot.data!.nombre.substring(0, 2),
                          style: const TextStyle(fontSize: 75),
                        ),
                      );
                    } else {
                      return Text("No se pudo cargar el usuario");
                    }
                  },
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
                                    '${user1?.nombre ?? "Cargando nombre"} ${user1?.apellido ?? ""}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          if (widget.uidHost == user.uid)
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
                            user1?.correo ?? "Cargando correo",
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
                            'Semestre: ${user1?.semestre ?? "Cargando semestre"}',
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
                  child: const Text('Publicar retroalimentación'),
                ),
              ),
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
                          trailing: PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              if (comentario.comentador ==
                                  user.uid) // Control de acceso para editar y borrar comentario
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Eliminar comentario'),
                                  ),
                                ),
                            ].where((item) => item != null).toList(),
                            onSelected: (String value) {
                              if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Confirmar eliminación"),
                                      content: const Text(
                                          "¿Estás seguro de que quieres eliminar este comentario?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteComment(comentario.id);
                                            Navigator.of(context).pop();
                                            updateComentarios();
                                          },
                                          child: const Text("Eliminar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
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

  void _deleteComment(int id) async {
    final String url = ('${Environment.foroUrl}/feedback/borrar/$id');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Comentario eliminado: ${response.statusCode}');
      updateComentarios();
    } else {
      print(
          'Error al eliminar el comentario. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> _crearCom(String mensaje, int valoracion) async {
    try {
      final String url = ('${Environment.foroUrl}/feedback/agregar');
      String nombreCompleto = '${user.nombre} ${user.apellido}';

      Map<String, dynamic> data = {
        "comentador": user.uid,
        "receptor": user1!.uid,
        "nombre": nombreCompleto,
        "mensaje": mensaje,
        "valoracion": _filledStars,
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
      } else {
        print(
            'Error al publicar el comentario. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al publicar el comentario: $error');
    }
  }
}
