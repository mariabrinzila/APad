import 'package:sqflite/sqflite.dart';

import 'note.dart';

class NoteDatabase {
  final String _name = 'noteDB.db';
  late Database _noteDB;
  final String _tableName = 'NOTE';

  initDatabase() async {
    _noteDB = await openDatabase(_name);
  }

  Future<int> insertNote(Note noteToInsert) async {
    return await _noteDB.insert(_tableName, noteToInsert.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(Note noteToUpdate) async {
    return await _noteDB.update(_tableName, noteToUpdate.toMap(),
        where: 'ID = ?',
        whereArgs: [noteToUpdate.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    return await _noteDB.query(_tableName);
  }

  Future<Map<String, dynamic>?> getNotesById(int id) async {
    var result =
        await _noteDB.query(_tableName, where: 'ID = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  closeDatabase() async {
    await _noteDB.close();
  }
}
