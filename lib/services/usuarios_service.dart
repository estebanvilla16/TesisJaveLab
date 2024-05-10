import 'dart:convert';

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/usuarios_response.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:JaveLab/models/usuario.dart';

class UsuariosService {

  
  //Obtner lista de usuarios
  Future<List<Usuario>> getUsuarios() async {
    try {

     final uri = Uri.parse('${Environment.apiUrl}/usuarios');
     final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token':  await AuthService.getToken() ?? ''
      }
    );

    final usuariosResponse = usuariosResponseFromJson(resp.body);

    return usuariosResponse.usuarios;
      
    } catch (e) {
      return [];
    }
  }

  //Actualizar usuario
  Future updateUser(
    String uid,
    String nombre,
    String apellido,  
    int semestre,
    bool fisicaMecanica,
    bool calculoDiferencial,
    bool pensamientoAlgoritmico,) async {

  final data = {
    'uid': uid,
    'nombre': nombre,
    'apellido': apellido,
    'semestre': semestre,
    'fisicaMecanica': fisicaMecanica,
    'calculoDiferencial': calculoDiferencial,
    'pensamientoAlgoritmico': pensamientoAlgoritmico,
  };


  final uri = Uri.parse('${Environment.apiUrl}/usuarios/editar/$uid');
  final resp = await http.put(

    uri,
    body: jsonEncode(data),
    headers: {
        'Content-Type': 'application/json',
        'x-token':  await AuthService.getToken() ?? ''
      }

      
  );

  if (resp.statusCode == 200) {

    return true;
  } else {

    return false; // Podrías mostrar este mensaje en caso de error
  }
}

   
}