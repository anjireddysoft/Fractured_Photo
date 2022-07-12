import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractured_photo/model/piece.dart';

class ShowImage extends StatefulWidget {
  List<Piece> pieceList;
  File? imageFile;
  int columnCount;
  String puzzleName;

  ShowImage(
      {Key? key,
      required this.pieceList,
      required this.columnCount,
      required this.imageFile,
      required this.puzzleName})
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
  ByteData? bytes;
  Uint8List? congratulationsAudioBytes;
  ByteData? clickBytes;
  Uint8List? clickAudioBytes;
  AudioPlayer player = AudioPlayer();
  bool isBlack = true;
  TextStyle _redStyle = TextStyle(
    color: Colors.red,
    fontSize: 24,
  );
  TextStyle _blackStyle = TextStyle(
    color: Colors.black,
    fontSize: 24,
  );
  TextStyle? _style;
  Timer? timer;
  var index = 1;

  @override
  void initState() {
    // TODO: implement initState
    player = AudioPlayer();

    widget.pieceList.shuffle(Random());

    readAudioFiles();
    super.initState();
  }

  readAudioFiles() async {
    String congratulationsAudioAsset = "assets/congratulations_audio.mp3";
    String clickAudioAsset = "assets/click.mp3";
    bytes = await rootBundle
        .load(congratulationsAudioAsset); //load audio from assets
    congratulationsAudioBytes =
        bytes!.buffer.asUint8List(bytes!.offsetInBytes, bytes!.lengthInBytes);
    print("congratulationsAudioBytes${congratulationsAudioBytes.toString()}");
    clickBytes =
        await rootBundle.load(clickAudioAsset); //load audio from assets
    clickAudioBytes = clickBytes!.buffer
        .asUint8List(clickBytes!.offsetInBytes, clickBytes!.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    imageList.clear();
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text("Show Image"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  Expanded(
                      child: DragAndDropGridView(
                          itemCount: widget.pieceList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: widget.columnCount,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2),
                          addAutomaticKeepAlives: false,
                          onWillAccept: (oldIndex, newIndex) {
                            return true;

                            // If you want to accept the child return true or else return false
                          },
                          onReorder: (oldIndex, newIndex) async {
                            // imageList.clear()

                            final temp = widget.pieceList[oldIndex];
                            widget.pieceList[oldIndex] =
                                widget.pieceList[newIndex];
                            widget.pieceList[newIndex] = temp;
                            int result =
                                await player.playBytes(clickAudioBytes!);
                            if (result == 1) {
                              //play success
                              print("audio is playing.");
                            } else {
                              print("Error while playing audio.");
                            }
                            setState(() {
                              selectedIndex = newIndex;
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
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1cc29f)),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1cc29f)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedIndex != null) {
                            playClickAudio();
                            if (widget.pieceList[selectedIndex!].angle % 360 ==
                                0) {
                              setState(() {
                                widget.pieceList[selectedIndex!].angle = 270;

                                checkPuzzleSuccess();
                              });
                            } else {
                              playClickAudio();
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
                            if (widget.pieceList[selectedIndex!].angle % 360 ==
                                0) {
                              playClickAudio();
                              setState(() {
                                widget.pieceList[selectedIndex!].angle = 90;
                                checkPuzzleSuccess();
                              });
                            } else {
                              playClickAudio();
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
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: DragAndDropGridView(
                              itemCount: widget.pieceList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: widget.columnCount,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2),
                              addAutomaticKeepAlives: false,
                              onWillAccept: (oldIndex, newIndex) {
                                return true;

                                // If you want to accept the child return true or else return false
                              },
                              onReorder: (oldIndex, newIndex) async {
                                // imageList.clear()

                                final temp = widget.pieceList[oldIndex];
                                widget.pieceList[oldIndex] =
                                    widget.pieceList[newIndex];
                                widget.pieceList[newIndex] = temp;
                                int result =
                                    await player.playBytes(clickAudioBytes!);
                                if (result == 1) {
                                  //play success
                                  print("audio is playing.");
                                } else {
                                  print("Error while playing audio.");
                                }
                                setState(() {
                                  selectedIndex = newIndex;
                                });
                                checkPuzzleSuccess();

                                setState(() {});
                              },
                              itemBuilder: (BuildContext context, int index) {
                                double angle = double.parse(widget
                                        .pieceList[index].angle
                                        .toString()) *
                                    0.0174533;
                                imageList.add(widget.pieceList[index]);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Transform.rotate(
                                    angle: angle,
                                    child: Image(
                                      image:
                                          widget.pieceList[index].image.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              })),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (selectedIndex != null) {
                                  playClickAudio();
                                  if (widget.pieceList[selectedIndex!].angle %
                                          360 ==
                                      0) {
                                    setState(() {
                                      widget.pieceList[selectedIndex!].angle =
                                          270;

                                      checkPuzzleSuccess();
                                    });
                                  } else {
                                    playClickAudio();
                                    setState(() {
                                      widget.pieceList[selectedIndex!].angle =
                                          widget.pieceList[selectedIndex!]
                                                  .angle -
                                              90;

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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedIndex != null) {
                                  if (widget.pieceList[selectedIndex!].angle %
                                          360 ==
                                      0) {
                                    playClickAudio();
                                    setState(() {
                                      widget.pieceList[selectedIndex!].angle =
                                          90;
                                      checkPuzzleSuccess();
                                    });
                                  } else {
                                    playClickAudio();
                                    setState(() {
                                      widget.pieceList[selectedIndex!].angle =
                                          widget.pieceList[selectedIndex!]
                                                  .angle +
                                              90;

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
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showPreviewImage(context, "title");
                              },
                              child: const Text(
                                "Preview",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff1cc29f)),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff1cc29f)),
                            ),
                          ],
                        ),
                      )
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
          playCongratulationsAudio();
        }
      }
    }
  }

  showAlertDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
          stopAudio();
          // timer!.cancel();
        });

        return StatefulBuilder(
          builder: (context, st) {
            Timer.periodic(Duration(milliseconds: 700), (timer) {
             // isBlack = !isBlack;
              if (isBlack == true) {
                st(() {
                  _style = const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  );
                  isBlack = false;
                });
              } else {
                st(() {
                  _style = const TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                  );
                  isBlack=true;
                });
              }

              print("index$index");
              print("rebuild");
            });

            return AlertDialog(
              content: Text(title, textAlign: TextAlign.center, style: _style),
            );
          },
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
          titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          contentPadding: const EdgeInsets.all(0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Preview"),
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
              child: Image.file(File(widget.imageFile!.path)),
            )
          ],
        );
      },
    );
  }

  stopAudio() async {
    int result = await player.stop();
    if (result == 1) {
      //play success
      print("audio is stoped.");
    } else {
      print("Error while playing  stop audio.");
    }
  }

  playCongratulationsAudio() async {
    print("congratulationsAudioBytes${congratulationsAudioBytes.toString()}");
    int result = await player.playBytes(congratulationsAudioBytes!);
    if (result == 1) {
      //play success
      print("audio is congratulations playing.");
    } else {
      print("Error while playing congratulations audio.");
    }
  }

  playClickAudio() async {
    int result = await player.playBytes(clickAudioBytes!);
    if (result == 1) {
      //play success
      print("audio is playing.");
    } else {
      print("Error while playing audio.");
    }
  }
}
