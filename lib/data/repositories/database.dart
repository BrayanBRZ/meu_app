import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('school_diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teachers(id TEXT PRIMARY KEY, name TEXT NOT NULL)
    ''');

    await db.execute('''
      CREATE TABLE semesters(id TEXT PRIMARY KEY, name TEXT NOT NULL)
    ''');

    await db.execute('''
      CREATE TABLE subjects(
        id TEXT PRIMARY KEY, name TEXT NOT NULL, color INTEGER NOT NULL,
        teacherId TEXT NOT NULL, semesterId TEXT NOT NULL,
        FOREIGN KEY (teacherId) REFERENCES teachers (id),
        FOREIGN KEY (semesterId) REFERENCES semesters (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL,
        type TEXT NOT NULL, currentDate TEXT NOT NULL, subjectId TEXT NOT NULL,
        FOREIGN KEY (subjectId) REFERENCES subjects (id)
      )
    ''');
  }
}
