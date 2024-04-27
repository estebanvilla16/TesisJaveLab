import 'package:JaveLab/global/enviroment.dart';
import 'package:JaveLab/models/mensajes_response.dart';
import 'package:JaveLab/models/usuario.dart';
import 'package:JaveLab/services/auth_service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';


class ChatService with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    
    try {
      final uri = Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId');
      final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token':  await AuthService.getToken() ?? ''
      } );

      final mensajesResp = mensajesResponseFromJson(resp.body);

      return mensajesResp.mensajes;
      

    } catch (e) {
      return [];
    }

  }

}
 



