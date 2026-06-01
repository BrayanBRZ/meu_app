import 'package:meu_app/data/models/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagDao {
  TagDao(this._database);

  final Database _database;

  static const String _table = 'tag';

  Future<int> insert(Tag tag) async {
    if (tag.reminderId == null) {
      throw ArgumentError.value(tag, 'tag', 'reminderId is required');
    }

    final values = tag.toMap()
      ..remove('id')
      ..['is_default'] = 0;

    return _database.insert(_table, values);
  }

  Future<void> delete(int id) async {
    final tag = await findById(id);
    if (tag == null) return;
    if (!tag.isEditable) {
      throw StateError('Default tags cannot be deleted');
    }

    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Tag tag) async {
    final id = tag.id;
    if (id == null) {
      throw ArgumentError.value(tag, 'tag', 'id is required');
    }

    final currentTag = await findById(id);
    if (currentTag == null) return;
    if (!currentTag.isEditable) {
      throw StateError('Default tags cannot be updated');
    }

    final values = tag.toMap()
      ..remove('id')
      ..remove('reminder_id')
      ..['is_default'] = 0;

    await _database.update(
      _table,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Tag?> findById(int id) async {
    final result = await _database.query(
      _table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return Tag.fromMap(result.first);
  }

  Future<List<Tag>> findAll() async {
    final result = await _database.query(
      _table,
      orderBy: 'is_default DESC, title COLLATE NOCASE',
    );
    return result.map(Tag.fromMap).toList();
  }
}
