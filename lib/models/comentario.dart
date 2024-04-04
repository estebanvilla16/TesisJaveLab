
class Comentario {
  int id_com;
  int id_comentador;
  int id_post;
  String nombre;
  String mensaje;
  int valoracion;
  DateTime fecha;

  Comentario(
      {required this.id_com,
      required this.id_comentador,
      required this.id_post,
      required this.nombre,
      required this.mensaje,
      required this.valoracion,
      required this.fecha});

  factory Comentario.fromJson(Map<String, dynamic> json) => Comentario(
      id_com: json['id_com'],
      id_comentador: json['id_comentador'],
      id_post: json['id_post'],
      nombre: json['nombre'],
      mensaje: json['mensaje'],
      valoracion: json['valoracion'],
      fecha: DateTime.parse(json['fecha']));
}