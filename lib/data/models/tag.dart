import 'package:flutter/material.dart';

class Tag {
  final int? id;
  final String title;
  final Color color;
  final int reminderId;

  Tag({
    this.id,
    required String title,
    this.color = Colors.white,
    required this.reminderId,
  }) : title = title.trim();

  factory Tag.fromMap(Map<String, dynamic> map) => Tag(
    id: map['id'] as int?,
    title: map['title'] as String,
    color: Color(map['color'] as int),
    reminderId: map['reminder_id'] as int,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'color': color.toARGB32(),
    'reminder_id': reminderId,
  };
}
