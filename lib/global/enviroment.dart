import 'dart:io';

class Environment {
  //Servico Rest
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.56.1:3000/api'
      : 'http://localhost:3000/api';
  //Socket
  static String socketUrl =
      Platform.isAndroid ? 'http://192.168.56.1:3000' : 'http://localhost:3000';

  static String academicUrl =
      Platform.isAndroid ? 'http://192.168.56.1:3011' : 'http://localhost:3011';

  static String foroUrl =
      Platform.isAndroid ? 'http://192.168.56.1:3010' : 'http://localhost:3010';

  static String blobUrl =
      Platform.isAndroid ? 'http://192.168.56.1:8080' : 'http://localhost:8080';
}
