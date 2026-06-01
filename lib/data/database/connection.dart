import 'package:flutter/foundation.dart';
import 'package:meu_app/data/database/schema.dart';
import 'package:meu_app/data/database/seeders.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class Connection {
  Connection._();

  // Verificar race condition futuramente
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
    for (final sql in Schema.createTables) {
      await db.execute(sql);
    }

    for (final sql in Seeders.initialInserts) {
      await db.execute(sql);
    }

    for (final sql in Schema.createTriggers) {
      await db.execute(sql);
    }
  }
}
