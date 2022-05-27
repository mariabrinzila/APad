// ignore: import_of_legacy_library_into_null_safe
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'note.dart';

class NoteDatabase {
  final String _name = 'noteDB.db';
  final int version = 1;
  late Database noteDB;
  final String _tableName = 'NOTE';

  initDatabase() async {
    var databaseDirctory = await getDatabasesPath();
    var databasePath = join(databaseDirctory, _name);

    // delete any existing database
    await deleteDatabase(databasePath);

    // create the writable database file
    ByteData data = await rootBundle.load("assets/noteDB.db");

    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(databasePath).writeAsBytes(bytes);

    // open databasepushd E :\Facultate-Anul3\Proiect\project
    noteDB = await openDatabase(databasePath);
  }

  /*
  _onCreate(Database noteDB, int version) async {
    await noteDB.execute('''DROP TABLE NOTE;''');

    await noteDB.execute('''
          CREATE TABLE NOTE(
            ID INT PRIMARY KEY NOT NULL,
            TITLE VARCHAR(25) NOT NULL,
            CONTENT VARCHAR(1000) NOT NULL,
            COLOR VARCHAR(15))
          ''');
  }*/

  Future<int> insertNote(Note noteToInsert) async {
    var id = noteToInsert.id,
        title = noteToInsert.title,
        content = noteToInsert.content,
        color = noteToInsert.color;

    // insert query
    var query =
        'INSERT INTO NOTE (ID, TITLE, CONTENT, COLOR) VALUES ($id, "$title", "$content", "$color");';

    // insert result
    var result = await noteDB.rawInsert(query);

    return result;
  }

  Future<int> updateNote(Note noteToUpdate) async {
    return await noteDB.update(_tableName, noteToUpdate.toMap(),
        where: 'ID = ?',
        whereArgs: [noteToUpdate.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getNotesById(int id) async {
    var result =
        await noteDB.query(_tableName, where: 'ID = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  Future<List> selectAllNotes() async {
    // SELECT * FROM NOTE; query result
    var result = await noteDB
        .query(_tableName, columns: ["ID", "TITLE", "CONTENT", "COLOR"]);

    // convert result to a list
    var allResults = result.toList();

    print(allResults);

    return allResults;
  }

  Future<int> selectLastID() async {
    var result = await noteDB.rawQuery('SELECT ID FROM NOTE ORDER BY ID DESC');
    result = result.toList();

    var nrIDs = result[0]['ID'];

    return nrIDs;
  }

  closeDatabase() async {
    await noteDB.close();
  }
}
