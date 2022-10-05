import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  String? hint;
  List<String> items = [];
  DropdownMenu({ Key? key, required hint, required items}) : super(key: key);

  @override
  DropdownMenuState createState() => DropdownMenuState();
}

class DropdownMenuState extends State<DropdownMenu> {
  @override
  Widget build(BuildContext context) {
    String? dropValue;
    return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(widget.hint!),
                  items: widget.items.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      dropValue = newValue!;
                    });
                  },
                  value: dropValue,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(20),
                              ),
                ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              );
  }
}