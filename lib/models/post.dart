class Post {
  int id_post;
  String id_op;
  int etiqueta;
  String titulo;
  String contenido;
  String material;
  String video;
  int valoracion;
  DateTime fecha;
  String nombre;

  Post({
    required this.id_post,
    required this.id_op,
    required this.etiqueta,
    required this.titulo,
    required this.contenido,
    required this.material,
    required this.video,
    required this.valoracion,
    required this.fecha,
    required this.nombre,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id_post: json['id_post'],
        id_op: json['id_op'],
        etiqueta: json['etiqueta'],
        titulo: json['titulo'],
        contenido: json['contenido'],
        material: json['material'],
        video: json['video'],
        valoracion: json['valoracion'],
        fecha: DateTime.parse(json['fecha']),
        nombre: json['nombre'],
      );
}