import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fractured_photo/screens/validation.dart';


void main(){
  testWidgets("textField First Name", (WidgetTester tester)async{
    await tester.pumpWidget(  ValidationDemo());
    var textField=find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, "hello good Morning");
    var text=find.text("hello good Morning");
    expect(text, findsOneWidget);
    var button=find.text("Save");
    expect(button, findsOneWidget);
    await tester.tap(button);
   await tester.pump();
   var count=find.text("1");
   expect(count, findsOneWidget);


  });
}
