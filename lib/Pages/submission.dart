/// Flutter code sample for ScaleTransition

// The following code implements the [ScaleTransition] as seen in the video
// above:
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/option.dart';

/// This is the stateful widget that the main application instantiates.
class Submission extends StatefulWidget {
  const Submission({Key? key}) : super(key: key);

  @override
  State<Submission> createState() => _SubmissionState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _SubmissionState extends State<Submission>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(period: const Duration(seconds: 2));
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceOut,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/images/tick.png"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
          onPressed: (){
            Share.share(
              "Test");
          },
          style: ElevatedButton.styleFrom(primary: Colors.black),
          child: const Text("Share"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(primary: Colors.white),
          child: const Text("Home", style: TextStyle(color: Colors.black),),
        ),
          ],
        ),
          ]
        ),
      ),
    );
  }
}
