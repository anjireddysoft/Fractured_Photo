import 'package:flutter/material.dart';

class Piece {
  late String image;
  late int angle;
  late int original_Position;
  int? current_Position;

  Piece(
      {required this.image,
      required this.angle,
      required this.original_Position,
      this.current_Position});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map['image'] = image.toString();
    map['angle'] = angle;
    map['original_Position'] = original_Position;
    map['current_Position'] = current_Position;

    return map;
  }

  Piece.fromMapObject(Map<String, dynamic> map) {
    this.image = map['image'];
    this.angle = map['angle'];
    this.original_Position = map['original_Position'];
    this.current_Position = map['current_Position'];
  }
}
