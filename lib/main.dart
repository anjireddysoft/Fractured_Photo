import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fractured_photo/model/count.dart';
import 'package:fractured_photo/model/tile.dart';
import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/screens/paint.dart';
import 'package:fractured_photo/screens/puzzle_name.dart';
import 'package:fractured_photo/screens/puzzle_type.dart';
import 'package:fractured_photo/screens/saved_puzzles.dart';
import 'package:fractured_photo/screens/showImage.dart';
import 'package:fractured_photo/screens/utile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as a;
import 'package:uni_links/uni_links.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;
  bool _initialURILinkHandled = false;
  bool isFromUrl = true;

  File? imageFile;
  List<Count> numbers = [
    Count(row: 2, column: 3),
    Count(row: 5, column: 4),
    Count(row: 6, column: 5),
    Count(row: 7, column: 6)
  ];
  List<int> angles = [0, 90, 270, 180];
  Count? count;
  List<Piece_Info> pieceList = [];
  var jsonFileData;
  final ServiceMethods _serviceMethods = ServiceMethods();

  Future<void> _initURIHandler() async {
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2

      Fluttertoast.showToast(
          msg: "Invoked _initURIHandler",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white);
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI != null) {
          if (!mounted) {
            return;
          }
          setState(() {
            _initialURI = initialURI;
          });

          /*  WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ShowImage(
                      pieceList: pieceList,
                      columnCount: 1,
                      imageFile: imageFile,
                      rowCount: 2,
                      isFromSavedPuzzle: false,
                      intialUrl: _initialURI,
                      puzzleName: "puzzleName"),
                ));
          });*/
        } else {}
      } on PlatformException {
        // 5

      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    // 1

    if (!kIsWeb) {
      // 2

      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        setState(() {
          _currentURI = uri;

          _err = null;
        });
        // 3
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }

        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState

    _initURIHandler();
    _incomingLinkHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Colors.lightGreenAccent,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PuzzleType()));
                                },
                                child: const Text("Create Puzzle"),
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
                                color: Colors.lightGreenAccent,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Saved_Puzzle()));
                                },
                                child: const Text("Saved Puzzles"),
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
      ),
    );
  }

  Future<String> readCounter() async {
    try {
      final file = await _serviceMethods.localFile("puzzle.json");

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "0";
    }
  }

  ExtractZip(BuildContext context) async {
    File file = await _serviceMethods.localFile("puzzle.zip");

    final path = await _serviceMethods.localPath();
    final bytes = file.readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = "${path}/${file.name}";

      var filesFromZip = File(filename);
      filesFromZip = await filesFromZip.create(recursive: true);
      await filesFromZip.writeAsBytes(file.content);
    }

    File ImageFile = await _serviceMethods
        .localFile("scaled_image_picker2181986345133969841.jpg");

    var jsonFile = await readCounter();
    jsonFileData = jsonDecode(jsonFile);

    String rowColoumCount = jsonFileData["pattern"];
    int row = int.parse(rowColoumCount[0]);
    int column = int.parse(rowColoumCount[2]);

    splittingImage(
        context: context, pickedImageFile: ImageFile, row: row, column: column);
  }

  Future<File?> _downloadFile(String url, String filename) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    if (response.statusCode == 200) {
      var bytes;
      try {
        await consolidateHttpClientResponseBytes(response).then((value) {
          bytes = value;
        });

        String dir = (await getApplicationDocumentsDirectory()).path;
        File file = new File('$dir/$filename');
        await file.writeAsBytes(bytes);
        return file;
      } catch (err) {}
    } else {
      return null;
    }
  }

  _getFromGallery(BuildContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.height,
      maxHeight: MediaQuery.of(context).size.height,
    );
    if (pickedFile != null) {
      setState(() {
        isFromUrl == false;
        imageFile = File(pickedFile.path);
        showRcAlert("", context);
      });
    }
  }

  /// Get from Camera
  _getFromCamera(BuildContext context) async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        isFromUrl == false;
        imageFile = File(pickedFile.path);
        showRcAlert("", context);
      });
    }
  }

  showRcAlert(String title, BuildContext context) {
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

                        /*splittingImage(
                            context: context,
                            pickedImageFile: imageFile!,
                            row: count!.row,
                            column: count!.column);*/
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

  splittingImage(
      {required BuildContext context,
      required File pickedImageFile,
      required int row,
      required int column}) {
    var image;
    var x = 0.0;
    var y = 0.0;

    final srcImage = decodeImage(File(pickedImageFile.path).readAsBytesSync());

    var picHeight = srcImage!.height;
    var picWidth = srcImage!.width;

    var height = picHeight / row;
    var width = picWidth / column;

    int picId = 0;

    pieceList.clear();
    Random rand = Random();

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        var croppedImage = copyCrop(
            srcImage!, x.round(), y.round(), width.round(), height.round());

        String base64Image =
            base64.encode(Uint8List.fromList(imglib.encodeJpg(croppedImage)));

        int randomIndex = rand.nextInt(angles.length);

        Piece_Info piece = Piece_Info(
            image: base64Image,
            angle: angles[randomIndex],
            originalPosition: picId,
            currentPosition: picId);

        pieceList.add(piece);

        picId = picId + 1;

        x = x + width;
      }
      x = 0.0;
      y = y + height;
    }

    if (isFromUrl == true) {
      var pieceInfoList = (jsonFileData["pieces_info"] as List)
          .map((value) => Piece_Info.fromJson(value))
          .toList();
      for (int i = 0; i < pieceInfoList.length; i++) {
        for (int j = 0; j < pieceList.length; j++) {
          if (pieceList[j].originalPosition ==
              pieceInfoList[i].originalPosition) {
            pieceInfoList[i].image = pieceList[j].image;
          }
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowImage(
                    pieceList: pieceInfoList,
                    columnCount: column,
                    imageFile: pickedImageFile,
                    puzzleName: jsonFileData["puzzleName"],
                    rowCount: row,
                    isFromSavedPuzzle: false,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NameScreen(
                    pieceList: pieceList,
                    columnCount: count!.column,
                    imageFile: pickedImageFile,
                    rowCount: count!.row,
                    isFromSquarePuzzle: true,
                  )));
    }
  }
}
