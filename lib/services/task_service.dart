import 'package:meu_app/data/dao/reminder_dao.dart';
import 'package:meu_app/data/dao/task_dao.dart';
import 'package:meu_app/data/database/connection.dart';
import 'package:meu_app/data/models/reminder.dart';
import 'package:meu_app/data/models/task.dart';

class TaskService {
  Future<List<Task>> findAll() async {
    final database = await Connection.instance.database;
    return TaskDao(database).findAll();
  }

  Future<Task?> findById(int id) async {
    final database = await Connection.instance.database;
    return TaskDao(database).findById(id);
  }

  Future<Reminder?> findCustomReminder(Task task) async {
    final reminderId = task.reminderId;
    if (reminderId == null) return null;

    final database = await Connection.instance.database;
    return ReminderDao(database).findById(reminderId);
  }

  Future<int> create(Task task, {Reminder? customReminder}) async {
    final database = await Connection.instance.database;
    final reminderDao = ReminderDao(database);
    final taskDao = TaskDao(database);

    final reminderId = customReminder == null
        ? null
        : await reminderDao.insert(customReminder);

    try {
      return await taskDao.insert(_taskWithReminder(task, reminderId));
    } catch (_) {
      if (reminderId != null) await reminderDao.delete(reminderId);
      rethrow;
    }
  }

  Future<void> update(
    Task task, {
    Reminder? customReminder,
    int? previousReminderId,
  }) async {
    final database = await Connection.instance.database;
    final reminderDao = ReminderDao(database);
    final taskDao = TaskDao(database);

    int? reminderId;
    int? createdReminderId;
    if (customReminder != null) {
      if (previousReminderId == null) {
        reminderId = await reminderDao.insert(customReminder);
        createdReminderId = reminderId;
      } else {
        reminderId = previousReminderId;
        await reminderDao.update(_reminderWithId(customReminder, reminderId));
      }
    } else if (previousReminderId != null) {
      await reminderDao.delete(previousReminderId);
    }

    try {
      await taskDao.update(_taskWithReminder(task, reminderId));
    } catch (_) {
      if (createdReminderId != null) {
        await reminderDao.delete(createdReminderId);
      }
      rethrow;
    }
  }

  Future<void> delete(Task task) async {
    final database = await Connection.instance.database;
    await TaskDao(database).delete(task.id!);

    final reminderId = task.reminderId;
    if (reminderId != null) {
      await ReminderDao(database).delete(reminderId);
    }
  }

  Task _taskWithReminder(Task task, int? reminderId) {
    return Task(
      id: task.id,
      title: task.title,
      regularity: task.regularity,
      targetDate: task.targetDate,
      tagId: task.tagId,
      subjectId: task.subjectId,
      reminderId: reminderId,
      description: task.description,
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
