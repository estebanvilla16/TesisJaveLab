

import 'dart:io';

class Envirenment {
  //Servico Rest
  static String apiUrl = Platform.isAndroid ? 'http://192.168.10.34:3000/api':'http://localhost:3000/api';
  //Socket
  static String socketUrl = Platform.isAndroid ? 'http://192.168.10.34:3000 ':'http://localhost:3000';
}