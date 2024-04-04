import 'dart:convert';

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/login_response.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  
  late Usuario usuario;
  bool _autenticando = false;

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  Future login(String correo, String contrsena) async{

    _autenticando = true;

    final data = {
      'correo': correo,
      'contrasena': contrsena
    };


   final uri = Uri.parse('${Envirenment.apiUrl}/login');
   final resp = await http.post(
    uri,
    body: jsonEncode(data),
    headers: {
      'Content-Type': 'application/json'
      }
    );

     print(resp.body);


    if(resp.statusCode == 200){
     final loginResponse = loginResponseFromJson(resp.body);
     usuario = loginResponse.usuario;
    }

    _autenticando = false;

  }
}