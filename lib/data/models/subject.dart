class Subject {
  final int? id;
  final String title;

  Subject({this.id, required String title}) : title = title.trim();

  factory Subject.fromMap(Map<String, dynamic> map) =>
      Subject(id: map['id'] as int?, title: map['title'] as String);

  Map<String, dynamic> toMap() => {if (id != null) 'id': id, 'title': title};
}
