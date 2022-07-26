import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractured_photo/main.dart';
import 'package:fractured_photo/model/fileupload.dart';
import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/model/puzzle_info.dart';
import 'package:fractured_photo/screens/paint.dart';
import 'package:fractured_photo/screens/utile.dart';
import 'package:fractured_photo/utils/database_helper.dart';
import 'package:image/image.dart' as I;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:share_plus/share_plus.dart';

class ShowImage extends StatefulWidget {
  List<Piece_Info> pieceList;
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
  List<Piece_Info> imageList = [];
  int? selectedIndex;
  int isConfirmIndex = 0;

  ByteData? bytes;
  Uint8List? congratulationsAudioBytes;
  ByteData? clickBytes;
  Uint8List? clickAudioBytes;
  AudioPlayer player = AudioPlayer();
  bool isBlack = true;

  TextStyle? _style;
  Timer? timer;
  bool isFileSended=false;


  DatabaseHelper databaseHelper = DatabaseHelper();


  ServiceMethods serviceMethods = ServiceMethods();

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    databaseHelper = DatabaseHelper();
    player = AudioPlayer();
/*
    if (!widget.isFromSavedPuzzle) {
      widget.pieceList.shuffle(Random());
    }*/

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

    clickBytes =
        await rootBundle.load(clickAudioAsset); //load audio from assets
    clickAudioBytes = clickBytes!.buffer
        .asUint8List(clickBytes!.offsetInBytes, clickBytes!.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    imageList.clear();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Image"),
      ),
      body: Stack(
        children: [

              Container(
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

                          } else {

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
                              base64Decode(widget.pieceList[index].image!));

                          return GestureDetector(
                            onTap: () async{
                              selectedIndex = index;
                             var bytes =base64Decode(widget.pieceList[index].image!);
                              var codec = await instantiateImageCodec(bytes);
                              var frame = await codec.getNextFrame();
                               frame.image;


                            },
                            child: Transform.rotate(
                              angle: angle,
                              child: Image(
                                image: image.image,
                                fit: BoxFit.contain,
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
                                    angle: widget.pieceList[i].angle,
                                    currentPosition: i,
                                    originalPosition:
                                        widget.pieceList[i].originalPosition,
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
                                    angle: widget.pieceList[i].angle,
                                    currentPosition: i,
                                    originalPosition:
                                        widget.pieceList[i].originalPosition,
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
                          child: const Text("Share")),
                      IconButton(
                        onPressed: () {
                          if (selectedIndex != null) {
                            playAudio(clickAudioBytes!);
                            if (widget.pieceList[selectedIndex!].angle % 360 ==
                                0) {
                              setState(() {
                                widget.pieceList[selectedIndex!].angle = 270;

                                checkPuzzleSuccess();
                              });
                            } else {
                              playAudio(clickAudioBytes!);
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
                            if (widget.pieceList[selectedIndex!].angle % 360 ==
                                0) {
                              playAudio(clickAudioBytes!);
                              setState(() {
                                widget.pieceList[selectedIndex!].angle = 90;
                                checkPuzzleSuccess();
                              });
                            } else {
                             playAudio(clickAudioBytes!);
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
          isFileSended? Container(
            child: Center(child: CircularProgressIndicator()),
          ):Container(),
            ],
      ),
    );
  }

  checkPuzzleSuccess() {
    isConfirmIndex = 0;
    for (int j = 0; j < widget.pieceList.length; j++) {
      if ((widget.pieceList[j].angle % 360 == 0) &&
          j == widget.pieceList[j].originalPosition) {
        isConfirmIndex += 1;
        if (isConfirmIndex == widget.pieceList.length) {
          showAlertDialog(context, "Congratulations!\n You solved it.");
         playAudio(congratulationsAudioBytes!);
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
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (route) => false);
              },
              color: Colors.green,
              child: const Text("OK"),
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
            timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
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

    } else {
    }
  }

  playAudio(Uint8List uint8list)async{
    int result = await player.playBytes(uint8list);
    if (result == 1) {
      //play success

    } else {
    }
  }

  shareData() async {
    final directory = await getApplicationDocumentsDirectory();
    List<Piece_Info> pieceInfoList = [];
    setState(() {
      isFileSended=true;
    });

    for (int i = 0; i < widget.pieceList.length; i++) {
      Piece_Info pieceInfo = Piece_Info(
          angle: widget.pieceList[i].angle,
          currentPosition: i,
          originalPosition: widget.pieceList[i].originalPosition);

      pieceInfoList.add(pieceInfo);
    }
    Map<String, dynamic> jsonObject = Map();
    if (widget.isFromSavedPuzzle) {
      jsonObject = {
        "puzzleName": widget.puzzleInfo!.puzzleName,
        "pattern": widget.puzzleInfo!.pattern,
        "pieceCount": widget.puzzleInfo!.pieces_count,
        "dateTime": widget.puzzleInfo!.dateTime,
        "pieces_info": pieceInfoList,
      };
    } else {
      jsonObject = {
        "puzzleName": widget.puzzleName,
        "pattern": "${widget.rowCount}x${widget.columnCount}",
        "pieceCount": widget.rowCount * widget.columnCount,
        "dateTime": DateFormat('dd-mmm-yyyy hh:mm:ss')
            .format(DateTime.now().toUtc())
            .toString(),
        "pieces_info": pieceInfoList,
      };
    }
    File file = await writePuzzle(jsonEncode(jsonObject));

    print("flie==${file.toString()}");

    /*File selectedImageFile=await serviceMethods.localFile("selectedImage.jpg");
    final bytes = widget.imageFile!.readAsBytesSync();
    print("bytes$bytes");
    selectedImageFile = await selectedImageFile.writeAsBytes(bytes);*/

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
        setState(() {
          isFileSended=false;
        });
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



  Future<FileUpload?> uploadImage(ZipFileEncoder file, File sharedImage) async {
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
    return null;
  }
}
