class FeedbackCom {
  int id;
  String comentador;
  String receptor;
  String nombre;
  String mensaje;
  int valor;

  FeedbackCom(
      {required this.id,
      required this.comentador,
      required this.receptor,
      required this.nombre,
      required this.mensaje,
      required this.valor});

  factory FeedbackCom.fromJson(Map<String, dynamic> json) => FeedbackCom(
        id: json['id_feed'],
        comentador: json['id_comentador'],
        receptor: json['id_receptor'],
        nombre: json['nombre'],
        mensaje: json['mensaje'],
        valor: json['valor'],
      );
}