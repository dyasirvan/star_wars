
import 'package:flutter/material.dart';
import 'package:star_wars/ui/sign_in.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Film',
      theme: ThemeData(
          backgroundColor: Color.fromARGB(1, 255, 190, 231)
      ),
      home: SignInPage(),
    );
  }
}
