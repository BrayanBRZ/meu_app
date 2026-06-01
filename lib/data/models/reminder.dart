import 'package:meu_app/data/enums/regularity.dart';

class Reminder {
  static final DateTime defaultRegularTime = DateTime(1970, 1, 1, 12);
  static const Duration defaultRemindBefore = Duration(minutes: 30);

  final int? id;
  final Regularity regularity;
  final DateTime regularTime;
  final Duration remindBefore;
  final bool isActive;

  Reminder({
    this.id,
    required this.regularity,
    DateTime? regularTime,
    Duration? remindBefore,
    this.isActive = true,
  }) : regularTime = regularTime ?? defaultRegularTime,
       remindBefore = remindBefore ?? defaultRemindBefore;

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      regularity: Regularity.values.byName(map['regularity'] as String),
      regularTime: DateTime.parse(map['regular_time'] as String),
      remindBefore: Duration(minutes: map['remind_before'] as int),
      isActive: (map['is_active'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'regularity': regularity.name,
      'regular_time': regularTime.toIso8601String(),
      'remind_before': remindBefore.inMinutes,
      'is_active': isActive ? 1 : 0,
    };
  }
}
