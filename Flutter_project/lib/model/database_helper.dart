import 'package:sqflite/sqflite.dart';

import 'note.dart';

class DatabaseHelper {
  static final _name = "noteDatabase.db";
  static final _version = 1;

  Database database;
  static final _tableName = 'NOTE';

  // initialize database <=> open database and create table
  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $_tableName (
					  id INTEGER PRIMARY KEY AUTOINCREMENT,
					  title TEXT,
					  content TEXT
					)''');
    });
  }

  // insert a new note
  Future<int> insertNote(Note note) async {
    return await database.insert(_tableName, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // update existing note
  Future<int> updateNote(Note note) async {
    return await database.update(_tableName, note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // select all notes from the database
  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    return await database.query(_tableName);
  }

  // select notes by id
  Future<Map<String, dynamic>> selectNotesByID(int id) async {
    var result =
        await database.query(_tableName, where: 'id = ?', whereArgs: [id]);

    if (result.length > 0) {
      return result.first;
    }

    return null;
  }

  // delete a note
  Future<int> deleteNote(int id) async {
    return await database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // close database
  closeDatabase() async {
    await database.close();
  }
}
