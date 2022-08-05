import 'package:flutter/material.dart';

class Dev extends StatefulWidget {
  const Dev({Key? key}) : super(key: key);

  @override
  _DevState createState() => _DevState();
}

class _DevState extends State<Dev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dev branch"),),
    );
  }
}
