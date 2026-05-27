import 'package:flutter/material.dart';

class Subject {
  String id;
  String name;
  Color color;
  String teacherId;
  String semesterId;

  Subject({
    required this.id,
    required this.name,
    required this.color,
    required this.teacherId,
    required this.semesterId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'color': color.toARGB32(),
    'teacherId': teacherId,
    'semesterId': semesterId,
  };

  factory Subject.fromMap(Map<String, dynamic> map) => Subject(
    id: map['id'],
    name: map['name'],
    color: Color(map['color'] as int),
    teacherId: map['teacherId'],
    semesterId: map['semesterId'],
  );
}
