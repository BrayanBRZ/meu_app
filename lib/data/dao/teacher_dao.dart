import '../models/teacher.dart';
import '../repositories/database.dart';

class TeacherDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Teacher teacher) async {
    final db = await dbHelper.database;
    return await db.insert('teachers', teacher.toMap());
  }

  Future<List<Teacher>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('teachers');
    return maps.map((map) => Teacher.fromMap(map)).toList();
  }

  Future<int> update(Teacher teacher) async {
    final db = await dbHelper.database;
    return await db.update(
      'teachers',
      teacher.toMap(),
      where: 'id = ?',
      whereArgs: [teacher.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await dbHelper.database;
    return await db.delete('teachers', where: 'id = ?', whereArgs: [id]);
  }
}
