import '../models/semester.dart';
import '../repositories/database.dart';

class SemesterDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Semester semester) async {
    final db = await dbHelper.database;
    return await db.insert('semesters', semester.toMap());
  }

  Future<List<Semester>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('semesters');
    return maps.map((map) => Semester.fromMap(map)).toList();
  }

  Future<int> update(Semester semester) async {
    final db = await dbHelper.database;
    return await db.update(
      'semesters',
      semester.toMap(),
      where: 'id = ?',
      whereArgs: [semester.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await dbHelper.database;
    return await db.delete('semesters', where: 'id = ?', whereArgs: [id]);
  }
}
