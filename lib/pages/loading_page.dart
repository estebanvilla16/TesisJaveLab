import 'package:JaveLab/pages/inicio.dart';
import 'package:JaveLab/pages/main_app.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: ( context, snapshot) { 
          return  const Center(
          child: Text('Autenticando...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn(); 

    if(autenticado){
      //TODO: conectar socket service

      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) => const Principal(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_,__,___) =>  LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }
  }

}
