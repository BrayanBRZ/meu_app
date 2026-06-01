import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Connection {
  Connection._();

  static final Connection instance = Connection._();

  static const String _databaseName = 'app_database.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;

    final String databasePath = kIsWeb
        ? _databaseName
        : path.join(await getDatabasesPath(), _databaseName);

    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminder(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        regularity TEXT NOT NULL,
        regular_time TEXT NOT NULL,
        remind_before INTEGER NOT NULL,
        is_active INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE subject(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tag(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        color INTEGER NOT NULL,
        reminder_id INTEGER NOT NULL,
        FOREIGN KEY (reminder_id) REFERENCES reminder (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        regularity TEXT NOT NULL,
        target_date TEXT NOT NULL,
        tag_id INTEGER NOT NULL,
        subject_id INTEGER NOT NULL,
        reminder_id INTEGER,
        description TEXT,
        FOREIGN KEY (tag_id) REFERENCES tag (id),
        FOREIGN KEY (subject_id) REFERENCES subject (id),
        FOREIGN KEY (reminder_id) REFERENCES reminder (id)
      )
    ''');
  }
}
