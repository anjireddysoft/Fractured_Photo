import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractured_photo/model/tile.dart';

import 'package:fractured_photo/screens/blend_mode.dart';
import 'dart:ui' as ui;

import 'package:fractured_photo/screens/single_image__paint.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/src/material/colors.dart' as co;
import 'package:flutter/src/widgets/image.dart';

class Custom extends StatefulWidget {
  final List<dynamic> maskList;
  final List<Tile> shartteredImageList;

  const Custom(
      {Key? key, required this.shartteredImageList, required this.maskList})
      : super(key: key);

  @override
  _CustomState createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  List<Tile> tilesList = [];

  List<Tile> droppedTilesList = [];

  int? selectedIndex = 0;
  Tile? activeTile;
  Offset _initialFocalPoint = Offset.zero;
  bool isRotated = false;

  convert() async {
    print("length${widget.shartteredImageList.length}");
    for (int i = 0; i < widget.shartteredImageList.length; i++) {
      var painter = BlendPainter(
          widget.shartteredImageList[i].imageObject!, widget.maskList[i]);
      ui.PictureRecorder recorder = ui.PictureRecorder();
      Canvas canvas = Canvas(recorder);

      painter.paint(
          canvas,
          Size(double.parse(widget.maskList[i].width.toString()),
              double.parse(widget.maskList[i].height.toString())));

      ui.Image renderedImage = await recorder.endRecording().toImage(
          widget.maskList[i].width.floor(), widget.maskList[i].height.floor());

      Tile mask = Tile(
          x1: widget.shartteredImageList[i].x1,
          y1: widget.shartteredImageList[i].y1,
          x2: widget.shartteredImageList[i].x2,
          y2: widget.shartteredImageList[i].y2,
          wScaleFactor: widget.shartteredImageList[i].wScaleFactor,
          hScaleFactor: widget.shartteredImageList[i].hScaleFactor,
          image: widget.shartteredImageList[i].image,
          imageName: widget.shartteredImageList[i].imageName,
          isCenterPiece: widget.shartteredImageList[i].isCenterPiece!,
          isActiveTile: false,
          isDroppedOnCanvas: false,
          imageObject: renderedImage);
      print("isCenterPiece${mask.isCenterPiece}");
      tilesList.add(mask);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    convert();
    //  selectedCustomPaint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.end,
          //  mainAxisSize: MainAxisSize.max,

          children: [
            Container(
              color: Colors.red,
              child: GestureDetector(
                onPanStart: onPanStart,
                onPanUpdate: onPanUpdate,
                onPanEnd: onPanEnd,
                child: Transform.translate(
                  offset: Offset.zero,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        ((MediaQuery.of(context).size.height) / 2)),
                    painter: ShatteredPuzzleCanvas(droppedTilesList, isRotated),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Material(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 2, color: Colors.yellow)),
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(10),
                height: 100,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                          width: 5,
                        ),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tilesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            var width = (tilesList[selectedIndex!].y2 -
                                    tilesList[selectedIndex!].y1)
                                .abs();
                            var height = (tilesList[selectedIndex!].x2 -
                                    tilesList[selectedIndex!].x1)
                                .abs();

                            for (int i = 0; i < droppedTilesList.length; ++i) {
                              droppedTilesList[i].isActiveTile = false;
                            }
                            for (int i = 0; i < tilesList.length; ++i) {
                              tilesList[i].isActiveTile = false;
                            }

                            setState(() {
                              selectedIndex = index;
                              Tile tile = tilesList[index];
                              tile.isDroppedOnCanvas = true;
                              tile.isActiveTile = true;
                              tile.cX1 = 100.0;
                              tile.cY1 = 100.0;
                              tile.cX2 = 100 + width;
                              tile.cY2 = 100 + height;
                              tile.angle = 0;
                              droppedTilesList.add(tile);
                              //  isRotated=true;
                              tilesList.removeAt(index);
                            });
                          },
                          child: RawImage(
                            image: tilesList[index].imageObject,
                          ));
                    }),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        for (int i = 0; i < droppedTilesList.length; i++) {
                          Tile tile = droppedTilesList[i];
                          if (tile.angle! % 360 == 0) {
                            setState(() {
                              tile.angle = 315;
                              isRotated = true;
                            });
                          } else {
                            setState(() {
                              tile.angle = tile.angle! - 45;
                              isRotated = true;
                            });
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.rotate_left_outlined,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        for (int i = 0; i < droppedTilesList.length; i++) {
                          Tile tile = droppedTilesList[i];
                          if (tile.isActiveTile!) {
                            if (tile.angle! % 360 == 0) {
                              setState(() {
                                tile.angle = 45;
                                isRotated = true;
                                print("isrotated$isRotated");
                              });
                              // isRotated=false;
                            } else {
                              setState(() {
                                tile.angle = tile.angle! + 45;
                                isRotated = true;
                                print("isrotated$isRotated");
                              });
                              //  isRotated=false;
                            }
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.rotate_right_outlined,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> onPanStart(DragStartDetails details) async {
    //print(details.localPosition.dx.toString(), details.localPosition.dy.toString())
    final box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);
    for (int i = 0; i < droppedTilesList.length; ++i) {
      Tile tile = droppedTilesList[i];
      tile.isActiveTile = false;
    }

    for (int i = 0; i < droppedTilesList.length; ++i) {
      Tile tile = droppedTilesList[i];
      print("(cX1,cY1)==(${tile.cX1},${tile.cY1})");

      final pngBytes = await tile.imageObject!.toByteData(format: ImageByteFormat.png);

      var bytes = pngBytes!.buffer.asUint8List();

      img.Image image = img.decodeImage(bytes)!;

      double px = localPosition.dx;
      double py = localPosition.dy;
      double widgetScale = box.size.width / image.width;
      px = (px / widgetScale);
      py = (py / widgetScale);
      int pixel32 = image.getPixelSafe(px.toInt(), py.toInt());
      int hex = abgrToArgb(pixel32);
      print("hex$hex");

      if (tile.isTouchWithinMe(tile, details.localPosition.dx,
          details.localPosition.dy, Color(hex))) {
        print(
            "isTouchWithinMe${tile.isTouchWithinMe(tile, details.localPosition.dx, details.localPosition.dy, Color(hex))}");
        tile.isActiveTile = true;

        activeTile = tile;
        activeTile!.cX1 = details.localPosition.dx;
        activeTile!.cY1 = details.localPosition.dy;

        print("ACTIVE TILE FOUND.. and its position is $i");
        break;
      }
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    print("inside onPanUpdate");
    isRotated = false;
    if (activeTile != null) {
      print("inside onPanUpdate1");
      var width = (activeTile!.y2 - activeTile!.y1).abs();
      var height = (activeTile!.x2 - activeTile!.x1).abs();
      print("inside onPanUpdate1${activeTile!.isActiveTile!}");
      if (activeTile!.isActiveTile!) {
        print("inside onPanUpdate2");
        if (details.localPosition.dx <
                MediaQuery.of(context).size.width -
                    (activeTile!.x2 - activeTile!.x1) &&
            details.localPosition.dy <
                (MediaQuery.of(context).size.height) / 2 -
                    (activeTile!.y2 - activeTile!.y1)) {
          if (activeTile!.cX1! > 0 && activeTile!.cY1! > 0) {
            setState(() {
              print("ldx${details.localPosition.dx}");
              print("ldy${details.localPosition.dy}");
              activeTile!.cX1 = details.localPosition.dx;
              activeTile!.cY1 = details.localPosition.dy;
              activeTile!.cX2 = details.localPosition.dx + width;
              activeTile!.cY2 = details.localPosition.dy + height;
            });
          }
        }
      }
    }

    /*final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    print("2$point");
    var cX1Position = tilesList[selectedIndex!].cX1;
    var cY1Position = tilesList[selectedIndex!].cY1;
    print("(cX1Position,cY1Position)===($cX1Position,$cY1Position)");
    var width = (tilesList[selectedIndex!].y2 -
            tilesList[selectedIndex!].y1)
        .abs();
    var height = (tilesList[selectedIndex!].x2 -
            tilesList[selectedIndex!].x1)
        .abs();
    var cX2Position = cX1Position! + width;
    var cY2Position = cY1Position! + height;

    print("(width,height)===($width,$height)");
    print("(cX2Position,cY2Position)===($cX2Position,$cY2Position)");
    if (point.dx < 300 && point.dy < 436) {
      if ((point.dx >= cX1Position || point.dx <= cX2Position) &&
          (point.dy >= cY1Position || point.dy <= cY2Position)) {
        setState(() {
          // _offset = (details.localPosition - _initialFocalPoint);

          tilesList[selectedIndex!].cX1 = point.dx;
          tilesList[selectedIndex!].cY1 = point.dy;

          //  _initialFocalPoint =_offset;
        });
      }
    }*/
  }

  void onPanEnd(DragEndDetails details) {
    print("inside onPanEnd");
    /* _initialFocalPoint = Offset.zero;

    print('User ended drawing');*/
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
