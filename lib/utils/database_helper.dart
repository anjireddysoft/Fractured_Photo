import 'dart:developer';

import 'package:fractured_photo/model/puzzle_info.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String puzzleTable = 'puzzle_table';
  String colId = 'id';
  String colPuzzleName = 'puzzleName';
  String colrow = 'row';
  String colColumn = 'column';
  String colFile = 'file';
  String colPieceList = 'pieceList';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Puzzle.db';
    print("path$path");

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $puzzleTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPuzzleName TEXT, '
        '$colrow INTEGER, $colColumn INTEGER, $colFile TEXT,$colPieceList Text)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getPuzzleMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $puzzleTable');
    log("puzzless${result}");
    return result;
  }
  Future<int> deleteNote() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $puzzleTable ');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(PuzzleIfo puzzleIfo) async {
    Database db = await this.database;
    var result = await db.insert(puzzleTable, puzzleIfo.toMap());
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<PuzzleIfo>> getPuzzleList() async {
    var noteMapList = await getPuzzleMapList(); // Get 'Map List' from database
    int count = noteMapList.length; // Count the number of map entries in db table

    List<PuzzleIfo> PuzzleList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {



      log("pieceList${noteMapList[i]["pieceList"]}");
      PuzzleList.add(PuzzleIfo.fromMapObject(noteMapList[i]));
    }
    log("puzzless${PuzzleList.length}");
    log("puzzless${PuzzleList[0].file}");
    return PuzzleList;
  }
}
