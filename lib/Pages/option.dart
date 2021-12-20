import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:himlis/Pages/civilian_form.dart';
import 'package:himlis/Pages/expert_form.dart';
import 'package:himlis/Pages/info_page.dart';

class OptionalPage extends StatefulWidget {
  const OptionalPage({ Key? key }) : super(key: key);

  @override
  _OptionalPageState createState() => _OptionalPageState();
}

class _OptionalPageState extends State<OptionalPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hindi = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: GestureDetector(
            onTap: (){
               Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, a, b) =>const InfoPage()));
            },
            child: const Text("Infomation Section"),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
                Column(
                  children: [Container(
                    height: size.height/2,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/himachal.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                  BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
                ],),
                    child: const Text("HIMLIS",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),),),
                  ),
                  Container(
                  ),
                  ],
                ), 
                IconButton(onPressed: (){
              _scaffoldKey.currentState!.openDrawer();
            }, 
            icon: const Icon(Icons.menu, color: Colors.white,)
            ), 
                Center(
                  child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
                ],
                ), 
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120,
                maxWidth: 280),
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
                        child: hindi?const Text('विशेषज्ञ'):const Text('Expert')),
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
                        child: hindi?const Text('नागरिक'):const Text('Civilian')),
                    ],),)
                    )
                  ],
                ),
                        
              )
            ),
            ),
          ],
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