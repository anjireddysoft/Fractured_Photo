import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fractured_photo/model/count.dart';
import 'package:fractured_photo/model/piece.dart';
import 'package:fractured_photo/showImage.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as a;

class PicShow extends StatefulWidget {
  File ImageFile;

  PicShow({Key? key, required this.ImageFile}) : super(key: key);

  @override
  _PicShowState createState() => _PicShowState();
}

class _PicShowState extends State<PicShow> {
  List<Piece> pieceList = [];

  List<Count> numbers = [
    Count(row: 2, column: 3),
    Count(row: 5, column: 4),
    Count(row: 6, column: 5),
    Count(row: 7, column: 6)
  ];
  List<int> angles = [0, 90, 270, 180];

  Count? count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Image"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            var image;
            var x = 0.0;
            var y = 0.0;

            final srcImage =
                decodeImage(File(widget.ImageFile.path).readAsBytesSync());

            var picHeight = srcImage!.height;
            var picWidth = srcImage!.width;
            var height = picHeight / count!.row;
            var width = picWidth / count!.column;
            print("picHeight$picHeight");
            print("picWidth$picWidth");
            print("height$height");
            print("width$width");
            print("row${count!.row}");
            print("column${count!.column}");
            int picId = 0;
            var imagesCount = count!.row * count!.column;

            print("imagesCount$imagesCount");
            pieceList.clear();
            Random rand = new Random();

            for (int i = 0; i < count!.row; i++) {
              for (int j = 0; j < count!.column; j++) {
                var croppedImage = copyCrop(srcImage!, x.round(), y.round(),
                    width.round(), height.round());

                image = a.Image.memory(
                    Uint8List.fromList(imglib.encodeJpg(croppedImage)));
                int randomIndex = rand.nextInt(angles.length);
                print("randomIndex${angles[randomIndex]}");

                Piece piece = Piece(
                    row: i,
                    column: j,
                    image: image,
                    angle: angles[randomIndex],
                    picId: picId);

                pieceList.add(piece);

                print("($i,$j)======>($x,$y)");
                picId = picId + 1;
                print("picId$picId");


                x = x + width;
              }
              x = 0.0;
              y = y + height;
              print("y$y");
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowImage(
                          pieceList: pieceList,
                          columnCount: count!.column,
                        )));
          },
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: DropdownButton<Count>(
                        focusColor: Colors.white,
                        value: count,
                        isExpanded: true,
                        underline: Container(),
                        //elevation: 5,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        iconEnabledColor: Colors.black,
                        items:
                            numbers.map<DropdownMenuItem<Count>>((Count value) {
                          return DropdownMenuItem<Count>(
                            value: value,
                            child: Text(
                              "${value.row}x${value.column}",
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "row/columns",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            count = value;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
