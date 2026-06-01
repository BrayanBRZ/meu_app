import 'package:meu_app/data/constants/default_tags.dart';
import 'package:meu_app/data/enums/regularity.dart';

class Task {
  final int? id;
  final String title;
  final Regularity regularity;
  final DateTime targetDate;
  final int tagId;
  final int? subjectId;
  final int? reminderId;
  final String? description;

  Task({
    this.id,
    required String title,
    required this.regularity,
    required this.targetDate,
    this.tagId = DefaultTags.commonId,
    this.subjectId,
    this.reminderId,
    String? description,
  }) : title = title.trim(),
       description = description?.trim();

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    regularity: Regularity.values.byName(map['regularity'] as String),
    targetDate: DateTime.parse(map['target_date'] as String),
    tagId: map['tag_id'] as int? ?? DefaultTags.commonId,
    subjectId: map['subject_id'] as int?,
    reminderId: map['reminder_id'] as int?,
    description: map['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'regularity': regularity.name,
    'target_date': targetDate.toIso8601String(),
    'tag_id': tagId,
    'subject_id': subjectId,
    'reminder_id': reminderId,
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
