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
import 'package:fractured_photo/model/mask.dart';
import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/screens/paint.dart';
import 'package:fractured_photo/screens/puzzle_name.dart';
import 'package:fractured_photo/screens/saved_puzzles.dart';
import 'package:fractured_photo/screens/showImage.dart';
import 'package:fractured_photo/screens/utile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as a;
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
                                    isFromUrl = false;
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
                                    isFromUrl = false;
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
                        SplitImgeShorted(1.0, 1.0);
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

  SplitImgeShorted(var wScaleFactor, var hScaleFactor) async {
    final srcImage = decodeImage(File(imageFile!.path).readAsBytesSync());
    List<Mask> maskList = [];
    var picHeight = srcImage!.height;
    var picWidth = srcImage!.width;

    print("(picWidth,picHeight)==(${srcImage!.width},${srcImage!.height})");
    var wSF = picWidth / 480;
    var hSF = picHeight / 640;

    print("(wSF,hSF)==(${wSF},${hSF})");


    maskList.add(Mask(imageName:"mask_1",image:"assets/p1_mask_1.png",x1: 0, y1: 0, x2: 52, y2: 78, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_2",image:"assets/p1_mask_2.png",x1: 5, y1: 0, x2: 119, y2: 131, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_3",image:"assets/p1_mask_3.png",x1: 91, y1: 0, x2: 167, y2: 129, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_4",image:"assets/p1_mask_4.png",x1: 128, y1: 0, x2: 188, y2: 228, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_5",image:"assets/p1_mask_5.png",x1: 166, y1: 0, x2: 260, y2: 228, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_6",image:"assets/p1_mask_6.png",x1: 232, y1: 0, x2: 342, y2: 114, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_7",image:"assets/p1_mask_7.png",x1: 308, y1: 0, x2: 458, y2: 117, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_8",image:"assets/p1_mask_8.png",x1: 437, y1: 0, x2: 542, y2: 116, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_9",image:"assets/p1_mask_9.png",x1: 384, y1: 33, x2: 488, y2: 118, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_10",image:"assets/p1_mask_10.png",x1: 540, y1: 0, x2: 640, y2: 119, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_11",image:"assets/p1_mask_11.png",x1: 0, y1: 78, x2: 31, y2: 246, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_12",image:"assets/p1_mask_12.png",x1: 30, y1: 40, x2: 190, y2: 229, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_13",image:"assets/p1_mask_13.png",x1: 246, y1: 106, x2: 398, y2: 250, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_14",image:"assets/p1_mask_14.png",x1: 311, y1: 117, x2: 520, y2: 263, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_15",image:"assets/p1_mask_15.png",x1: 397, y1: 114, x2: 559, y2: 216, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_16",image:"assets/p1_mask_16.png",x1: 531, y1: 114, x2: 640, y2: 263, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_17",image:"assets/p1_mask_17.png",x1: 0, y1: 129, x2: 126, y2: 388, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_18",image:"assets/p1_mask_18.png",x1: 125, y1: 189, x2: 188, y2: 300, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_19",image:"assets/p1_mask_19.png",x1: 126, y1: 205, x2: 260, y2: 422, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_20",image:"assets/p1_mask_20.png",x1: 255, y1: 243, x2: 464, y2: 345, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_21",image:"assets/p1_mask_21.png",x1: 436, y1: 134, x2: 531, y2: 310, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_22",image:"assets/p1_mask_22.png",x1: 519, y1: 134, x2: 590, y2: 306, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_23",image:"assets/p1_mask_23.png",x1: 20, y1: 239, x2: 126, y2: 452, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_24",image:"assets/p1_mask_24.png",x1: 44, y1: 299, x2: 244, y2: 451, hScaleFactor: hScaleFactor,wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_25",image:"assets/p1_mask_25.png",x1: 243, y1: 244, x2: 383, y2: 423, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_26",image:"assets/p1_mask_26.png",x1: 393, y1: 294, x2: 482, y2: 387, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_27",image:"assets/p1_mask_27.png",x1: 465, y1: 294, x2: 574, y2: 407, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_28",image:"assets/p1_mask_28.png",x1: 552, y1: 197, x2: 640, y2: 442, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_29",image:"assets/p1_mask_29.png",x1: 0, y1: 332, x2: 45, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_30",image:"assets/p1_mask_30.png",x1: 24, y1: 421, x2: 252, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_31",image:"assets/p1_mask_31.png",x1: 243, y1: 371, x2: 380, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_32",image:"assets/p1_mask_32.png",x1: 329, y1: 335, x2: 477, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_33",image:"assets/p1_mask_33.png",x1: 380, y1: 334, x2: 516, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_34",image:"assets/p1_mask_34.png",x1: 514, y1: 309, x2: 574, y2: 442, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));
    maskList.add(Mask(imageName:"mask_35",image:"assets/p1_mask_35.png",x1: 514, y1: 366, x2: 640, y2: 480, hScaleFactor: hScaleFactor, wScaleFactor: wScaleFactor,));


    for (int i = 0; i < maskList.length; i++) {
      print("Piece #${i}");
      print("Before Applying WSF ==> (x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print("Before Applying HSF ==> (x2,y2)== (${maskList[i].x2.round()},${maskList[i].y2.round()})");

      maskList[i].x1 = hSF * maskList[i].x1;
      maskList[i].y1 = wSF * maskList[i].y1;
      maskList[i].x2 = hSF * maskList[i].x2;
      maskList[i].y2 = wSF * maskList[i].y2;

      print("After Applying WSF ==> (x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print("After Applying HSF ==> (x2,y2)== (${maskList[i].x2.round()},${maskList[i].y2.round()})");
      print("===========================");
    }

    pieceList.clear();
var totalMasks=[];
    for (int i = 0; i < maskList.length; i++) {
      var height = (maskList[i].x2 - maskList[i].x1).abs();
      var width = (maskList[i].y2 - maskList[i].y1).abs();
      print("(x1,y1)== (${maskList[i].x1.round()},${maskList[i].y1.round()})");
      print("(width,height)==(${width.toStringAsFixed(2)},${height.toStringAsFixed(2)})");

      var croppedImage = copyCrop(srcImage!,
          maskList[i].y1.round(), maskList[i].x1.round(), width.round(), height.round());

      saveImage(croppedImage, "image${i + 1}.jpg");

      final byteData = await rootBundle.load(maskList[i].image);
      // image = await decodeImageFromList(await widget.image.readAsBytes());
      totalMasks.add(await decodeImageFromList(await byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)));


      String base64Image =
          base64.encode(Uint8List.fromList(imglib.encodeJpg(croppedImage)));
      Piece_Info piece = Piece_Info(
          image: base64Image,
          angle: 0,
          originalPosition: i,
          currentPosition: i);

      pieceList.add(piece);
      print("===========================");
    }
var imageList=[];
    for(int i=0;i<pieceList.length;i++){
      var bytes =base64Decode(pieceList[i].image!);
      var codec = await instantiateImageCodec(bytes);
      var frame = await codec.getNextFrame();
      frame.image;
      imageList.add(frame.image);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Custom(
              imageList:   imageList, maskList:totalMasks,
            )));


   /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NameScreen(
                  pieceList: pieceList,
                  columnCount: 4,
                  imageFile: imageFile,
                  rowCount: 9,
                )));*/
  }



  saveImage(imglib.Image image, String imageName) async {
    final fileImage = await _serviceMethods.localFile(imageName);
    fileImage.writeAsBytesSync(Uint8List.fromList(imglib.encodeJpg(image))!);
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
                  )));
    }
  }
}
