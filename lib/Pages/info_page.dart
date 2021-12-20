import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({ Key? key }) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index){
       return Card(
         child: ListTile(
           leading: Image.asset("assets/images/himachal.jpg",
           height: 100,
           ),
           contentPadding: const EdgeInsets.all(10),
         ),
       ); 
      }),
    );
  }
}