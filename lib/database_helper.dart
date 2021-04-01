import 'package:path_provider/path_provider.dart';
import "package:path/path.dart";
import 'package:simple_notes_app/note.dart';
import 'package:sqflite/sqflite.dart';
import "dart:io" as io;


class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createObject();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createObject();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  static String _tableName = 'notes';

  Future<Database> _initializeDb() async {
    // io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentDirectory.path, "note_db.db");
    // var taskDb =
    // await openDatabase(path, version: 1);
    // return taskDb;
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/note_db.db',
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY,
          title TEXT, description TEXT
        )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertNote(Note note) async {
    final Database db = await database;
    await db.insert(_tableName, note.toMap());
    print('data saved');
  }

  Future<List<Note>> getNotes() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Note.fromMap(res)).toList();
  }

  Future<Note> getNoteById(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => Note.fromMap(res)).first;
  }

  Future<void> updateNote(Note note) async {
    final Database db = await database;

    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async{
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}