import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'Jobs.dart';
import 'map.dart';

class JobDetail extends StatefulWidget {
  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String sectionId;
  String lat;
  String lang;
  String role;
  String sectioname;
  JobDetail(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.sectionId,this.lat,this.lang,this.role,this.sectioname);

  @override
  State<StatefulWidget> createState() {
    return JobDetailState(
        this.id,
        this.image,
        this.title,
        this.descrption,
        this.price,
        this.requirements,
        this.age,
        this.status,this.sectionId,this.lat,this.lang,this.role,this.sectioname);
  }

}

class JobDetailState extends State<JobDetail> {
  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String sectionId;
  String lat;
  String lang;
  String role;
  String sectioname;

  JobDetailState(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.sectionId,this.lat,this.lang,this.role,this.sectioname);

  Set<Marker>?myMarker;
  GlobalKey<FormState>formStateUpdateJob=new GlobalKey<FormState>();

  GoogleMapController? mapController;

  bool isLoading = false;
  File ?file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  TextEditingController title1 = new TextEditingController();
  TextEditingController description1 = new TextEditingController();
  TextEditingController salary1 = new TextEditingController();
  TextEditingController requirements1 = new TextEditingController();
  TextEditingController age1 = new TextEditingController();
  String ?status1 ;
  LatLng ?startLocation;

  updateData(var id,BuildContext context) async {
    var formData = formStateUpdateJob.currentState;
    if (formData!.validate()) {

      formData.save();
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(sectionId)
        .collection("Jobs")
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.update(userspref, {
          "title": title1.text,
          "description": description1.text,
          "requirement":requirements1.text,
          "salary":salary1.text,
          "age":age1.text,
          "status":status1,
          "lat":lat,
          "lang":lang,
          if(file!=null)
          "image": url.toString(),

        });
      }
      else {
        print("no");
      }
    });
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs(sectionId, role, sectioname)));

    }}

  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });


      //  url= await refStorage.getDownloadURL();
      print(url);
    }
    else
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
    }
    else
      print("please select image");
  }

  deleteData(var id) async {
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(sectionId)
        .collection("Jobs");
    userspref.doc(id).delete();
  }

  @override
  void initState() {
    title1.text = title;
    description1.text = descrption;
    salary1.text = price;
    requirements1.text = requirements;
    age1.text = age;
    status1 =status;
   startLocation = LatLng(double.parse(lat), double.parse(lang));
    myMarker ={
    Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat), double.parse(lang)) )
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Update Job".tr()),
        centerTitle: true,
      ),
      body:SingleChildScrollView(scrollDirection: Axis.vertical,
      child:Container(

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            //set border radius more than 50% of height and width to make circle
          ),
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Form(
            key:formStateUpdateJob ,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (file == null) ?
                  InkWell(child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(image)
                        )
                    ),


                  ),
                    onTap: () {
                      showDialog(context: context, builder: (BuildContext context) {
                        return
                          AlertDialog(
                            title: Text("please select".tr()),
                            actions: [
                              InkWell(
                                child: Row(
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text("From camera".tr())
                                  ],
                                )
                                , onTap: () {
                                Navigator.pop(context);
                                uplodImages();
                              },
                              ),
                              Padding(padding: EdgeInsets.all(10),),
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
                    },)

                      :
                  InkWell(child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: FileImage(file!)
                        )

                    ),),
                      onTap: () {
                        showDialog(context: context, builder: (BuildContext context) {
                          return
                            AlertDialog(
                              title: Text("please select".tr()),
                              actions: [
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      Text("From camera".tr())
                                    ],
                                  )
                                  , onTap: () {
                                  Navigator.pop(context);
                                  uplodImages();
                                },
                                ),
                                Padding(padding: EdgeInsets.all(10),),
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
                      })
                  , Padding(padding: EdgeInsets.only(top: 10)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: title1,
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
                              color: Colors.black87,fontSize: 15)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: description1,
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
                          labelText: 'Description'.tr(),

                          labelStyle: TextStyle(
                              color: Colors.black87,fontSize: 15)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: salary1,
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
                          labelText: 'Salary'.tr(),

                          labelStyle: TextStyle(
                              color: Colors.black87,fontSize: 15)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: requirements1,
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
                      controller: age1,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Field is required.'.tr();
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.number,
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
                  Padding(padding:EdgeInsets.only(top: 20)),
                  Row(mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      //Icon(Icons.signal_wifi_statusbar_null_sharp),

                    //  Text("Status",style: TextStyle(fontWeight: FontWeight.bold),)
                    ],),

                  InkWell(
                    child: Container(
                        padding: EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height/7,child: GoogleMap(

                      zoomGesturesEnabled: true,
                      initialCameraPosition: CameraPosition(

                        target: startLocation!,
                        zoom: 14.0,
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
                    ) ,),
                    onLongPress: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap(this.id, this.image, this.title, this.descrption, this.price,
                          this.requirements, this.age, this.status,lat, lang,2,sectionId,"","","",role,"",sectioname)));

                    },
                  ),








                  Padding(padding: EdgeInsets.only(top: 30))
                  , Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (isLoading == false) ?

                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.6,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
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
                          var refStorage = FirebaseStorage.instance.ref(
                              "images/$nameImage");
                          if (file != null) {
                            await refStorage.putFile(file!);
                            url = await refStorage.getDownloadURL();
                          }
                          else {
                            url = image;
                          }
                          ;
                         // url = await refStorage.getDownloadURL();
                          await updateData(id,context);
                          setState(() {
                            isLoading = false;
                          });

                        }, child: Text("Update".tr())),
                      ) :
                      Center(child: CircularProgressIndicator()),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      (isLoading == false) ?
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2.6,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.red),
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
                          await deleteData(id);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        }, child: Text("Delete".tr())),
                      ) :
                      Center(child: CircularProgressIndicator())
                    ],
                  )

                ]) ,
          ),
        ),
      )

      )



    );
  }

}