import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
// import 'package:geolocator/geolocator.dart';

class ExpertFormPage extends StatefulWidget {
  bool status;
  ExpertFormPage({ Key? key, required this.status}) : super(key: key);

  @override
  _ExpertFormPageState createState() => _ExpertFormPageState();
}

class _ExpertFormPageState extends State<ExpertFormPage> {
  int p=0;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String latitude = "";
  String longitude = "";

  String? dateTime;

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentLocation();
  // }

  // getCurrentLocation() async {
  //   final geoposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     latitude = geoposition.latitude.toString();
  //     print(latitude);
  //     longitude = geoposition.longitude.toString();
  //   });
  // }
  Future<Null> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101));
  if (picked != null)
    setState(() {
      selectedDate = picked;
      _dateController.text = [selectedDate.day.toString(),'-',selectedDate.month,'-',selectedDate.year].toString();
    });
}

Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        //_time = _hour + ' : ' + _minute!;
        //_timeController.text = _time!;
        // _timeController.text = formatDate(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        //     [hh, ':', nn, " ", am]).toString();
      });
  }
  String dropCategory = "Rotational";
  String dropVolume = "Small: Less than 10 metric cube";
  String dropTrigger = "Rainfall";
  String dropEventType = "New Event";
  String dropEventStatus = "Active";
  String dropRoad = "Free Transit";
  @override
  Widget build(BuildContext context) {
    if(p==0){return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: 
              const Text(
              'HIMLIS', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: 
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(child: Form(child: Column(children: <Widget>[
                const Text(
                  'Temporal and Spatial Data', style: TextStyle(fontSize: 25),
                ),
              Text('Location'),
              GestureDetector(
                    onTap: (){
                      // getCurrentLocation();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(child: Text(latitude==""?"Current Location":[latitude, " ", longitude].join(),style: TextStyle(fontSize: 20),),),
                    ),
                  ),
              Text("Date and Time"),
              Row(
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    onTap: (){
                      _selectDate(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(child: Text([selectedDate.day,'-',selectedDate.month,'-',selectedDate.year].join(), style: TextStyle(fontSize: 20),),),
                    ),
                  ),),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      _selectTime(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(child: Text([selectedTime.hour.toString(),':',selectedTime.minute].join(), style: TextStyle(fontSize: 20),),)
                    )
                  ),)
                ],
              ),
              textForm('Depth'),
              const Text('Estimated Landslide Volume'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["Small: Less than 10 metric cube",
"Medium :10-1000 metric cube",
"Large: 1000-100,000 metric cube",
"Very large: 100,000-1,000,000 metric cube",
"Catastrophic: Greater than 1,000,000 metric cube"
].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropVolume = newValue!;
                  });
                },
                value: dropVolume,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[ElevatedButton(onPressed: null,
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Previous', style: TextStyle(color: Colors.white),
              ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                setState(() {
                  p++;
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Next', style: TextStyle(color: Colors.white),
              ),
              ),
              ]),
            ],
            ),
            ),)
            ),
        ),
        floatingActionButton: FloatingActionButton.small(onPressed: (){
            setState(() {
              widget.status = !widget.status;
            });
          },
          child: Icon(Icons.translate, color: widget.status?Colors.white:Colors.black,),
          elevation: 2,
          backgroundColor: widget.status?Colors.black:Colors.white,
          ),
      ),
    );
  }
  if(p==1){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: 
              const Text(
              'HIMLIS', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: 
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(child: Form(child: Column(children: <Widget>[
                const Text(
                  'Hazard Factors', style: TextStyle(fontSize: 25),
                ),
                const Text('Triggering Factor'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["Rainfall", "Seismic Activity", "Others"].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropTrigger = newValue!;
                  });
                },
                value: dropTrigger,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
      
              ),
              Visibility(child: textForm('Describe the Triggering factor'),
              visible:dropTrigger=="Others"),
              const Text('Type of Event'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["New Event", "Reactivated Event"].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropEventType = newValue!;
                  });
                },
                value: dropEventType,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              const Text("Status of Event"),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["Active", "Reactivatable", "Naturally Stabilized", "Artificially Stabilized"].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropEventStatus = newValue!;
                  });
                },
                value: dropEventStatus,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              const Text("Category"),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["Rotational","Transitional","Block Slide","Debris Flow","Debris Avalanche", "Rock Fall", "Topple", "Earth Flow", "Creep", "Lateral Spread"].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropCategory = newValue!;
                  });
                },
                value: dropCategory,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[ElevatedButton(onPressed: (){
                  setState(() {
                    p--;
                  });
                },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Previous', style: TextStyle(color: Colors.white),
              ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                setState(() {
                  p++;
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Next', style: TextStyle(color: Colors.white),
              ),
              ),
              ]),
            ],
            ),
            ),)
            ),
        ),
        floatingActionButton: FloatingActionButton.small(onPressed: (){
            setState(() {
              widget.status = !widget.status;
            });
          },
          child: Icon(Icons.translate, color: widget.status?Colors.white:Colors.black,),
          elevation: 2,
          backgroundColor: widget.status?Colors.black:Colors.white,
          ),
      ),
    );
  }
  if(p==2){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: 
              const Text(
              'HIMLIS', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: 
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(child: Form(child: Column(children: <Widget>[
                const Text(
                  'Elements of Risk', style: TextStyle(fontSize: 25),
                ),
              textForm('Insfrastructure Effected'),
              const Text('Road Insfrastructure Effected'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                items: ["Free Transit", "Transit with Precaution", "Dangerous transit", "Road Partially Closed", "Road Closed"].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue){
                  setState(() {
                    dropRoad = newValue!;
                  });
                },
                value: dropRoad,
                isExpanded: true,
                borderRadius: BorderRadius.circular(20),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              Visibility(child: textForm('Estimated Clear Time'),
              visible: dropRoad=="Road Partially Closed",),
              Visibility(child: textForm('By Pass Route'),
              visible: dropRoad=="Road Closed",),
              textForm('Population Effected'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[ElevatedButton(onPressed: (){
                  setState(() {
                    p--;
                  });
                },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Previous', style: TextStyle(color: Colors.white),
              ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(onPressed: (){
                setState(() {
                  p++;
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Next', style: TextStyle(color: Colors.white),
              ),
              ),
              ]),
            ],
            ),
            ),)
            ),
        ),
        floatingActionButton: FloatingActionButton.small(onPressed: (){
            setState(() {
              widget.status = !widget.status;
            });
          },
          child: Icon(Icons.translate, color: widget.status?Colors.white:Colors.black,),
          elevation: 2,
          backgroundColor: widget.status?Colors.black:Colors.white,
          ),
      ),
    );
  }
  else{
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: 
              const Text(
              'HIMLIS', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: 
            Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(child: Form(child: Column(children: <Widget>[
                const Text(
                  'Photos and Videos', style: TextStyle(fontSize: 25),
                ),
              textForm('Take Photos and (or) Videos'),
              textForm('Upload Photos and (or) Videos'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[ElevatedButton(onPressed: (){
                setState(() {
                  p--;
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Previous', style: TextStyle(color: Colors.white),
              ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text('Send', style: TextStyle(color: Colors.white),
              ),
              ),
              ]),
            ],
            ),
            ),)
            ),
        ),
        floatingActionButton: FloatingActionButton.small(onPressed: (){
            setState(() {
              widget.status = !widget.status;
            });
          },
          child: Icon(Icons.translate, color: widget.status?Colors.white:Colors.black,),
          elevation: 2,
          backgroundColor: widget.status?Colors.black:Colors.white,
          ),
      ),
    );
  }
  }
  // Widget dropMenu(List <String>option){
  //   String dropCategory = 'Select';
  //   return DropdownButton<String>(
  //     value: dropCategory,
  //     icon: const Icon(Icons.arrow_circle_down),
  //     iconSize: 24,
  //     elevation: 16,
  //     style: const TextStyle(color: Colors.black),
  //     underline: Container(
  //       height: 2,
  //       color: Colors.black,
  //     ),
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         dropCategory = newValue!;
  //       });
  //     },
  //     items: option.map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }
  Widget textForm(String _hint){
    return Column(
      children: <Widget>[
        Text(_hint),
        Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _hint,
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
    )]
    );
}
}