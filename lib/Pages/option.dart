import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/civilian_form.dart';
import 'package:himlis/Pages/expert_form.dart';

class OptionalPage extends StatefulWidget {
  const OptionalPage({ Key? key }) : super(key: key);

  @override
  _OptionalPageState createState() => _OptionalPageState();
}

class _OptionalPageState extends State<OptionalPage> {
  bool hindi = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title:
              const Text(
              'HIMLIS', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(onPressed: (){
                 Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, a, b) => ExpertFormPage(status: hindi)));
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/professional.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
                color: Colors.white,),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 20,
                  child: hindi?Text('विशेषज्ञ'):Text('Expert')),
              ],),),
              ),
              const SizedBox(width: 7),
              ElevatedButton(onPressed: (){
                Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, a, b) =>CivilianFormPage(status: hindi)));
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/businessman.png',
                height: 50,
                width: 50,
                fit: BoxFit.contain,
                color: Colors.white,),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: 20,
                  child: hindi?Text('नागरिक'):Text('Civilian')),
              ],),)
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(onPressed: (){
            setState(() {
              hindi = !hindi;
            });
          },
          child: Icon(Icons.translate, color: hindi?Colors.white:Colors.black,),
          elevation: 2,
          backgroundColor: hindi?Colors.black:Colors.white,
          ),
      ),
    );
  }
}