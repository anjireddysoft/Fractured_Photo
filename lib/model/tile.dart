import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:ui';

import 'package:flutter/src/material/colors.dart';
import 'package:flutter/material.dart';

class Tile {
  double x1;
  double y1;
  double x2;
  double y2;
  double wScaleFactor;
  double hScaleFactor;
  String image;
  String imageName;
  bool? isCenterPiece;
  double? cX1;
  double? cY1;
  double? cX2;
  double? cY2;
  bool? isActiveTile = false;
  ui.Image? imageObject;
  bool? isDroppedOnCanvas = false;
  int? angle;

  Tile(
      {required this.x1,
      required this.y1,
      required this.x2,
      required this.y2,
      required this.wScaleFactor,
      required this.hScaleFactor,
      required this.image,
      this.isCenterPiece,
      this.cX1,
      this.cY1,
      this.cX2,
      this.cY2,
      this.isActiveTile,
      required this.imageName,
      this.imageObject,
      this.angle,
      this.isDroppedOnCanvas});

  bool isTouchWithinMe(Tile tile, double dx, double dy, Color color) {
    print("isTouchWithinMe3");
    print("dx$dx");
    print("dy$dy");
    print("cx1${tile.cX1}");
    print("cx2${tile.cX2}");
    print("cy1${tile.cY1}");
    print("cy2${tile.cY2}");
    if ((dx >= tile.cX1! && dx <= tile.cX2!) &&
        (dy >= tile.cY1! && dy <= tile.cY2!)) {
      print("isTouchWithinMe1");

        print("isTouchWithinMe2");
        return true;

    }
    return false;
  }
}
