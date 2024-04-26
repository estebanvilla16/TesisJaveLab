class Ruta {
  int id_ruta;
  int id_user_mat;

  Ruta({required this.id_ruta, required this.id_user_mat});

  factory Ruta.fromJson(Map<String, dynamic> json) =>
      Ruta(id_ruta: json['id_ruta'], id_user_mat: json['id_user_mat']);
}