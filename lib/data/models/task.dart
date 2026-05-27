import 'package:meu_app/data/enum/regularity.dart';
import 'package:meu_app/data/models/reminder.dart';

class Task {
  final String? id;
  final String title;
  final Regularity regularity;
  final DateTime targetDate;
  final String tagId;
  final String subjectId;
  final Reminder? reminderId;
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
       description = description?.trim() {
    if (this.title.isEmpty) {
      throw ArgumentError('Título é obrigatório.');
    }

    if (tagId.trim().isEmpty) {
      throw ArgumentError('Tag é obrigatória.');
    }

    if (subjectId.trim().isEmpty) {
      throw ArgumentError('Matéria é obrigatória.');
    }
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task (
      id: map['id'] as String,
    );
  }

  // Getters

  //   String get labelType => type.label;

  //   int get remainingDays => currentDate.difference(DateTime.now()).inDays;

  //   // Business Rules

  //   DateTime get normalizedDate =>
  //       DateTime(currentDate.year, currentDate.month, currentDate.day);

  //   void remarkDate(DateTime newDate) => currentDate = newDate;

  //   String formattedDate(DateTime date) =>
  //       '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
