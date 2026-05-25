class Semester {
  String id;
  String name;
  Semester({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
  factory Semester.fromMap(Map<String, dynamic> map) =>
      Semester(id: map['id'], name: map['name']);
}
