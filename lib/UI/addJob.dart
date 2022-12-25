import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobss/UI/Jobs.dart';
import 'package:jobss/UI/map.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'CustomColors.dart';

class AddJob extends StatefulWidget {
  String sectionId;
  String role;
  String sectionName;
  String lat;
  String lang;
  String titlee;
  String descrptuonn;
  String requirementss;
  String pricee;
  String agee;
  String statuss;
  AddJob(this.sectionId,this.lat,this.lang,this.titlee,this.descrptuonn,this.pricee,this.requirementss,this.agee,this.statuss,this.role,this.sectionName);

  @override
  State<StatefulWidget> createState() {
    return AddJobState(this.sectionId,this.lat,this.lang,this.titlee,this.descrptuonn,this.pricee,this.requirementss,this.agee,this.statuss,this.role,this.sectionName);
  }
}

class AddJobState extends State<AddJob> {
  String sectionId;
  bool isLoading = false;
  File? file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  String lat;
  String lang;
  String role;
  String sectionName;
  String titlee;
  String descrptuonn;
  String requirementss;
  String pricee;
  String agee;
  String statuss;
  String? id;
  TextEditingController title = new TextEditingController();
  TextEditingController descrptuon = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController requirements = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController status = new TextEditingController();
  GlobalKey<FormState>formStateAddJob=new GlobalKey<FormState>();
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng ?startLocation ;
  String location = "Search Location";

  AddJobState(this.sectionId,this.lat, this.lang,this.titlee,this.descrptuonn,this.pricee,this.requirementss,this.agee,this.statuss,this.role,this.sectionName);
  Set<Marker>?myMarker;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? gmc;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.044420, 31.235712),
    zoom: 14.4746,
  );

  addJob() async {
    var formData = formStateAddJob.currentState;
    if (formData!.validate()) {
      formData.save();
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      id= await prefs.getString('id');
      setState(() {

      });
try{
  var userspref = FirebaseFirestore.instance
      .collection("Section")
      .doc(sectionId)
      .collection("Jobs");
  userspref.add({
    "title": title.text,
    "description": descrptuon.text,
    "salary": price.text,
    "requirement": requirements.text,
    "age": age.text,
    "status": status.text,
    "lat": lat,
    "lang": lang,
    "created_at": date.toString(),
    "mid":id,
    if(file!=null)
      "image": url.toString(),

  });

}catch(e){
  print(e);
}

    }

  }

  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });

      //  url= await refStorage.getDownloadURL();
      print(url);
    } else
      print("please select image");
  }

  uplodImagesFromGallery() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });

      var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
      await refStorage.putFile(file!);

      url = await refStorage.getDownloadURL();
      //  url= await refStorage.getDownloadURL();
      print(url);
    } else
      print("please select image");
  }
  @override
  void initState() {
    startLocation = LatLng(double.parse(lat),double.parse(lang));
    myMarker={
      Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat),double.parse(lang)) )
    };
    title.text=titlee;
    descrptuon.text=descrptuonn;
    price.text=pricee;
    requirements.text=requirementss;
    age.text=agee;
    status.text=statuss;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Job".tr()),
        centerTitle: true,
      ),
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
      Container(
       // height: MediaQuery.of(context).size.height/1.1,
        //padding: EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            //set border radius more than 50% of height and width to make circle
          ),
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Form(
            key: formStateAddJob,
            child:  Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (file == null)
                    ? Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey
                  ),
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("please select".tr()),
                                actions: [
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Icon(Icons.camera_alt),
                                        Text("From camera".tr())
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      uplodImages();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Icon(Icons.image),
                                        Text("From gallery".tr())
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      uplodImagesFromGallery();
                                    },
                                  )
                                  //onTap: uplodImages(),
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.image)),
                )
                    : InkWell(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: FileImage(file!))),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("please select".tr()),
                              actions: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("From camera".tr())
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    uplodImages();
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.image),
                                      Text("From gallery".tr())
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    uplodImagesFromGallery();
                                  },
                                )
                                //onTap: uplodImages(),
                              ],
                            );
                          });
                    }),
                Padding(padding: EdgeInsets.only(top: 10)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Title'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descrptuon,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.';
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Descrption'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: price,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    keyboardType:TextInputType.number ,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'salary'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: requirements,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'requirement'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: age,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    keyboardType:TextInputType.number ,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'age'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: status,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    keyboardType:TextInputType.number ,
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                       fillColor: Colors.white,
                       // icon: Icon(Icons.safety_divider),
                        labelText: 'status'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,fontSize: 15)),
                  ),
                ),
                InkWell(
                  child:
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height / 7,
                    child: Stack(children: [
                      GoogleMap(
                        //Map widget from google_maps_flutter package
                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                        initialCameraPosition: CameraPosition(
                          //innital position in map
                          target: startLocation!, //initial position
                          zoom: 14.0, //initial zoom level
                        )
                        ,
                        markers: myMarker!,
                        mapType: MapType.normal,
                        onTap: (latlang){
                          setState(() {
                            myMarker!.remove(Marker(markerId: MarkerId("1")));
                            myMarker!.add( Marker(markerId: MarkerId("1"),position:latlang ));
                            lat=latlang.latitude.toString();
                            lang=latlang.longitude.toString();
                          });
                          print(latlang.latitude);

                        },//map type
                        onMapCreated: (controller) {
                          //method called when map is created
                          setState(() {
                            mapController = controller;
                          });
                        },
                      ),


                    ]),
                  ),
                  onLongPress: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap("", "", title.text, descrptuon.text, price.text,
                        requirements.text, age.text, status.text,lat, lang,1,sectionId,"","","",this.role,"",this.sectionName)));

                  },
                ),

                //   child:  GoogleMap(
                //     mapType: MapType.normal,
                //     initialCameraPosition: _kGooglePlex,
                //     onMapCreated: (GoogleMapController controller) {
                //      gmc=controller;
                //     },
                //   ),
                // ),
//Spacer(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.3,
                  height: MediaQuery.of(context).size.height/20,

                  child:(  isLoading == false)?
                  ElevatedButton(
                      style:ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(CustomColors.button),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(18.0), // radius you want
                                side: BorderSide(
                                  color: Colors.transparent, //color
                                ),
                              ))),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });


                        if(file!=null){
                          var refStorage =
                          FirebaseStorage.instance.ref("images/$nameImage");
                          await refStorage.putFile(file!);
                          url = await refStorage.getDownloadURL();
                        }


                        setState(() {

                        });
                        addJob();
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs(sectionId, role, sectionName)));

                        setState(() {
                          isLoading = false;
                        });

                      },
                      child: Text("add".tr())):Center(child: CircularProgressIndicator(),),
                ),
                Padding(padding: EdgeInsets.only(top: 10))
              ]),),
        ),
      )

    ));
  }
}
//AIzaSyBkwuMI2uJF1sAkzVQphO-UjaJt3ZxRuRU
