class UserxMateria {
  int id_user_mat;
  int materia;
  String usuario;

  UserxMateria(
      {required this.id_user_mat,
      required this.materia,
      required this.usuario});

  factory UserxMateria.fromJson(Map<String, dynamic> json) => UserxMateria(
      id_user_mat: json['id_user_mat'],
      materia: json['materia'],
      usuario: json['usuario']);
}