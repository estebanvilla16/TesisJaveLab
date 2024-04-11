class ComentarioTema {
  int id_com;
  int id_comentador;
  int id_tema;
  String nombre;
  String mensaje;
  int valoracion;
  DateTime fecha;

  ComentarioTema(
      {required this.id_com,
      required this.id_comentador,
      required this.id_tema,
      required this.nombre,
      required this.mensaje,
      required this.valoracion,
      required this.fecha});

  factory ComentarioTema.fromJson(Map<String, dynamic> json) => ComentarioTema(
      id_com: json['id_com'],
      id_comentador: json['id_comentador'],
      id_tema: json['id_tema'],
      nombre: json['nombre'],
      mensaje: json['mensaje'],
      valoracion: json['valoracion'],
      fecha: DateTime.parse(json['fecha']));
}
