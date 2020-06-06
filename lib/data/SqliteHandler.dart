import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:tizeno/data/notes.dart';

class NotesDBHandler {
  final databaseName = "notes.db";
  final tableName = "notes";
  final tableNameImages = "imagesTable";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "content": "BLOB",
    "dateCreated": "INTEGER",
    "dateLastEdited": "INTEGER",
    "noteColor": "INTEGER",
    "isPhoto": "INTEGER",
    "isArchived": "INTEGER",
    "isStarred": "INTEGER",
  };

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'notes.db');
    print(dbPath);
    Database dbConnection = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      print("executing create query from onCreate callback");
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());
    _buildCreateQuery();

    return dbConnection;
  }

  deleteDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, 'notes.db');
    await deleteDatabase(dbPath);
  }

  String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += tableName;
    query += "(";
    fieldMap.forEach((column, field) {
      print("$column : $field");
      query += "$column $field,";
    });

    query = query.substring(0, query.length - 1);
    query += " )";
    return query;
  }

  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  Future<int> insertNote(Note note, bool isNew) async {
    final Database db = await database;
    print("insert called");
    try {
      await db.insert(
        'notes',
        isNew ? note.toMap(false) : note.toMap(true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (isNew) {
        var one = await db.query("notes",
            orderBy: "dateLastEdited desc",
            where: "isArchived = ?",
            whereArgs: [0],
            limit: 1);
        int latestId = one.first["id"] as int;
        return latestId;
      }
      return note.id;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> copyNote(Note note) async {
    final Database db = await database;
    try {
      await db.insert("notes", note.toMap(false),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (Error) {
      print(Error);
      return false;
    }
    return true;
  }

  // Future<int> insertPhotoNote(Note note, bool isNew) async {
  //   final Database db = await database;
  //   print("insert called");

  //   await db.insert(
  //     'notes',
  //     isNew ? note.toMap(false) : note.toMap(true),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );

  //   if (isNew) {
  //     var one = await db.query("notes",
  //         orderBy: "dateLastEdited desc",
  //         where: "isArchived = ?",
  //         whereArgs: [0],
  //         limit: 1);
  //     int latestId = one.first["id"] as int;
  //     return latestId;
  //   }
  //   return note.id;
  // }

  Future<bool> archiveNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update("notes", note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> starNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update("notes", note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> photoNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update("notes", note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete("notes", where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    var data = await db.query(
      "notes",
      orderBy: "dateLastEdited desc",
    );

    return data;
  }

  Future<List<Map<String, dynamic>>> selectStarredNotes() async {
    final Database db = await database;
    var data = await db.query("notes",
        orderBy: "dateLastEdited desc", where: "isStarred = ?", whereArgs: [1]);
    return data;
  }

  Future<List<Map<String, dynamic>>> selectArchivedNotes() async {
    final Database db = await database;
    var data = await db.query("notes",
        orderBy: "dateLastEdited desc",
        where: "isArchived = ?",
        whereArgs: [1]);
    return data;
  }

  Future<List<Map<String, dynamic>>> selectPhotoNotes() async {
    final Database db = await database;
    var data = await db.query("notes",
        orderBy: "dateLastEdited desc", where: "isPhoto = ?", whereArgs: [1]);
    return data;
  }

  Future<List<Map<String, dynamic>>> selectAllPhotosById(int id) async {
    final Database db = await database;
    var data = await db.query(
      "notes",
      where: "isPhoto = " + '1' + " AND " + "id = " + id.toString(),
    );
    return data;
  }
}
