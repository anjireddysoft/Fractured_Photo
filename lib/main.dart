import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fractured_photo/pic_cutter.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Container(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.greenAccent,
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: Text("PICK FROM GALLERY"),
                ),
                Container(
                  height: 40.0,
                ),
                RaisedButton(
                  color: Colors.lightGreenAccent,
                  onPressed: () {
                    _getFromCamera();
                  },
                  child: Text("PICK FROM CAMERA"),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PicShow(ImageFile: imageFile!)));
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,

    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PicShow(ImageFile: imageFile!)));
      });
    }
  }
}