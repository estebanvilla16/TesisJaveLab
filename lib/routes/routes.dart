import 'package:JaveLab/pages/contrasena.dart';
import 'package:JaveLab/pages/crear_post.dart';
import 'package:JaveLab/pages/editar_perfil.dart';
import 'package:JaveLab/pages/foro.dart';
import 'package:JaveLab/pages/main_app.dart';
import 'package:JaveLab/pages/perfil.dart';
import 'package:JaveLab/pages/ruta_academica.dart';
import 'package:flutter/material.dart';
import 'package:JaveLab/pages/chat_page.dart';
import 'package:JaveLab/pages/inicio.dart';
import 'package:JaveLab/pages/loading_page.dart';
import 'package:JaveLab/pages/registro.dart';
import 'package:JaveLab/pages/usuarios_page.dart';



 final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => const UsuariosPage(),
  'chat': (_) => const ChatPage(),
  'login': (_) =>  LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'loading': (_) => const LoadingPage(),
  'new_post': (_) => const Cara8(),
  'foro': (_) => const Cara6(),
  'perfil': (_) => const ProfilePage(),
  'inicio': (_) => const Principal(),
  'cambio': (_) => const ForgotPasswordScreen(),
  'ruta': (_) => const PantallaRutaAprendizaje(),
  'editar': (_) => const EditProfileScreen(),
};
