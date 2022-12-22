import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobss/UI/SignUp.dart';
import 'package:jobss/UI/addJob.dart';
class MyMap extends StatefulWidget {
  String lat;
  String lang;
  int from;
  String sectionid;

  MyMap(this.lat, this.lang,this.from,this.sectionid);

  @override
  State<MyMap> createState() => _MyMap(this.lat, this.lang,this.from,this.sectionid);
}

class _MyMap extends State<MyMap> {
  String lat;
  String lang;
  int from;
  String sectionid;
  Set<Marker>?myMarker;
  GoogleMapController? mapController;
  _MyMap(this.lat, this.lang,this.from,this.sectionid);
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
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang)),(Route<dynamic> route) => false);
                    else
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>AddJob(sectionid, lat, lang)),(Route<dynamic> route) => false);

                    }, child: Text('OK')),
              ),
        ]),
      ),
    );
  }
}
