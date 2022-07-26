

import 'package:flutter/material.dart';

import 'package:fractured_photo/screens/blend_mode.dart';
import 'dart:ui' as ui;

class Custom extends StatefulWidget {
  final List<dynamic> maskList;
 final  List<dynamic> imageList;

 const Custom({Key? key, required this.imageList, required this.maskList})
      : super(key: key);

  @override
  _CustomState createState() => _CustomState();
}

class _CustomState extends State<Custom> {
  ui.Image? image, mask;
  List<CustomPainter> list = [];

  convert() async {
    for (int i = 0; i < widget.imageList.length; i++) {
      list.add(BlendPainter(widget.imageList[i], widget.maskList[i]));
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    convert();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("App bar"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                elevation: 5,
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                           const  SizedBox(
                              width: 5,
                            ),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomPaint(
                            painter: list[index],
                            child: const SizedBox(
                              height: 100,
                              width: 100,
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
