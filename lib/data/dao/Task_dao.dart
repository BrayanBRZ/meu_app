import '../models/task.dart';
import '../repositories/database.dart';

class TaskDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Task task) async {
    final db = await dbHelper.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('tasks');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> update(Task Task) async {
    final db = await dbHelper.database;
    return await db.update(
      'Tasks',
      Task.toMap(),
      where: 'id = ?',
      whereArgs: [Task.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await dbHelper.database;
    return await db.delete('Tasks', where: 'id = ?', whereArgs: [id]);
  }
}
