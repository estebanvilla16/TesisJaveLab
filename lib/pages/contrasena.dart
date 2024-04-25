//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de solicitud de recuperacion de contrasena.
import 'package:flutter/material.dart';
import 'inicio.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    color: const Color(0xff2c5697),
                    child: const Text(
                      'Pontificia Universidad Javeriana',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    color: const Color(0xffffde59),
                    child: const Text(
                      'Javelab Ingenieria de sistemas',
                      style: TextStyle(color: Color(0xff2c5697), fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  LoginScreen()),
                                );
                              },
                            ),
                            const Text(
                              'Olvidé la contraseña',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2c5697)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Nueva contraseña',
                          style: TextStyle(fontSize: 16, color: Color(0xff2c5697)),
                          textAlign: TextAlign.center,
                        ), //INPUT para el ingreso de correo electronico
                        const SizedBox(height: 20),
                        const Text('Por favor ingrese el correo electrónico'),
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            hintText: 'Correo electrónico',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff2c5697),
                          ),
                          child: const Text('Enviar', style: TextStyle(fontSize: 24)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              const Divider(color: Colors.black, thickness: 1),
              Row(
                // Footer
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset('assets/imgs/min_educacion.png', width: 80, height: 80),
                  Image.asset('assets/imgs/logo.png', width: 80, height: 80),

                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
