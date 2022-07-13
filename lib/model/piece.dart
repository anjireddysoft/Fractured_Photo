import 'package:flutter/material.dart';

class Piece {
  late  int row;
  late int column;
  late Image image;
  late int angle;
  late int picId;

  Piece(
      {required this.row,
      required this.column,
      required this.image,
      required this.angle,
      required this.picId});

  Map<String, dynamic> toJson() {
    var map = Map<String, dynamic>();

    map['row'] = row;
    map['column'] = column;
    map['image'] = image.toString();
    map['angle'] = angle;
    map['picId'] = picId;
    return map;
  }
  Piece.fromMapObject(Map<String, dynamic> map) {
    this.row=map['row'];
    this.column = map['column'];
    this.image= map['image'] ;
    this.angle = map['angle'] ;
    this.picId =  map['picId'] ;

  }
}
