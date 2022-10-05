import 'dart:math';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/option.dart';
import 'package:himlis/Pages/submission.dart';
import 'package:splashscreen/splashscreen.dart';

class SecondLoading extends StatefulWidget {
  const SecondLoading({ Key? key}) : super(key: key);

  @override
  _SecondLoadingState createState() => _SecondLoadingState();
}

class _SecondLoadingState extends State<SecondLoading> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: const Submission(),
      title: const Text("Sending Your data..."),
      backgroundColor: Colors.white,
      loaderColor: Colors.black,
    );
  }
}