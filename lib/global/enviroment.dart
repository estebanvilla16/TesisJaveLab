import 'dart:io';

class Environment {
  //Servico Rest
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.1.6:3000/api'
      : 'http://localhost:3000/api';
  //Socket
  static String socketUrl =
      Platform.isAndroid ? 'http://192.168.1.6:3000' : 'http://localhost:3000';

  static String academicUrl =
      Platform.isAndroid ? 'http://192.168.1.6:3011' : 'http://localhost:3011';

  static String foroUrl =
      Platform.isAndroid ? 'http://192.168.1.6:3010' : 'http://localhost:3010';

  static String blobUrl =
      Platform.isAndroid ? 'http://192.168.1.6:8080' : 'http://localhost:8080';

  static String correoJave = 'javelab2024@gmail.com';
  static String passJave = 'TesisJaveL@b2024';
  
}
