import 'dart:convert';

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/login_response.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = const FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = const FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String correo, String contrsena) async {
    _autenticando = true;

    final data = {'correo': correo, 'contrasena': contrsena};

    final uri = Uri.parse('${Envirenment.apiUrl}/login');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});


    _autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(
      String nombre,
      String apellido,
      String correo,
      String contrasena,
      int semestre,
      bool fisicaMecanica,
      bool calculoDiferencial,
      bool pensamientoAlgoritmico) async {
    _autenticando = true;

    final data = {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'contrasena': contrasena,
      'semestre': semestre,
      'fisicaMecanica': fisicaMecanica,
      'calculoDiferencial': calculoDiferencial,
      'pensamientoAlgoritmico': pensamientoAlgoritmico
    };

    final uri = Uri.parse('${Envirenment.apiUrl}/login/new');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});


    _autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    
    final uri = Uri.parse('${Envirenment.apiUrl}/login/renew');
    final resp = await http.post(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );


    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }

}

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
