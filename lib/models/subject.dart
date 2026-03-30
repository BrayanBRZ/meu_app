import 'package:flutter/material.dart';

class Subject {
  final String id;
  String name;
  String corHex;

  Subject({
    required this.id,
    required this.name,
    required this.corHex
  });

  // Getters
  Color get color {
    final hex = corHex.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String get symbol => name.isNotEmpty ? name[0].toUpperCase() : '?';

  // Contratos de identidade e cópia
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject && runtimeType == other.runtimeType && id == other.id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Subject(id: $id, name: $name)';

  Subject copyWith({
    String? name,
    String? corHex,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      corHex: corHex ?? this.corHex,
    );
  }
}