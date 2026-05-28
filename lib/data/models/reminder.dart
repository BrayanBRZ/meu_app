import 'package:meu_app/data/enums/regularity.dart';

class Reminder {
  final String? id;
  final Regularity regularity;
  final bool isActive;

  Reminder({this.id, required this.regularity, this.isActive = true});

  factory Reminder.fromMap(Map<String, dynamic> map) =>
    Reminder(
      id: map['id'] as String,
      regularity: Regularity.values.byName(map['regularity'] as String),
      isActive: map['isActive'] as bool,
    );

  Map<String, dynamic> toMap() => {
      if (id != null) 'id': id,
      'regularity': regularity.name,
      'isActive': isActive,
    };
}