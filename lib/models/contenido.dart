class Contenido {
  int id_contenido;
  String titulo;
  int id_syl;
  String material;
  String descripcion;
  String video;

  Contenido({
    required this.id_contenido,
    required this.titulo,
    required this.id_syl,
    required this.material,
    required this.descripcion,
    required this.video,
  });

  factory Contenido.fromJson(Map<String, dynamic> json) => Contenido(
        id_contenido: json['id_contenido'],
        titulo: json['titulo'],
        id_syl: json['id_syl'],
        material: json['material'],
        descripcion: json['descripcion'],
        video: json['video'],
      );
}
