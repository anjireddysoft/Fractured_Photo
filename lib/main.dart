import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fractured_photo/model/count.dart';
import 'package:fractured_photo/model/piece.dart';

import 'package:fractured_photo/screens/puzzle_name.dart';
import 'package:fractured_photo/screens/saved_puzzles.dart';

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              color: Colors.greenAccent,
                              onPressed: () {
                                _getFromGallery();
                              },
                              child: const Text("PICK FROM GALLERY"),
                            ),
                          ),
                        ],
                      ),
                      const  SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              color: Colors.lightGreenAccent,
                              onPressed: () {
                                _getFromCamera();
                              },
                              child: const Text("PICK FROM CAMERA"),
                            ),
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              color: Colors.lightBlueAccent,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        const  Saved_Puzzle()));
                              },
                              child:  const Text("SAVED PUZZLES"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
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
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
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
                        var picWidth = srcImage!.width ;
                        print("picHeight$picHeight");
                        print("picWidth$picWidth");
                        var height = picHeight! / count!.row;
                        var width = picWidth! / count!.column;
                        print("height$height");
                        print("width$width");
                        int picId = 0;


                        pieceList.clear();
                        Random rand = Random();

                        for (int i = 0; i < count!.row; i++) {
                          for (int j = 0; j < count!.column; j++) {
                            var croppedImage = copyCrop(srcImage!, x.round(),
                                y.round(), width.round(), height.round());


                            String base64Image = base64.encode(
                                Uint8List.fromList(
                                    imglib.encodeJpg(croppedImage)));

                            image = a.Image.memory(Uint8List.fromList(
                                imglib.encodeJpg(croppedImage)));
                            int randomIndex = rand.nextInt(angles.length);

                            Piece piece = Piece(
                                image: base64Image,
                                angle: angles[randomIndex],
                                original_Position: picId);

                            pieceList.add(piece);

                            picId = picId + 1;
                            print("($i,$j)");
                            print("x==$x   y==$y");
                            x = x + width;

                          }
                          x = 0.0;
                          y = y + height;
                          print("x==$x   y==$y");
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NameScreen(
                                      pieceList: pieceList,
                                      columnCount: count!.column,
                                      imageFile: imageFile,
                                      rowCount: count!.row,
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
