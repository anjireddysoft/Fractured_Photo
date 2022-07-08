import 'dart:io';
import 'dart:math';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:fractured_photo/model/piece.dart';

class ShowImage extends StatefulWidget {
  List<Piece> pieceList;

  int columnCount;

  ShowImage({Key? key, required this.pieceList, required this.columnCount})
      : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  List<Piece> imageList = [];
  int? selectedIndex;
  int isConfirmIndex=0;

  @override
  void initState() {
    // TODO: implement initState

    widget.pieceList.shuffle(Random());

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
                  onWillAccept: (oldIndex, newIndex) {
                    print("length${widget.pieceList.length}");
                    print("length${imageList.length}");
                    if (imageList.length>widget.pieceList.length){
                      print("anji");
                      return false;
                    }
                    return true;
                    // If you want to accept the child return true or else return false
                  },
                  onReorder: (oldIndex, newIndex) {

                    final temp = widget.pieceList[oldIndex];
                    widget.pieceList[oldIndex] = widget.pieceList[newIndex];
                    widget.pieceList[newIndex] = temp;

                    isConfirmIndex=0;
                    for (int j = 0; j < imageList.length; j++) {
                      print("degree${imageList[j].angle},picId${widget.pieceList[j].picId}== ${imageList[j].picId}");

                      if ((imageList[j].angle == 0 ||
                          imageList[j].angle == 360) &&
                          widget.pieceList[j].picId == imageList[j].picId) {
                        isConfirmIndex+=1;
                        if(isConfirmIndex==imageList.length){
                          showAlertDialog(context, "Puzzle solved successfully");
                        }

                      }
                    }



                    setState(() {});
                  },
                  itemBuilder: (BuildContext context, int index) {
                    double angle =
                        double.parse(widget.pieceList[index].angle.toString()) *
                            0.0174533;
                    imageList.add(widget.pieceList[index]);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          print("$selectedIndex");imageList.clear();
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
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
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
                      if (widget.pieceList[selectedIndex!].angle >= 360) {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle = 360;
                        });
                      } else {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle =
                              widget.pieceList[selectedIndex!].angle - 90;
                        });
                      }
                    }

                    print("length${widget.pieceList.length}");
                    print("length${imageList.length}");
                    isConfirmIndex=0;
                    for (int j = 0; j < imageList.length; j++) {
                      print("degree${imageList[j].angle},picId${widget.pieceList[j].picId}== ${imageList[j].picId}");

                      if ((imageList[j].angle == 0 ||
                          imageList[j].angle == 360) &&
                          widget.pieceList[j].picId == imageList[j].picId) {
                        isConfirmIndex+=1;
                        if(isConfirmIndex==imageList.length){
                          showAlertDialog(context, "Puzzle solved successfully");
                        }

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
                      if (widget.pieceList[selectedIndex!].angle >= 360) {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle = 360;
                        });
                      } else {
                        setState(() {
                          widget.pieceList[selectedIndex!].angle =
                              widget.pieceList[selectedIndex!].angle + 90;
                        });
                      }
                    }
                    isConfirmIndex=0;
                    for (int j = 0; j < imageList.length; j++) {
                       print("degree${imageList[j].angle},picId${widget.pieceList[j].picId}== ${imageList[j].picId}");

                      if ((imageList[j].angle == 0 ||
                              imageList[j].angle == 360) &&
                          widget.pieceList[j].picId == imageList[j].picId) {
                        isConfirmIndex+=1;
                        if(isConfirmIndex==imageList.length){
                        showAlertDialog(context, "Puzzle solved successfully");
                        }

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

  showAlertDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        return AlertDialog(
          title: new Text("Wow!"),
          content: new Text(title),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "OK",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
/*  Widget imageview() {
    if (widget.imageFile == null) {
      return Text("photo not selected");
    } else {
      return Image(image: widget.imageFile.image);
    }
  }*/
}
