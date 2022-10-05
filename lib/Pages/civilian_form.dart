import 'dart:convert';
import 'dart:io';
// import 'package:himlis/Components/dropdown_menu.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/second_loading.dart';
import 'package:http/http.dart' as http;

class CivilianFormPage extends StatefulWidget {
  bool status;
  CivilianFormPage({ Key? key, required this.status}) : super(key: key);

  @override
  _CivilianFormPageState createState() => _CivilianFormPageState();
}

class _CivilianFormPageState extends State<CivilianFormPage> {
  bool _pending = false;
  var location = Location();
  LocationData? _currentLocation;
  String currentLocation ="Location";
  String _responseBody = '<empty>';
  String _error = '<none>';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _setTime, _setDate;
  File? _image;
  List<XFile>? _images;
  double? latitude;
  double? longitude;
  bool isMultiple = false;

  String? _hour, _minute, _time;

  ImagePicker imagePicker = ImagePicker();
  String? dateTime;

  Future getImage(ImageSource source, {isCamera = false, isVideo = false}) async {
    final dynamic image;
    final XFile i;
    final List<XFile>? images;
    if(isCamera)
      {image = await imagePicker.pickImage(source: source);
      setState(() {
      _image = File(image!.path);
    });
    }
    else if(isVideo)
      {image = await imagePicker.pickVideo(source: ImageSource.camera);}
    else{
      images = await imagePicker.pickMultiImage();
      setState(() {
      _images = images;
    });
    }
    
  }

  Future<void> _getLocation()async{
    var _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled)
      {
        return;
      }
    }
    var _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    _currentLocation = await location.getLocation();
    setState(() {
      currentLocation = _currentLocation!.latitude.toString() + " " + _currentLocation!.longitude.toString();
      print(_currentLocation!.accuracy.toString());
    });
  }
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
      _dateController.text = [selectedDate.day.toString(),'/',selectedDate.month,'/',selectedDate.year].toString();
    });
}

Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        if(selectedTime.minute.toString().length==1)
        {
          _minute='0'+selectedTime.minute.toString();
          }
        else
        {
          _minute=selectedTime.minute.toString();
          }
      });
    }
  }
  String? dropLevel;
  String? dropVolume;
  String? dropTrigger;
  String? dropEventStatus;
  int p=0;
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
                const Text('Location'),
              GestureDetector(
                    onTap: (){
                      _getLocation();
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
                      child: Center(child: Text(currentLocation,style: TextStyle(fontSize: 20),),),
                    ),
                  ),
              const Text("Date and Time"),
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
                      child: Center(child: Text([selectedDate.day,'-',selectedDate.month,'-',selectedDate.year].join(), style: const TextStyle(fontSize: 20),),),
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
                      child: Center(child: Text([selectedTime.hour.toString(),':',selectedTime.minute.toString().length==1?'0'+selectedTime.minute.toString():selectedTime.minute.toString()].join(), style: const TextStyle(fontSize: 20),),)
                    )
                  ),)
                ],
              ),
              //textForm('Date and Time'),
              const Text('Estimated Landslide Volume'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Estimated Landslide Volume"),
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
                ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              // DropdownMenu(hint: "Volume", items: const ["Small: Less than 10 metric cube",
              //   "Medium :10-1000 metric cube",
              //   "Large: 1000-100,000 metric cube",
              //   "Very large: 100,000-1,000,000 metric cube",
              //   "Catastrophic: Greater than 1,000,000 metric cube"]),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Triggering Factor"),
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
              const Text("Hazard Level"),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Hazard Level"),
                  items: ["Low", "Medium", "High"].map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue){
                    setState(() {
                      dropLevel = newValue!;
                    });
                  },
                  value: dropLevel,
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
              ),
              const Text("Status of Event"),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Status of Event"),
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
                  'Photos', style: TextStyle(fontSize: 25),
                ),
              Column(children: [
                _image!=null?Image.file(_image!):const Text("No Image Selected"),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ElevatedButton(onPressed: (){
                  getImage(ImageSource.camera, isCamera: true);
                              },
                              style: ElevatedButton.styleFrom(primary: Colors.black), 
                              child: const Icon(Icons.camera)),
                              ElevatedButton(onPressed: (){
                                getImage(ImageSource.gallery, isCamera: true);
                                setState(() {
                                  isMultiple = true;
                                });
                              }, 
                              style: ElevatedButton.styleFrom(primary: Colors.black),
                              child: const Icon(Icons.collections)),
                  ],),
                ),]),
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
              ElevatedButton(onPressed: 
                _pending?null:(){
                  _httpPost(_currentLocation!.latitude.toString(), _currentLocation!.longitude.toString(), dropVolume, [selectedDate.day,'-',selectedDate.month,'-',selectedDate.year].join(), [selectedTime.hour.toString(),':',selectedTime.minute].join(), dropTrigger, dropLevel, dropEventStatus, File(_image!.path));
                 Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, a, b) => const SecondLoading()));
                },
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
  Future<void> _httpPost(String latitude, String longitude, String? volume, String _date, String _time, String? triggerFactor, String? hazardLevel, String? statusOfEvent, File image) async {
  setState(()=>_pending = true);
  try{
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("https://lehrish.herokuapp.com/civilians");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length, filename: basename(image.path));
    request.files.add(multipartFile);
      request.fields['latitude']=latitude;
      request.fields['longitude']=longitude;
      request.fields['Date']=_date;
      request.fields['Time']=_time;
      request.fields['volume']=volume==null?"volume not selected":volume;
      request.fields['triggering_factor']=triggerFactor==null?"triggerFactor not selected":triggerFactor;
      request.fields['hazard_level'] = hazardLevel==null?"hazardLevel not selected":hazardLevel;
      request.fields['status_of_event']=statusOfEvent==null?"statusOfEvent not selected":statusOfEvent;
      var response = await request.send();
    if(response.statusCode == 200){
      setState(() {
        // _responseBody = response.body;
        print('Status OK');
      });
    }
    else{
      setState(() {
        _error = 'Failed';
        print('Status not OK');
      });
    }
  }
  catch(e){
    setState(() {
      _error = 'Failed';
    });
  }
  setState(() {
    _pending = false;
  });
}
}