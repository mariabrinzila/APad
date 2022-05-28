import 'package:sqflite/sqflite.dart';

import 'note_model.dart';

class NoteDatabase {
  static const _name = 'noteDB.db';
  static const _version = 1;

  late Database database;

  static const _table = 'NOTE';

  // open database and create table
  initDatabase() async {
    database = await openDatabase(_name, version: _version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $_table (
					ID INTEGER PRIMARY KEY AUTOINCREMENT,
					TITLE TEXT NOT NULL,
					CONTENT TEXT NOT NULL)''');
    });
  }

  // insert a new note
  Future<int> insertNote(NoteModel note) async {
    return await database.insert(_table, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // update an existing note
  Future<int> updateNote(NoteModel note) async {
    return await database.update(_table, note.toMap(),
        where: 'TITLE = ?',
        whereArgs: [note.title],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // select all notes in the database
  Future<List<Map<String, dynamic>>> selectAll() async {
    return await database.query(_table);
  }

  // select note by title
  Future<Map<String, dynamic>?> selectByID(int id) async {
    var result = await database.query(_table, where: 'ID = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  // delete an existing note
  Future<int> deleteNote(int id) async {
    return await database.delete(_table, where: 'ID = ?', whereArgs: [id]);
  }

  // close database
  closeDatabase() async {
    await database.close();
  }
}
