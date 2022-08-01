import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:fractured_photo/model/tile.dart';

class ShatteredPuzzleCanvas extends CustomPainter {
  List<Tile> droppedTilesList;
  bool isRotated;

  ShatteredPuzzleCanvas(this.droppedTilesList, this.isRotated);

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    print("size$size");

    for (int i = 0; i < droppedTilesList.length; i++) {
      Tile tile = droppedTilesList[i];
      Paint paint = Paint();
      if (tile.isActiveTile == false) {
        if (tile.isDroppedOnCanvas != null) {
          if (tile.isDroppedOnCanvas!) {
            if (tile.imageObject != null) {
              canvas.save();
              var offset = Offset(tile.cX1!, tile.cY1!);

              canvas.drawImage(tile.imageObject!, offset, paint);
              canvas.restore();
            }
          }
          /*else {
            if (tile.imageObject != null) {
              canvas.save();
              var offset = Offset(tile.x1!, tile.y1);

              canvas.drawImage(tile.imageObject!, offset, paint);
              canvas.restore();
            }
          }*/
        }
      }
    }

    for (int i = 0; i < droppedTilesList.length; i++) {
      Tile tile = droppedTilesList[i];
      if (tile.isActiveTile!) {
        print("anji${droppedTilesList[i].angle.toString()}");
        double angle =
            double.parse(droppedTilesList[i].angle.toString() ?? "0") *
                0.0174533;


            Paint paint = Paint();
            if (tile.imageObject != null) {
              canvas.save();
              var offset = Offset(tile.cX1!, tile.cY1!);
              canvas.drawImage(tile.imageObject!, offset, paint);
              canvas.restore();



        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
