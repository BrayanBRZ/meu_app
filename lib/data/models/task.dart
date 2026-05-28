import 'package:meu_app/data/enums/regularity.dart';

class Task {
  final String? id;
  final String title;
  final Regularity regularity;
  final DateTime targetDate;
  final String tagId;
  final String subjectId;
  final String? reminderId;
  final String? description;

  Task({
    this.id,
    required String title,
    required this.regularity,
    required this.targetDate,
    required this.tagId,
    required this.subjectId,
    this.reminderId,
    String? description,
  }) : title = title.trim(),
       description = description?.trim();

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as String,
    title: map['title'] as String,
    regularity: Regularity.values.byName(map['regularity'] as String),
    targetDate: DateTime.parse(map['targetDate'] as String),
    tagId: map['tagId'] as String,
    subjectId: map['subjectId'] as String,
    reminderId: map['reminderId'] as String,
    description: map['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'regularity': regularity.name,
    'targetDate': targetDate.toIso8601String(),
    'tagId': tagId,
    'subjectId': subjectId,
    'reminderId': reminderId,
    'description': description,
  };

  // Getters

  bool get hasDescription => description != null && description!.isNotEmpty; 

  int get remainingDays => targetDate.difference(DateTime.now()).inDays;

  DateTime get normalizedDate =>
      DateTime(targetDate.year, targetDate.month, targetDate.day);

  String get formattedDate =>
      '${targetDate.day.toString().padLeft(2, '0')}/${targetDate.month.toString().padLeft(2, '0')}/${targetDate.year}';
}
