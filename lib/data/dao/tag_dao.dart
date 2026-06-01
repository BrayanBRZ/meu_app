import 'package:meu_app/data/models/tag.dart';
import 'package:sqflite/sqflite.dart';

class TagDao {
  TagDao(this._database);

  final Database _database;

  static const String _table = 'tag';

  // essencial methods

  Future<void> insert(Tag tag) async {
    await _database.insert(_table, tag.toMap());
  }

  Future<void> delete(int id) async {
    await _database.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Tag tag) async {
    await _database.update(
      _table,
      tag.toMap(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  // query methods

  Future<Tag> findById(int id) async {
    
  } 
}
