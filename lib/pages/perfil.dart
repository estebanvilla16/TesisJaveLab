//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de perfil de usuario
import 'package:flutter/material.dart';
import '../widgets/bottom_menu.dart';
import '../widgets/burgermenu.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ProfilePage> {
  final FocusNode _feedbackFocusNode = FocusNode();
  int _filledStars = 0; //0 estrellas por defecto
  String _feedbackMessage = '';
  DateTime? _feedbackDate; //fecha actual

  void _changeProfilePicture() {
    print('Cambiar foto de perfil');
  }

  void _postFeedback() {
    setState(() {
      _feedbackDate = DateTime.now();
    });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage('assets/icon/foto_perfil.jpeg'),
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
                  //Cointener amarillo para la informacion basica del usuario
                  const SizedBox(height: 10),
                  Container(
                    color: const Color(0xffffde59),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Row(
                                children: <Widget>[
                                  Icon(Icons.person, size: 20, color: Colors.black54),
                                  SizedBox(width: 5),
                                  Text(
                                    'Esteban Villa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
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
                  const Text('Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _feedbackMessage,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$_filledStars/5',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            if (_feedbackDate != null)
                              Text(
                                '${_feedbackDate!.day}/${_feedbackDate!.month}/${_feedbackDate!.year}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Escribir feedback',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                color: i <= _filledStars ? Colors.amber : Colors.grey,
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
                      onPressed: () {
                        _postFeedback();
                      },
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
      endDrawer: const BurgerMenu(),
    );
  }
}
