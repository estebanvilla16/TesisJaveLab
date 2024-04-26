class Tema {
  int id_tema;
  int ruta;
  int contenido;
  String titulo;
  String foto;
  String estado;

  Tema(
      {required this.id_tema,
      required this.ruta,
      required this.contenido,
      required this.titulo,
      required this.foto,
      required this.estado});

  factory Tema.fromJson(Map<String, dynamic> json) => Tema(
      id_tema: json['id_tema'],
      ruta: json['ruta'],
      contenido: json['contenido'],
      titulo: json['titulo'],
      foto: json['foto'],
      estado: json['estado']);
}