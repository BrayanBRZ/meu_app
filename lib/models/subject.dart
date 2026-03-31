import 'package:flutter/material.dart';
import 'package:meu_app/models/task.dart';

class Subject {
  final String id;
  String name;
  Color color = const Color.fromARGB(255, 124, 21, 192);
  List<Task> relatedTasks;

  Subject({
    required this.id, 
    required this.name,
    required this.color,
    List<Task>? relatedTasks,
  }) : relatedTasks = relatedTasks ?? [];

  // Getters
  String get symbol => name[0].toUpperCase();
}