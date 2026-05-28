import 'package:flutter/material.dart';

class Tag {
  final String? id;
  final String title;
  final String? reminderId;
  final Color color;

  Tag({
    this.id,
    required String title,
    this.reminderId,
    this.color = Colors.white,
  }) : title = title.trim();

  factory Tag.fromMap(Map<String, dynamic> map) => Tag(
    id: map['id'] as String,
    title: map['title'] as String,
    reminderId: map['reminderId'] as String?,
    color: Color(map['color'] as int),
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'color': color.toARGB32(),
  };
}
