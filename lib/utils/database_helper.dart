import 'dart:developer';

import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/model/puzzle_info.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String puzzleTable = 'puzzle_Info';
  String pieceTable = 'piece_Info';

  String colId = 'puzzle_id';
  String colPuzzleName = 'puzzleName';
  String colPattern = 'pattern';
  String colNoPieces = 'pieces_count';
  String colFilePath = 'file_path';
  String colDateTime = 'dateTime';

  String colRotation = "angle";
  String colCurrent_Position = "current_Position";
  String colOriginal_Position = "original_Position";
  String colImage = "image";

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
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
        'CREATE TABLE $puzzleTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPuzzleName varchar(250), '
        '$colPattern varchar(250), $colNoPieces INTEGER, $colFilePath TEXT,$colDateTime TEXT)');

    await db.execute(
        'CREATE TABLE $pieceTable($colId INTEGER ,$colRotation INTEGER,$colCurrent_Position INTEGER,$colOriginal_Position INTEGER ,$colImage TEXT)');
  }


  // Insert Operation: Insert a Note object to database
  Future<int> insertPuzzle(PuzzleInfo puzzleInfo) async {
    Database db = await this.database;
    var result = await db.insert(puzzleTable, puzzleInfo.toMap());
    return result;
  }

  Future<int> insertPiece(Piece_Info piece_info) async {
    Database db = await this.database;
    var result = await db.insert(pieceTable, piece_info.toJson());
    return result;
  }
  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getPuzzleMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $puzzleTable');
    log("puzzless${result}");
    return result;
  }

// Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getPieceMapList(int id) async {
    Database db = await this.database;
    var result =
        await db.rawQuery('SELECT * FROM $pieceTable where $colId=$id');

    return result;
  }
  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<PuzzleInfo>> getPuzzleList() async {
    var noteMapList = await getPuzzleMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<PuzzleInfo> PuzzleList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      PuzzleList.add(PuzzleInfo.fromMapObject(noteMapList[i]));
    }

    return PuzzleList;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Piece_Info>> getPieceList(int id) async {
    var pieceMapList =
    await getPieceMapList(id); // Get 'Map List' from database
    int count =
        pieceMapList.length; // Count the number of map entries in db table

    List<Piece_Info> PieceList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      PieceList.add(Piece_Info.fromJson(pieceMapList[i]));
    }
print("PieceList${PieceList.length}");
    return PieceList;
  }

  // update operation
  Future<int> updatePiece(Piece_Info piece_info) async {
    var db = await this.database;
    var result = await db.update(pieceTable, piece_info.toJson(), where: "$colId = ?", whereArgs: [piece_info.puzzleId]);

    print("resultforUpdation$result");
    return result;
  }



 // delete puzzle operation based on puzzle id
  Future<int> deletePuzzle(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $puzzleTable where $colId=$id');
    print("result1$result");

    return result;
  }
  Future<int> deletePiece(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $pieceTable where $colId=$id');

    print("result2$result");
    return result;
  }


  dropTable() async {
    Database db = await this.database;
   await db.rawQuery('DROP TABLE $pieceTable');
  }

}
