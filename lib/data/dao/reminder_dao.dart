import 'package:sqflite/sqflite.dart';

import '../models/reminder.dart';

class ReminderDao {
  ReminderDao(this._database);

  final Database _database;

  static const String _table = 'reminder';

  // essencial methods

  Future<void> insert(Reminder reminder) async {
    await _database.insert(_table, reminder.toMap());
  }

  Future<void> delete(int id) async {
    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Reminder reminder) async {
    await _database.update(
      _table,
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  // query methods

  Future<Reminder?> findById(int id) async {
    final result = await _database.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    return Reminder.fromMap(result.first);
  }

  Future<List<Reminder>> findAll() async {
    final result = await _database.query(_table, orderBy: 'id');
    return result.map(Reminder.fromMap).toList();
  }
}
