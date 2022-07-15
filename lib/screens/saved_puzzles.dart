import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fractured_photo/main.dart';
import 'package:fractured_photo/model/piece.dart';
import 'package:fractured_photo/model/piece_info.dart';
import 'package:fractured_photo/model/puzzle_info.dart';
import 'package:fractured_photo/screens/showImage.dart';
import 'package:fractured_photo/utils/database_helper.dart';

class Saved_Puzzle extends StatefulWidget {
  const Saved_Puzzle({Key? key}) : super(key: key);

  @override
  _Saved_PuzzleState createState() => _Saved_PuzzleState();
}

class _Saved_PuzzleState extends State<Saved_Puzzle> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<PuzzleInfo> puzzleInfoList = [];
  List<Piece_Info> pieceInfoList = [];

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    // TODO: implement initState
    readPuzzlesInfo();

    super.initState();
  }

  readPuzzlesInfo() {
    databaseHelper.getPuzzleList().then((value) {
      print("value${value.length}");

      puzzleInfoList = value;
      setState(() {});

      print("puzzleInfoList${puzzleInfoList.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved puzzles"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: puzzleInfoList.length != null && puzzleInfoList.length != 0
            ? ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 10,
                ),
                itemCount: puzzleInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      List<Piece> pieceList = [];
                      pieceInfoList = await databaseHelper
                          .getPieceList(puzzleInfoList[index].puzzle_id!);
                      var pattern = puzzleInfoList[index].pattern;

                      for (int i = 0; i < pieceInfoList.length; i++) {
                        Piece piece = Piece(
                            image: pieceInfoList[i].image.toString(),
                            angle: pieceInfoList[i].rotation!,
                            original_Position:
                                pieceInfoList[i].originalPosition!,
                            current_Position:
                                pieceInfoList[i].currentPosition!);
                        pieceList.add(piece);
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ShowImage(
                                puzzleId:puzzleInfoList[index]
                                    .puzzle_id ,
                                    pieceList: pieceList,
                                    columnCount: int.parse("${pattern![2]}"),
                                    imageFile: File(
                                      puzzleInfoList[index]
                                          .file_path
                                          .toString(),
                                    ),
                                    rowCount: int.parse("${pattern![0]}"),
                                    puzzleName: puzzleInfoList[index]
                                        .puzzleName
                                        .toString(),
                                    isFromSavedPuzzle: true,
                                puzzleInfo: puzzleInfoList[index],

                                  )));
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: ListTile(
                        leading: Image.file(
                          File(
                            puzzleInfoList[index].file_path.toString(),
                          ),
                          height: 75,
                          width: 75,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          puzzleInfoList[index].puzzleName.toString(),
                        ),
                        subtitle: Text(
                          puzzleInfoList[index].dateTime.toString(),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  databaseHelper
                                      .deletePuzzle(
                                          puzzleInfoList[index].puzzle_id!)
                                      .then((value) {
                                    print("value1$value");
                                    databaseHelper
                                        .deletePiece(
                                            puzzleInfoList[index].puzzle_id!)
                                        .then((value) {
                                      print("value2$value");
                                      showAlertDialogForDbOperations(context,
                                          "Puzzle deleted Successfully");
                                    }).catchError((onError) {
                                      showAlertDialogForDbOperations(
                                          context, onError.toString());
                                    });
                                  }).catchError((onError) {
                                    showAlertDialogForDbOperations(
                                        context, onError.toString());
                                  });
                                },
                                icon: Icon(Icons.delete_outline_rounded)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                "No Saved puzzles to load",
                style: TextStyle(fontSize: 24),
              )),
      ),
    );
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
                Navigator.of(context).pop();
                readPuzzlesInfo();
              },
              color: Colors.green,
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }
}
