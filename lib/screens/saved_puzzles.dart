import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
      setState(() {

      });

      print("puzzleInfoList${puzzleInfoList.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved puzzles"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  List<Piece> pieceList = [];
                  pieceInfoList = await databaseHelper
                      .getPieceList(puzzleInfoList[index].puzzle_id!);
                  var pattern = puzzleInfoList[index].pattern;

                  print("pieceInfoList${pieceInfoList[0].image}");
                  for (int i = 0; i < pieceInfoList.length; i++) {
                    Piece piece = Piece(
                        image: pieceInfoList[i].image.toString(),
                        angle: pieceInfoList[i].rotation!,
                        original_Position: pieceInfoList[i].originalPosition!,
                        current_Position: pieceInfoList[i].currentPosition!);
                    pieceList.add(piece);
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ShowImage(
                              pieceList: pieceList,
                              columnCount: int.parse("${pattern![2]}"),
                              imageFile: File(puzzleInfoList[index].file_path.toString(),),
                              rowCount: int.parse("${pattern![0]}"),
                              puzzleName: puzzleInfoList[index].puzzleName.toString(),
                          isFromSavedPuzzle: true,
                          ))

                  );
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.file(
                          File(
                            puzzleInfoList[index].file_path.toString(),
                          ),
                          height: 75,
                          width: 75,
                        ),
                        Expanded(
                            child: Text(
                                puzzleInfoList[index].dateTime.toString(),
                                style: TextStyle(fontSize: 20))),
                        Expanded(
                            child: Text(
                          puzzleInfoList[index].puzzleName.toString(),
                          style: TextStyle(fontSize: 20),
                        )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete_outline_rounded))
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 10,
                ),
            itemCount: puzzleInfoList.length),
      ),
    );
  }
}
