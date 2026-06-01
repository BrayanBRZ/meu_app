import 'package:meu_app/data/dao/reminder_dao.dart';
import 'package:meu_app/data/dao/tag_dao.dart';
import 'package:meu_app/data/database/connection.dart';
import 'package:meu_app/data/models/reminder.dart';
import 'package:meu_app/data/models/tag.dart';

class TagService {
  Future<List<Tag>> findAll() async {
    final database = await Connection.instance.database;
    return TagDao(database).findAll();
  }

  Future<Tag?> findById(int id) async {
    final database = await Connection.instance.database;
    return TagDao(database).findById(id);
  }

  Future<Reminder?> findReminder(Tag tag) async {
    final database = await Connection.instance.database;
    final reminderId = tag.reminderId;
    if (reminderId == null) return null;
    return ReminderDao(database).findById(reminderId);
  }

  Future<int> create(Tag tag, Reminder reminder) async {
    final database = await Connection.instance.database;
    final reminderDao = ReminderDao(database);
    final tagDao = TagDao(database);

    final reminderId = await reminderDao.insert(reminder);
    try {
      return await tagDao.insert(_tagWithReminder(tag, reminderId));
    } catch (_) {
      await reminderDao.delete(reminderId);
      rethrow;
    }
  }

  Future<void> update(Tag tag, Reminder reminder) async {
    if (!tag.isEditable) {
      throw StateError('Default tags cannot be updated');
    }

    final database = await Connection.instance.database;
    final reminderId = tag.reminderId;
    if (reminderId == null) {
      throw ArgumentError.value(tag, 'tag', 'reminderId is required');
    }

    await ReminderDao(database).update(_reminderWithId(reminder, reminderId));
    await TagDao(database).update(tag);
  }

  Future<void> delete(Tag tag) async {
    if (!tag.isEditable) {
      throw StateError('Default tags cannot be deleted');
    }

    final database = await Connection.instance.database;
    await TagDao(database).delete(tag.id!);
  }

  Tag _tagWithReminder(Tag tag, int reminderId) {
    return Tag(
      id: tag.id,
      title: tag.title,
      color: tag.color,
      reminderId: reminderId,
      isDefault: tag.isDefault,
    );
  }

  Reminder _reminderWithId(Reminder reminder, int id) {
    return Reminder(
      id: id,
      regularity: reminder.regularity,
      regularTime: reminder.regularTime,
      remindBefore: reminder.remindBefore,
      isActive: reminder.isActive,
    );
  }
}
