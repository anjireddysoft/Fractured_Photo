

import 'dart:convert';

import 'package:fractured_photo/model/piece.dart';

class PuzzleIfo {
  int? id;
  String? file;
  String? puzzleName;
  String? row;
  int? column;
  List<Piece>? pieceList;

  PuzzleIfo(
      {required this.file,
      required this.puzzleName,
      required this.row,
      required this.column,
      required this.pieceList});

//converting puzzle object to Map object to store in database
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map['puzzleName'] = puzzleName;
    map['file'] = file;
    map['row'] = row;
    map['column'] = column;
    if (this.pieceList != null) {
      map['PieceList'] = this.pieceList!.map((v) => v.toJson()).toString();
    }
    return map;
  }

  PuzzleIfo.fromMapObject(Map<String, dynamic> map) {
    id = map['id'];
    puzzleName = map['puzzleName'];
    file = map['file'];
    row = map['row'];
    column = map['column'];
    if (map['PieceList'] != null) {
     // pieceList = [];
      (json.decode(map['PieceList'])as List).forEach((v) {
       this.pieceList!.add(new Piece.fromMapObject(v));
      });
    }
  }
}
