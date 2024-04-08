//Trabajo Realizado para proyecto de grado - JaveLab.
//Pantalla de categoria de foro y boton de creacion de post.

import 'package:JaveLab/helpers/mostrar_alerta.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/widgets/boton_azul.dart';
import 'package:JaveLab/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registro.dart';
import '../contrasena.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Column(
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
              'Javelab Ingeniería de Sistemas',
              style: TextStyle(color: Color(0xff2c5697), fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Inicio de sesión',
                  style: TextStyle(fontSize: 28, color: Color(0xff2c5697)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ingrese para continuar',
                  style: TextStyle(fontSize: 12, color: Color(0xffffde59)),
                  textAlign: TextAlign.center,
                ),

                //Inputb de correo electronico javeriano y contrasena validada en nuestra BD
                const SizedBox(height: 40),
                const Text('Por favor ingrese el correo'),

                CustomInput(
                  icon: Icons.mail_outline,
                  placeholder: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  textController: emailController,
                ), //Text field de correo

                const Text('Por favor ingrese la contraseña'),

                CustomInput(
                  icon: Icons.lock_outline,
                  placeholder: 'Contraseña',
                  textController: passwordController,
                  isPassword: true,
                ), //Text field de contrasena

                BotonAzul(
                  text: 'Iniciar sesión',
                  onPressed: authService.autenticando
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();

                          final loginOk = await authService.login(
                              emailController.text.trim(),
                              passwordController.text.trim());
                          if (loginOk) {
                            Navigator.pushReplacementNamed(context, 'inicio');
                          } else {
                            //Mostrar alerta
                            mostrarAlerta(context, 'Login incorrecto',
                                'Revise sus credenciales nuevamente');
                          }
                        },
                ), //Boton de inicio de sesion

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        //Botones alternativos para registrarse si no posee cuenta o recuperar contrasena
                        'Registrarse',
                        style:
                            TextStyle(color: Color(0xff2c5697), fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Olvidé la contraseña',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff2c5697)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(color: Colors.black, thickness: 1),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // footer
                Image.asset('assets/imgs/min_educacion.png',
                    width: 80, height: 80),
                Image.asset('assets/imgs/logo.png', width: 80, height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
