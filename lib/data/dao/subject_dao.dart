import '../models/subject.dart';
import '../repositories/database.dart';

class SubjectDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Subject subject) async {
    final db = await dbHelper.database;
    return await db.insert('subjects', subject.toMap());
  }

  // Exemplo de READ com JOIN para puxar os nomes da associação (CRUD Associação)
  Future<List<Map<String, dynamic>>> getAllWithDetails() async {
    final db = await dbHelper.database;
    return await db.rawQuery('''
      SELECT s.*, t.name as subjectName, sem.name as semesterName 
      FROM subjects s
      LEFT JOIN subjects t ON s.subjectId = t.id
      LEFT JOIN semesters sem ON s.semesterId = sem.id
    ''');
  }

  Future<int> update(Subject subject) async {
    final db = await dbHelper.database;
    return await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await dbHelper.database;
    return await db.delete('subjects', where: 'id = ?', whereArgs: [id]);
  }
}
