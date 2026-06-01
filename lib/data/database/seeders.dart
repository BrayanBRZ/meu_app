import 'package:meu_app/data/constants/default_tags.dart';

class Seeders {
  Seeders._();

  static const List<String> initialInserts = [
    '''
      INSERT OR IGNORE INTO reminder(
        id,
        regularity,
        regular_time,
        remind_before,
        is_active
      )
      VALUES(1, 'single', '1970-01-01T12:00:00.000', 30, 1)
    ''',
    '''
      INSERT OR IGNORE INTO reminder(
        id,
        regularity,
        regular_time,
        remind_before,
        is_active
      )
      VALUES(2, 'single', '1970-01-01T12:00:00.000', 30, 1)
    ''',
    '''
      INSERT OR IGNORE INTO tag(id, title, color, reminder_id, is_default)
      VALUES(
        ${DefaultTags.commonId},
        '${DefaultTags.commonTitle}',
        ${DefaultTags.commonColor},
        1,
        1
      )
    ''',
    '''
      INSERT OR IGNORE INTO tag(id, title, color, reminder_id, is_default)
      VALUES(
        ${DefaultTags.urgentId},
        '${DefaultTags.urgentTitle}',
        ${DefaultTags.urgentColor},
        2,
        1
      )
    ''',
  ];
}
