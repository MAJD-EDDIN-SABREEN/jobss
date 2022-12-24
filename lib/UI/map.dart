import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobss/UI/SignUp.dart';
import 'package:jobss/UI/addJob.dart';
import 'package:jobss/UI/jobDetail.dart';
class MyMap extends StatefulWidget {

  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String lat;
  String lang;
  int from;
  String sectionid;
  String email;
  String password;
  String gender;
  String role;
  String name;

  MyMap(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.lat, this.lang,this.from,this.sectionid,this.email,this.password,this.gender,this.role,this.name);

  @override
  State<MyMap> createState() => _MyMap(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.lat, this.lang,this.from,this.sectionid,this.email,this.password,this.gender,this.role,this.name);
}

class _MyMap extends State<MyMap> {
  String id;
  String image;
  String title;
  String descrption;
  String price;
  String requirements;
  String age;
  String status;
  String lat;
  String lang;
  int from;
  String sectionid;
  String email;
  String password;
  String gender;
  String role;
  String name;

  Set<Marker>?myMarker;
  GoogleMapController? mapController;
  _MyMap(this.id, this.image, this.title, this.descrption, this.price,
      this.requirements, this.age, this.status,this.lat, this.lang,this.from,this.sectionid,this.email,this.password,this.gender,this.role,this.name);
@override
  void initState() {
  myMarker={
    Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat), double.parse(lang)) )
  };
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
          child: Column(

            children: [

          Container(
            padding: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height/1.2,
            child: GoogleMap(

              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: true, //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: LatLng(double.parse(lat), double.parse(lang)), //initial position
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
          ),
              Container(

                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height/10,
                width: MediaQuery.of(context).size.width/1.5,
                child:   ElevatedButton(
                    style:ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18.0), // radius you want
                              side: BorderSide(
                                color: Colors.transparent, //color
                              ),
                            ))),
                    onPressed: (){
                      if(from==0)
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang,this.email,this.password,this.gender,this.role,name)),(Route<dynamic> route) => false);
                    else if(from==1)
                         Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>AddJob(sectionid, lat, lang,title,descrption,price,requirements,age,status)),(Route<dynamic> route) => false);
                       else
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>JobDetail(this.id, this.image, this.title, this.descrption, this.price,
                            this.requirements, this.age, this.status,sectionid, lat, lang)),(Route<dynamic> route) => false);


                    }, child: Text('OK'.tr())),
              ),
        ]),
      ),
    );
  }
}
