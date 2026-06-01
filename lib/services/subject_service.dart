import 'package:meu_app/data/dao/subject_dao.dart';
import 'package:meu_app/data/database/connection.dart';
import 'package:meu_app/data/models/subject.dart';

class SubjectService {
  Future<SubjectDao> get _dao async {
    final database = await Connection.instance.database;
    return SubjectDao(database);
  }

  Future<int> create(Subject subject) async {
    return (await _dao).insert(subject);
  }

  Future<void> update(Subject subject) async {
    await (await _dao).update(subject);
  }

  Future<void> delete(int id) async {
    await (await _dao).delete(id);
  }

  Future<Subject?> findById(int id) async {
    return (await _dao).findById(id);
  }

  Future<List<Subject>> findAll() async {
    return (await _dao).findAll();
  }
}
