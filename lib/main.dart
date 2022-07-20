import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fractured_photo/model/count.dart';
import 'package:fractured_photo/model/piece.dart';
import 'package:fractured_photo/model/piece_info.dart';

import 'package:fractured_photo/screens/puzzle_name.dart';
import 'package:fractured_photo/screens/saved_puzzles.dart';
import 'package:fractured_photo/screens/showImage.dart';
import 'package:fractured_photo/screens/utile.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as a;
import 'package:path/path.dart';
import 'package:uni_links/uni_links.dart';
import 'package:path_provider/path_provider.dart';

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
  List<Piece> pieceList = [];
  var jsonFileData;
  ServiceMethods _serviceMethods = new ServiceMethods();

  Future<void> _initURIHandler() async {
    print("A1");
    // 1
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      // 2
      print("A2");
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
          print("Initial URI received $initialURI");
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
        } else {
          print("Null Initial URI received");
        }
      } on PlatformException {
        // 5
        print("Failed to receive initial uri");
      } on FormatException catch (err) {
        // 6
        if (!mounted) {
          return;
        }
        print('Malformed Initial URI received');
        setState(() => _err = err);
      }
    }
  }

  void _incomingLinkHandler() {
    // 1
    print("A3");
    if (!kIsWeb) {
      // 2
      print("A5");
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        print("A6");
        if (!mounted) {
          return;
        }
        print('Received URI: $uri');
        setState(() {
          _currentURI = uri;

          _err = null;
        });
        // 3
        print("A4");
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        print("A7");
        print('Error occurred: $err');
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
    read();
    _initURIHandler();
    _incomingLinkHandler();
    super.initState();
  }

  read() async {
    var name = await _serviceMethods.localFile("puzzle.json");
    print("localPath${name}");
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Colors.lightGreenAccent,
                                onPressed: () async {
                                  String completeUrl = "https://fracturedphotoapp.com/mobile.php?filename=43krK.fp";
                                  var fileName = completeUrl
                                      .split("=")
                                      .last;


                                  var file = await _downloadFile("https://fracturedphotoapp.com/mobile.php?filename=43krK.fp", fileName);
                                  print("file${file.toString()}");
                                },
                                child: const Text("DOWNLOAD FILE"),
                              ),
                            ),
                          ],
                        ),*/
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Colors.greenAccent,
                                onPressed: () {
                                  setState(() {
                                    isFromUrl=false;
                                  });
                                  _getFromGallery(context);
                                },
                                child: const Text("PICK FROM GALLERY"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Colors.greenAccent,
                                onPressed: () {
                                  setState(() {
                                      isFromUrl == true;
                                  });
                                  ExtractZip(context);
                                },
                                child: const Text("Extract.fp"),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: Colors.lightGreenAccent,
                                onPressed: () {
                                  setState(() {
                                    isFromUrl=false;
                                  });
                                  _getFromCamera(context);
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
                                              const Saved_Puzzle()));
                                },
                                child: const Text("SAVED PUZZLES"),
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
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

    final directory = await getApplicationDocumentsDirectory();
    final bytes = file.readAsBytesSync();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = "${directory.path}/${file.name}";
      var filesFromZip = File(filename);
      filesFromZip = await filesFromZip.create(recursive: true);
      await filesFromZip.writeAsBytes(file.content);
    }

    File ImageFile = await _serviceMethods
        .localFile("scaled_image_picker4439806190491254738.jpg");

    var jsonFile = await readCounter();
    jsonFileData = jsonDecode(jsonFile);
    print("data${jsonDecode(jsonFile)}");
    String rowColoumCount = jsonFileData["pattern"];
    int row = int.parse("${rowColoumCount![0]}");
    int column = int.parse("${rowColoumCount![2]}");

    splittingImage(
        context: context, pickedImageFile: ImageFile, row: row, column: column);
  }

  Future<File?> _downloadFile(String url, String filename) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    if (response.statusCode == 200) {
      print("bytes");
      var bytes;
      try {
        await consolidateHttpClientResponseBytes(response).then((value) {
          print("value$value");
          bytes = value;
        });
        print("bytes$bytes");
        String dir = (await getApplicationDocumentsDirectory()).path;
        File file = new File('$dir/$filename');
        await file.writeAsBytes(bytes);
        return file;
      } catch (err) {
        print("err${err.toString()}");
      }
    } else {
      print("response==null");
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
                        splittingImage(
                            context: context,
                            pickedImageFile: imageFile!,
                            row: count!.row,
                            column: count!.column);
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

    final srcImage = decodeImage(File(pickedImageFile!.path).readAsBytesSync());

    var picHeight = srcImage!.height;
    var picWidth = srcImage!.width;
    print("picHeight$picHeight");
    print("picWidth$picWidth");
    var height = picHeight! / row;
    var width = picWidth! / column;
    print("height$height");
    print("width$width");
    int picId = 0;

    pieceList.clear();
    Random rand = Random();

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        var croppedImage = copyCrop(
            srcImage!, x.round(), y.round(), width.round(), height.round());

        String base64Image =
            base64.encode(Uint8List.fromList(imglib.encodeJpg(croppedImage)));

        image =
            a.Image.memory(Uint8List.fromList(imglib.encodeJpg(croppedImage)));
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


    if (isFromUrl == true) {
      var pieceInfoList = (jsonFileData["pieces_info"] as List)
          .map((value) => Piece_Info.fromJson(value))
          .toList();
      for (int i = 0; i < pieceList.length; i++) {
        for (int j = 0; j < pieceInfoList.length; j++) {
          if (pieceList[i].original_Position ==
              pieceInfoList[j].originalPosition) {
           /* pieceList[i].original_Position = pieceInfoList[j].originalPosition!;
            pieceList[i].current_Position = pieceInfoList[j].currentPosition!;
            pieceList[i].angle = pieceInfoList[j].rotation!;*/


          }
        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShowImage(
                    pieceList: pieceList,
                    columnCount: column,
                    imageFile: imageFile,
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
                  )));
    }
  }
}
