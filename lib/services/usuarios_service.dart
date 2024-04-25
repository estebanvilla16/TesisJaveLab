

import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/usuarios_response.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:JaveLab/models/usuario.dart';

class UsuariosService {
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
   
}