import 'dart:io';

import 'package:fractured_photo/model/piece.dart';

class PuzzleIfo {
  File file;
  String puzzleName;
  int row;
  int count;
  List<Piece> pieceList;

  PuzzleIfo(
      {required this.file,
      required this.puzzleName,
      required this.row,
      required this.count,
      required this.pieceList});
}
