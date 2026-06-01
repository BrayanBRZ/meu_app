import 'package:meu_app/data/models/subject.dart';
import 'package:sqflite/sqflite.dart';

class SubjectDao {
  SubjectDao(this._database);

  final Database _database;

  static const String _table = 'subject';

  Future<int> insert(Subject subject) async {
    return _database.insert(_table, subject.toMap()..remove('id'));
  }

  Future<void> update(Subject subject) async {
    final id = subject.id;
    if (id == null) {
      throw ArgumentError.value(subject, 'subject', 'id is required');
    }

    await _database.update(
      _table,
      subject.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<Subject?> findById(int id) async {
    final result = await _database.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return Subject.fromMap(result.first);
  }

  Future<List<Subject>> findAll() async {
    final result = await _database.query(
      _table,
      orderBy: 'title COLLATE NOCASE',
    );
    return result.map(Subject.fromMap).toList();
  }
}
