class Syllabus {
  int id_syllabus;
  int id_mat;

  Syllabus({required this.id_syllabus, required this.id_mat});

  factory Syllabus.fromJson(Map<String, dynamic> json) =>
      Syllabus(id_syllabus: json['id_syllabus'], id_mat: json['id_mat']);
}