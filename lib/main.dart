import 'package:JaveLab/routes/routes.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:JaveLab/services/chat_service.dart';
import 'package:JaveLab/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // quita el banner de debug
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'loading', // ruta inicial 'loading' inicio.dart
        routes: appRoutes, // rutas de la aplicación
      ),
    );
  }
}
