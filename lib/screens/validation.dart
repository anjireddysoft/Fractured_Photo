import 'package:flutter/material.dart';

class ValidationDemo extends StatefulWidget {
  const ValidationDemo({Key? key}) : super(key: key);

  @override
  State<ValidationDemo> createState() => _ValidationDemoState();
}

class _ValidationDemoState extends State<ValidationDemo> {
  TextEditingController countController = TextEditingController();
int?  count=0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Widget Testing"),
        ),
        body: Container(
          child: Column(
            children: [
              count!=null?Text(count.toString()):Text("Count was null"),
              TextField(
                controller: countController,
                key: Key("FirstName"),
                maxLines: 5,
                minLines: 2,
                decoration: const InputDecoration(

                    border: InputBorder.none, hintText: "First Name"),
              ),
              RaisedButton(
                onPressed: () {
                 increment();
                },
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
  increment(){
    setState(() {
      count=count!+1;
    });
  }
}
