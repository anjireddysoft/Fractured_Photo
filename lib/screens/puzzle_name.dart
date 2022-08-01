import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractured_photo/model/tile.dart';

import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/screens/mask_builder.dart';
import 'package:fractured_photo/screens/paint.dart';
import 'package:fractured_photo/screens/showImage.dart';
import 'package:fractured_photo/screens/utile.dart';
import 'package:image/image.dart';
import 'package:image/image.dart' as imglib;

class NameScreen extends StatefulWidget {
  List<Piece_Info>? pieceList;
  bool isFromSquarePuzzle;
  File? imageFile;
  int? columnCount;
  int? rowCount;

  bool? isSquarePuzzle;

  NameScreen(
      {Key? key,
      this.imageFile,
      this.rowCount,
      this.pieceList,
      required this.isFromSquarePuzzle,
      this.isSquarePuzzle,
      this.columnCount})
      : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController nameController = TextEditingController();
  ServiceMethods _serviceMethods = ServiceMethods();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(hintText: "EnterName"),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                          child: Center(
                            child: MaterialButton(
                              onPressed: () {
                                if (nameController.text.isEmpty) {
                                  showSnackBar("Please enter puzzle name");
                                } else {
                                  if (widget.isFromSquarePuzzle) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ShowImage(
                                                  pieceList: widget.pieceList!,
                                                  columnCount:
                                                      widget.columnCount!,
                                                  imageFile: widget.imageFile,
                                                  puzzleName:
                                                      nameController.text,
                                                  rowCount: widget.rowCount!,
                                                  isFromSavedPuzzle: false,
                                                )));
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    SplitImgeShorted();
                                  }
                                }
                              },
                              child: const Text(
                                "START",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            ),
                          ),
                        ),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : Container()
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showSnackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message!,
          style: const TextStyle(fontSize: 20),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  SplitImgeShorted() async {
    final srcImage = decodeImage(File(widget.imageFile!.path).readAsBytesSync());
    List<Piece_Info> pieceList = [];
    List<int> patternList = [1, 2, 3];
    List<Tile> maskList = [];
    var picHeight = srcImage!.height;
    var picWidth = srcImage!.width;
    Random random = Random();
    int patternType = random.nextInt(patternList.length);
    print("(picWidth,picHeight)==(${srcImage!.width},${srcImage!.height})");
    var wSF = picWidth / 480;
    var hSF = picHeight / 640;

    print("(wSF,hSF)==(${wSF},${hSF})");
    maskList.addAll(TileBuilder.loadTiles(
        patternType: patternType, wScaleFactor: wSF, hScaleFactor: hSF));
    print("maskList${maskList.length}");

    /* for (int i = 0; i < maskList.length; i++) {
      print("Piece #${i}");
      print(
          "Before Applying WSF ==> (x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print(
          "Before Applying HSF ==> (x2,y2)== (${maskList[i].x2.round()},${maskList[i].y2.round()})");

      maskList[i].x1 = hSF * maskList[i].x1;
      maskList[i].y1 = wSF * maskList[i].y1;
      maskList[i].x2 = hSF * maskList[i].x2;
      maskList[i].y2 = wSF * maskList[i].y2;


      print(
          "After Applying WSF ==> (x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print(
          "After Applying HSF ==> (x2,y2)== (${maskList[i].x2.round()},${maskList[i].y2.round()})");
      print("===========================");
    }*/

    pieceList.clear();
    var totalMasks = [];
    for (int i = 0; i < maskList.length; i++) {
      var height = (maskList[i].x2 - maskList[i].x1).abs();
      var width = (maskList[i].y2 - maskList[i].y1).abs();
      print("(x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print(
          "(width,height)==(${width.toStringAsFixed(2)},${height.toStringAsFixed(2)})");

      var croppedImage = copyCrop(srcImage!, maskList[i].y1.round(),
          maskList[i].x1.round(), width.round(), height.round());

      saveImage(croppedImage, "image${i + 1}.jpg");

      final byteData = await rootBundle.load(maskList[i].image);
      totalMasks.add(await decodeImageFromList(await byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)));

      String base64Image =
          base64.encode(Uint8List.fromList(imglib.encodeJpg(croppedImage)));
      var bytes = base64Decode(base64Image);
      var codec = await instantiateImageCodec(bytes);
      var frame = await codec.getNextFrame();
      frame.image;
      maskList[i].imageObject = frame.image;
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Custom(
                  shartteredImageList: maskList,
                  maskList: totalMasks,
                )));

    setState(() {
      isLoading = false;
    });
  }

  saveImage(imglib.Image image, String imageName) async {
    final fileImage = await _serviceMethods.localFile(imageName);
    fileImage.writeAsBytesSync(Uint8List.fromList(imglib.encodeJpg(image))!);
  }
}
