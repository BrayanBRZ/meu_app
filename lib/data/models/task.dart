import 'package:flutter/material.dart';

import 'subject.dart';

enum TaskType {
  test,
  work;

  String get label => switch (this) {
    TaskType.test => 'Prova',
    TaskType.work => 'Trabalho',
  };

  IconData get symbol => switch (this) {
    TaskType.test => Icons.assignment_late,
    TaskType.work => Icons.assignment,
  };
}

class Task {
  String id;
  String title;
  String description;
  TaskType type;
  DateTime currentDate;
  String subjectId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.currentDate,
    required this.subjectId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type.name,
    'currentDate': currentDate.toIso8601String(),
    'subjectId': subjectId,
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    type: TaskType.values.byName(map['type']),
    currentDate: DateTime.parse(map['currentDate']),
    subjectId: map['subjectId'],
  );
}
