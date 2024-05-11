// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String nombre;
  String apellido;
  String correo;
  int semestre;
  bool fisicaMecanica;
  bool calculoDiferencial;
  bool pensamientoAlgoritmico;
  bool online;
  String uid;

  Usuario({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.semestre,
    required this.fisicaMecanica,
    required this.calculoDiferencial,
    required this.pensamientoAlgoritmico,
    required this.online,
    required this.uid,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      semestre: json['semestre'],
      fisicaMecanica: json['fisicaMecanica'],
      calculoDiferencial: json['calculoDiferencial'],
      pensamientoAlgoritmico: json['pensamientoAlgoritmico'],
      online: json['online'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido": apellido,
        "correo": correo,
        "semestre": semestre,
        "fisicaMecanica": fisicaMecanica,
        "calculoDiferencial": calculoDiferencial,
        "pensamientoAlgoritmico": pensamientoAlgoritmico,
        "online": online,
        "uid": uid,
      };
}
