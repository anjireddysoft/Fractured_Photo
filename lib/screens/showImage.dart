import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractured_photo/main.dart';
import 'package:fractured_photo/model/fileupload.dart';
import 'package:fractured_photo/model/piece.dart';
import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/model/puzzle_info.dart';
import 'package:fractured_photo/screens/utile.dart';
import 'package:fractured_photo/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ShowImage extends StatefulWidget {
  List<Piece> pieceList;
  File? imageFile;
  int columnCount;
  int rowCount;
  String puzzleName;
  bool isFromSavedPuzzle;
  PuzzleInfo? puzzleInfo;
  int? puzzleId;
  Uri? intialUrl;

  ShowImage(
      {Key? key,
      required this.pieceList,
      required this.columnCount,
      required this.imageFile,
      required this.rowCount,
      required this.isFromSavedPuzzle,
      required this.puzzleName,
      this.puzzleInfo,
      this.intialUrl,
      this.puzzleId})
      : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  List<Piece> imageList = [];
  int? selectedIndex;
  int isConfirmIndex = 0;
  Color? color;

  ByteData? bytes;
  Uint8List? congratulationsAudioBytes;
  ByteData? clickBytes;
  Uint8List? clickAudioBytes;
  AudioPlayer player = AudioPlayer();
  bool isBlack = true;

  TextStyle? _style;
  Timer? timer;
  var index = 1;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<PuzzleInfo> puzzleInfoList = [];
  List<Piece_Info> pieceInfoList = [];
  Uint8List? _imageFile;
  ServiceMethods serviceMethods = ServiceMethods();

  // File? screenShotImageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  readData() {
    databaseHelper.getPuzzleList().then((value) {
      print("value${value.length}");
      setState(() {
        puzzleInfoList = value;
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseHelper = DatabaseHelper();
    player = AudioPlayer();
    readData();
    if (!widget.isFromSavedPuzzle) {
      widget.pieceList.shuffle(Random());
    }

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
    print("initialUrl${widget.intialUrl.toString()}");
    imageList.clear();
    return Scaffold(

      appBar: AppBar(
        title: const Text("Show Image"),
      ),
      body: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                  child: Screenshot(
                controller: screenshotController,
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
                    onReorder: (oldIndex, newIndex) async {
                      final temp = widget.pieceList[oldIndex];
                      widget.pieceList[oldIndex] = widget.pieceList[newIndex];
                      widget.pieceList[newIndex] = temp;
                      int result = await player.playBytes(clickAudioBytes!);
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
                      Image image = Image.memory(
                          base64Decode(widget.pieceList[index].image));

                      return GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                        },
                        child: Transform.rotate(
                          angle: angle,
                          child: Image(
                            image: image.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      showPreviewImage(context, "title");
                    },
                    child: const Text(
                      "Preview",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff1cc29f)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      PuzzleInfo puzzleInfo = PuzzleInfo(
                        dateTime: DateFormat('dd-mmm-yyyy hh:mm:ss')
                            .format(DateTime.now().toUtc())
                            .toString(),
                        file_path: widget.imageFile!.path,
                        puzzleName: widget.puzzleName,
                        pattern: "${widget.rowCount}x${widget.columnCount}"
                            .toString(),
                        pieces_count: int.parse(
                            "${widget.rowCount * widget.columnCount}"),
                      );
                      if (!widget.isFromSavedPuzzle) {
                        databaseHelper.insertPuzzle(puzzleInfo).then((value) {
                          bool isDataSaved = true;
                          String dataSaveError = "";
                          for (int i = 0; i < widget.pieceList.length; i++) {
                            Piece_Info piece_info = Piece_Info(
                                puzzleId: value,
                                rotation: widget.pieceList[i].angle,
                                currentPosition: i,
                                originalPosition:
                                    widget.pieceList[i].original_Position,
                                image: widget.pieceList[i].image);
                            databaseHelper
                                .insertPiece(piece_info)
                                .then((value) {})
                                .catchError((onError) {
                              isDataSaved = false;
                              dataSaveError = onError.toString();
                            });
                          }

                          if (isDataSaved) {
                            showAlertDialogForDbOperations(
                                context, "Your puzzle saved successfully");
                          } else {
                            showAlertDialogForDbOperations(
                                context, dataSaveError);
                          }
                        }).catchError((onError) {
                          showAlertDialogForDbOperations(
                              context, onError.toString());
                        });
                      } else {
                        databaseHelper
                            .deletePiece(widget.puzzleId!)
                            .then((value) {
                          bool isDataSaved = true;
                          String dataSaveError = "";
                          for (int i = 0; i < widget.pieceList.length; i++) {
                            Piece_Info piece_info = Piece_Info(
                                puzzleId: widget.puzzleId,
                                rotation: widget.pieceList[i].angle,
                                currentPosition: i,
                                originalPosition:
                                    widget.pieceList[i].original_Position,
                                image: widget.pieceList[i].image);
                            databaseHelper
                                .insertPiece(piece_info)
                                .then((value) {})
                                .catchError((onError) {
                              isDataSaved = false;
                              dataSaveError = onError.toString();
                            });
                          }

                          if (isDataSaved) {
                            showAlertDialogForDbOperations(
                                context, "Your puzzle updated successfully");
                          } else {
                            showAlertDialogForDbOperations(
                                context, dataSaveError);
                          }
                        }).catchError((onError) {
                          showAlertDialogForDbOperations(
                              context, onError.toString());
                        });
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff1cc29f)),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        shareData();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xff1cc29f)),
                      child: Text("Share")),
                  IconButton(
                    onPressed: () {
                      if (selectedIndex != null) {
                        playClickAudio();
                        if (widget.pieceList[selectedIndex!].angle % 360 == 0) {
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
                      // setState(() {});
                    },
                    icon: const Icon(
                      Icons.rotate_left_outlined,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (selectedIndex != null) {
                        if (widget.pieceList[selectedIndex!].angle % 360 == 0) {
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

                      //  setState(() {});
                    },
                    icon: const Icon(
                      Icons.rotate_right_outlined,
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  checkPuzzleSuccess() {
    isConfirmIndex = 0;
    for (int j = 0; j < widget.pieceList.length; j++) {
      if ((widget.pieceList[j].angle % 360 == 0) &&
          j == widget.pieceList[j].original_Position) {
        isConfirmIndex += 1;
        if (isConfirmIndex == widget.pieceList.length) {
          showAlertDialog(context, "Congratulations!\n You solved it.");
          playCongratulationsAudio();
        }
      }
    }
  }

  showAlertDialogForDbOperations(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        Future.delayed(const Duration(seconds: 5), () {
          //  Navigator.of(context).pop(true);
        });

        return AlertDialog(
          content: Text(title,
              style: const TextStyle(color: Colors.black, fontSize: 20)),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (route) => false);
              },
              color: Colors.green,
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  showAlertDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext c) {
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context).pop(true);
          stopAudio();
          timer!.cancel();
        });

        return StatefulBuilder(
          builder: (context, st) {
            timer = Timer.periodic(Duration(milliseconds: 700), (timer) {
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
                  isBlack = true;
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

  shareData() async {
    final directory = await getApplicationDocumentsDirectory();
    pieceInfoList.clear();
    for (int i = 0; i < widget.pieceList.length; i++) {
      Piece_Info pieceInfo = Piece_Info(
          rotation: widget.pieceList[i].angle,
          currentPosition: i,
          originalPosition: widget.pieceList[i].original_Position);

      pieceInfoList.add(pieceInfo);
    }
    Map<String, dynamic> jsonObject=Map();
    if(widget.isFromSavedPuzzle) {
      jsonObject = {
        "puzzleName": widget.puzzleInfo!.puzzleName,
        "pattern": widget.puzzleInfo!.pattern,
        "pieceCount": widget.puzzleInfo!.pieces_count,
        "dateTime": widget.puzzleInfo!.dateTime,
        "pieces_info": pieceInfoList,
      };
    }else{
      jsonObject = {
        "puzzleName": widget.puzzleName,
        "pattern": "${widget.rowCount}x${widget.columnCount}",
        "pieceCount": widget.rowCount*widget.columnCount,
        "dateTime":  DateFormat('dd-mmm-yyyy hh:mm:ss')
        .format(DateTime.now().toUtc())
        .toString(),
        "pieces_info": pieceInfoList,
      };
    }
  File file = await writePuzzle(jsonEncode(jsonObject));


    print("flie==${file.toString()}");

    var encoder = ZipFileEncoder();
    encoder.create(directory.path + "/" + "puzzle.zip");
    encoder.addFile(File(file.path));
    encoder.addFile(widget.imageFile!);
    encoder.close();
    final fileImage = await serviceMethods.localFile("image.jpg");
    screenshotController.capture().then((Uint8List? image) async {
      //Capture Done

      fileImage.writeAsBytesSync(image!);

      var response = await uploadImage(encoder, fileImage);
      if (response != null) {
        Share.share(response.file.toString(), subject: "fractured photo");
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<File> writePuzzle(jsondata) async {
    final file = await serviceMethods.localFile("puzzle.json");

    // Write the file
    return file.writeAsString('$jsondata');
  }

  Future<File> writeImage() async {
    final file = await serviceMethods.localFile("image.jpg");
    screenshotController.capture().then((Uint8List? image) {
      //Capture Done

      file.writeAsBytesSync(image!);
    }).catchError((onError) {
      print(onError);
    });
    return file;
  }

  Future<FileUpload> uploadImage(ZipFileEncoder file, File sharedImage) async {
    Response response;
    var dio = Dio();
    String imageFileName = sharedImage.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(sharedImage.path,
          filename: "puzzle.zip"),
      "shared_image": await MultipartFile.fromFile(sharedImage.path,
          filename: imageFileName),
    });
    response = await dio.post("https://fracturedphotoapp.com/upload.php",
        data: formData);
    if (response.statusCode == 200) {
      return FileUpload.fromJson(json.decode(response.data));
    }
    return FileUpload.fromJson(json.decode(response.data));
  }
}
