import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:fractured_photo/model/piece.dart';

class ShowImage extends StatefulWidget {
  List<Piece> pieceList;
  File? imageFile;

  int columnCount;

  ShowImage(
      {Key? key,
      required this.pieceList,
      required this.columnCount,
      required this.imageFile})
      : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  List<Piece> imageList = [];
  int? selectedIndex;
  int isConfirmIndex = 0;
  Color? color;
Timer? periodicTimer;
  @override
  void initState() {
    // TODO: implement initState

    widget.pieceList.shuffle(Random());

    for (int i = 0; i < widget.pieceList.length; i++) {
      //  imageList.add(widget.pieceList[i]);

      print("image${imageList.length}");
    }
     periodicTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          color = Colors.black;
        });
        // Update user about remaining time
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    imageList.clear();
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text("Show Image"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: DragAndDropGridView(
                    itemCount: widget.pieceList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.columnCount,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2),
                    addAutomaticKeepAlives: false,
                    onWillAccept: (oldIndex, newIndex) {
                      return true;

                      // If you want to accept the child return true or else return false
                    },
                    onReorder: (oldIndex, newIndex) {
                      // imageList.clear()

                      final temp = widget.pieceList[oldIndex];
                      widget.pieceList[oldIndex] = widget.pieceList[newIndex];
                      widget.pieceList[newIndex] = temp;
                      setState(() {
                        selectedIndex = newIndex;
                        print("$selectedIndex");
                      });
                      checkPuzzleSuccess();

                      setState(() {});
                    },
                    itemBuilder: (BuildContext context, int index) {
                      double angle = double.parse(
                              widget.pieceList[index].angle.toString()) *
                          0.0174533;
                      imageList.add(widget.pieceList[index]);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            print("$selectedIndex");
                          });
                        },
                        child: Transform.rotate(
                          angle: angle,
                          child: Image(
                            image: widget.pieceList[index].image.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showPreviewImage(context, "title");
                  },
                  child: const Text(
                    "Preview",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff1cc29f)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color(0xff1cc29f)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedIndex != null) {
                      if (widget.pieceList[selectedIndex!].angle % 360 == 0) {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle = 270;
                          checkPuzzleSuccess();
                        });
                      } else {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle =
                              widget.pieceList[selectedIndex!].angle - 90;
                          checkPuzzleSuccess();
                        });
                      }
                    }

                    imageList.clear();
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.rotate_left_outlined,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedIndex != null) {
                      if (widget.pieceList[selectedIndex!].angle % 360 == 0) {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle = 90;
                          checkPuzzleSuccess();
                        });
                      } else {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle =
                              widget.pieceList[selectedIndex!].angle + 90;
                          checkPuzzleSuccess();
                        });
                      }
                    }

                    imageList.clear();

                    setState(() {});
                  },
                  child: const Icon(
                    Icons.rotate_right_outlined,
                    color: Colors.black,
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  checkPuzzleSuccess() {
    isConfirmIndex = 0;
    for (int j = 0; j < widget.pieceList.length; j++) {
      if ((widget.pieceList[j].angle % 360 == 0) &&
          j == widget.pieceList[j].picId) {
        isConfirmIndex += 1;
        if (isConfirmIndex == widget.pieceList.length) {
          showAlertDialog(context, "Congratulations!\n You solved it.");
        }
      }
    }
  }

  showAlertDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
        });

         periodicTimer = Timer.periodic(
          const Duration(seconds: 2),
          (timer) {
            setState(() {
              color = Colors.red;
            });
            // Update user about remaining time
          },
        );
        return AlertDialog(
          content: new Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: color),
          ),
          actions: <Widget>[
            /* new FlatButton(
              child: new Text(
                "OK",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),*/
          ],
        );
      },
    );
  }

  showPreviewImage(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return SimpleDialog(
          titlePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          contentPadding: EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Preview"),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 30,
                  ))
            ],
          ),
          children: [
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            SimpleDialogOption(
              child: Image.file(File(widget.imageFile!.path)),
            )
          ],
        );
      },
    );
  }

  Widget imageview() {
    if (widget.imageFile == null) {
      return Text("photo not selected");
    } else {
      return Image.file(File(widget.imageFile!.path));
    }
  }
}
