import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fractured_photo/model/count.dart';
import 'package:fractured_photo/model/piece.dart';
import 'package:fractured_photo/pic_cutter.dart';
import 'package:fractured_photo/puzzle_name.dart';
import 'package:fractured_photo/showImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as a;

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? imageFile;
  List<Count> numbers = [
    Count(row: 2, column: 3),
    Count(row: 5, column: 4),
    Count(row: 6, column: 5),
    Count(row: 7, column: 6)
  ];
  List<int> angles = [0, 90, 270, 180];
  Count? count;
  List<Piece> pieceList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    MaterialButton(
                      color: Colors.greenAccent,
                      onPressed: () {
                        _getFromGallery();
                      },
                      child: const Text("PICK FROM GALLERY"),
                    ),
                    Container(
                      height: 40.0,
                    ),
                    MaterialButton(
                      color: Colors.lightGreenAccent,
                      onPressed: () {
                        _getFromCamera();
                      },
                      child: const Text("PICK FROM CAMERA"),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.height,
      maxHeight: MediaQuery.of(context).size.height,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        showRcAlert("");
        /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PicShow(ImageFile: imageFile!)));*/
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile =await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        showRcAlert("");
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PicShow(ImageFile: imageFile!)));*/
      });
    }
  }

  showRcAlert(String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return SimpleDialog(
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          contentPadding: const EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Rows/Columns"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 30,
                  ))
            ],
          ),
          children: [
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            SimpleDialogOption(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: numbers.length,
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          count = numbers[index];
                        });
                        var image;
                        var x = 0.0;
                        var y = 0.0;

                        final srcImage = decodeImage(
                            File(imageFile!.path).readAsBytesSync());

                        var picHeight = srcImage!.height;
                        var picWidth = srcImage!.width;
                        var height = picHeight / count!.row;
                        var width = picWidth / count!.column;

                        int picId = 0;
                        var imagesCount = count!.row * count!.column;

                        pieceList.clear();
                        Random rand = Random();

                        for (int i = 0; i < count!.row; i++) {
                          for (int j = 0; j < count!.column; j++) {
                            var croppedImage = copyCrop(srcImage!, x.round(),
                                y.round(), width.round(), height.round());

                            image = a.Image.memory(Uint8List.fromList(
                                imglib.encodeJpg(croppedImage)));
                            int randomIndex = rand.nextInt(angles.length);

                            Piece piece = Piece(
                                row: i,
                                column: j,
                                image: image,
                                angle: angles[randomIndex],
                                picId: picId);

                            pieceList.add(piece);

                            picId = picId + 1;

                            x = x + width;
                          }
                          x = 0.0;
                          y = y + height;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NameScreen(
                                      pieceList: pieceList,
                                      columnCount: count!.column,
                                      imageFile: imageFile,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${numbers[index].row}x${numbers[index].column}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                  }),
            )
          ],
        );
      },
    );
  }
}
