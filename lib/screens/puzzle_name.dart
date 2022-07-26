import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/screens/showImage.dart';

class NameScreen extends StatefulWidget {
  List<Piece_Info> pieceList;
  File? imageFile;
  int columnCount;
  int rowCount;

  NameScreen(
      {Key? key,
      required this.imageFile,
        required this.rowCount,
      required this.pieceList,
      required this.columnCount})
      : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: "EnterName"),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if(nameController.text.isEmpty){
                          showSnackBar("Please enter puzzle name");
                        }else{
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowImage(
                                    pieceList:widget. pieceList,
                                    columnCount: widget.columnCount,
                                    imageFile: widget.imageFile,
                                    puzzleName: nameController.text,
                                    rowCount:  widget.rowCount,
                                    isFromSavedPuzzle: false,
                                  )));
                        }

                      },
                      child:const Text(
                        "START",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  showSnackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message!,style: const TextStyle(fontSize: 20),),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
