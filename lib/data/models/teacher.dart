class Teacher {
  String id;
  String name;
  Teacher({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
  factory Teacher.fromMap(Map<String, dynamic> map) =>
      Teacher(id: map['id'], name: map['name']);
}
