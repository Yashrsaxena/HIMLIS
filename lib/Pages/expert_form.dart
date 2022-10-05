import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:himlis/Pages/second_loading.dart';
import 'package:himlis/Pages/submission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';

class ExpertFormPage extends StatefulWidget {
  bool status;
  ExpertFormPage({ Key? key, required this.status}) : super(key: key);

  @override
  _ExpertFormPageState createState() => _ExpertFormPageState();
}

class _ExpertFormPageState extends State<ExpertFormPage> {
  int p=0;
  bool _pending = false;
  var location = Location();
  LocationData? _currentLocation;
  String currentLocation ="Location";
  String _responseBody = '<empty>';
  String _error = '<none>';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  late TextEditingController _infrastructure = TextEditingController();
  late TextEditingController _population = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController estimatedTime = TextEditingController();
  TextEditingController bypass = TextEditingController();
  late TextEditingController photo = TextEditingController();
  late TextEditingController video = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  ImagePicker imagePicker = ImagePicker();
  String? _setTime, _setDate;

  File? _image;
  List<XFile>? _images;
  bool isMultiple = false;

  String? _hour, _minute, _time;

  String latitude = "";
  String longitude = "";

  String? dateTime;

//Image Access
Future getImage(ImageSource source, {isCamera = false, isVideo = false}) async {
    final dynamic image;
    final XFile i;
    final List<XFile>? images;
    if(isCamera)
      {image = await imagePicker.pickImage(source: source);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        _image = imagePermanent;
      // _image = File(image!.path);
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

  //Image Saving Permanently
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

//Location Access
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
      });
  }
  String? dropCategory;
  String? dropVolume;
  String? dropTrigger;
  String? dropEventType;
  String? dropEventStatus;
  String? dropRoad;
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
                      child: Center(child: Text(currentLocation,style: const TextStyle(fontSize: 20),),),
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
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
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
              Visibility(child: textForm('Describe the Triggering factor', description),
              visible:dropTrigger=="Others"),
              const Text('Type of Event'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                  hint: const Text("Type of Event"),
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
              ),),
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
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
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
              const Text("Category"),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                  hint: const Text("Category"),
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
              ),),
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
              textForm('Infrastructure Effected', _infrastructure),
              const Text('Road Infrastructure Effected'),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Road Infrastructure Effected"),
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
                ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
      ),
      borderRadius: BorderRadius.circular(50)),
              ),
              Visibility(child: textForm('Estimated Clear Time', estimatedTime),
              visible: dropRoad=="Road Partially Closed",),
              Visibility(child: textForm('By Pass Route', bypass),
              visible: dropRoad=="Road Closed",),
              textForm('Population Effected', _population),
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
              ElevatedButton(onPressed: _pending?null:(){
                 _httpPost(_currentLocation!.latitude.toString(), _currentLocation!.longitude.toString(), dropVolume, [selectedDate.day,'-',selectedDate.month,'-',selectedDate.year].join(), [selectedTime.hour.toString(),':',selectedTime.minute].join(), dropTrigger, dropEventStatus, dropEventType, description.text, dropCategory, _infrastructure.text, dropRoad, estimatedTime.text, _population.text, bypass.text, File(_image!.path));
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
  Widget textForm(String _hint, TextEditingController _controller){
    return Column(
      children: <Widget>[
        Text(_hint),
        Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _controller,
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

Future _httpPost(String latitude, String longitude, String? volume, String _date, String _time, String? triggerFactor, String? statusOfEvent, String? typeOfEvent, String description, String? category, String infrastructureEffected, String? roadInfrastructureEffected, String estimatedClearTime, String populationEffected, String byPassRoute, File image) async {
  setState(()=>_pending = true);
  try{
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("https://lehrish.herokuapp.com/experts");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length, filename: basename(image.path));
    request.files.add(multipartFile);
      request.fields['latitude']=latitude;
      request.fields['longitude']=longitude;
      request.fields['Date']=_date;
      request.fields['Time']=_time;
      request.fields['volume']=volume==null?"volume not selected":volume;
      request.fields['triggering_factor']=triggerFactor==null?"triggerFactor not selected":triggerFactor;
      request.fields['status_of_event']=statusOfEvent==null?"statusOfEvent not selected":statusOfEvent;
      request.fields['type_of_event']=typeOfEvent==null?"typeOfEvent not selected":typeOfEvent;
      request.fields['description']=description;
      request.fields['category']=category==null?"category not selected":category;
      request.fields['infrastructure_effected']=infrastructureEffected;
      request.fields['road_infrastructure_effected']=roadInfrastructureEffected==null?"roadInfrastructureEffected not selected":roadInfrastructureEffected;
      request.fields['estimated_clear_time']=estimatedClearTime;
      request.fields['population_effected']=populationEffected;
      request.fields['by_pass_route']=byPassRoute;
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
        print('Status not OK ${response.statusCode}');
      });
    }
  }
  catch(e){
    print('failed ${e}');
    setState(() {
      _error = 'Failed';
    });
  }
  setState(() {
    _pending = false;
  });
}
}