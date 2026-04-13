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
  final String id;
  String title;
  String description;
  TaskType type;
  DateTime currentDate;
  List<Subject> subjects;

  Task(
    this.id,
    this.title,
    this.description,
    this.type,
    this.currentDate,
    this.subjects,
  );

  // Getters

  String get labelType => type.label;

  int get remainingDays => currentDate.difference(DateTime.now()).inDays;

  // Business Rules

  DateTime get normalizedDate =>
      DateTime(currentDate.year, currentDate.month, currentDate.day);

  void remarkDate(DateTime newDate) => currentDate = newDate;

  void addSubject(Subject subject) {
    if (!subjects.contains(subject)) subjects.add(subject);
  }

  void disconnectSubject(Subject subject) {
    subjects.remove(subject);
  }

  String formattedDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
