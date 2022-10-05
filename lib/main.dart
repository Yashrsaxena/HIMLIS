import 'package:flutter/material.dart';
import 'package:himlis/Pages/loading.dart';
import 'package:himlis/Pages/option.dart';

void main(){

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const Loading(),
    );
  }
}

