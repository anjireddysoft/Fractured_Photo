import 'package:flutter/material.dart';
import 'package:fractured_photo/screens/picture_mode.dart';

class PuzzleType extends StatefulWidget {
  const PuzzleType({Key? key}) : super(key: key);

  @override
  _PuzzleTypeState createState() => _PuzzleTypeState();
}

class _PuzzleTypeState extends State<PuzzleType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puzzle Type"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                              builder: (context) => PictureMode(
                                    isSquarePuzzle: true,
                                  )));
                    },
                    child: const Text("Square Puzzle"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
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
                                  PictureMode(isSquarePuzzle: false,)));
                    },
                    child: const Text("Shattered Puzzle"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Get from Camera

}
