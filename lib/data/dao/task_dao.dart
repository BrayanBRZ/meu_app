import 'package:meu_app/data/models/task.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  TaskDao(this._database);

  final Database _database;

  static const String _table = 'task';

  Future<int> insert(Task task) async {
    return _database.insert(_table, task.toMap()..remove('id'));
  }

  Future<void> update(Task task) async {
    final id = task.id;
    if (id == null) {
      throw ArgumentError.value(task, 'task', 'id is required');
    }

    await _database.update(
      _table,
      task.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Task?> findById(int id) async {
    final result = await _database.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return Task.fromMap(result.first);
  }

  Future<List<Task>> findAll() async {
    final result = await _database.query(_table, orderBy: 'target_date, id');
    return result.map(Task.fromMap).toList();
  }

  Future<List<Task>> findByTagId(int tagId) async {
    final result = await _database.query(
      _table,
      where: 'tag_id = ?',
      whereArgs: [tagId],
      orderBy: 'target_date, id',
    );

    return result.map(Task.fromMap).toList();
  }

  Future<List<Task>> findBySubjectId(int subjectId) async {
    final result = await _database.query(
      _table,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'target_date, id',
    );

    return result.map(Task.fromMap).toList();
  }
}
