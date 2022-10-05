import 'dart:math';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/option.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

class Loading extends StatefulWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    var r = Random();
    return SplashScreen(
      seconds: r.nextInt(2)+2,
      navigateAfterSeconds: const OptionalPage(),
      title: const Text("Fetching your location..."),
      backgroundColor: Colors.white,
      loaderColor: Colors.black,
    );
  }
}