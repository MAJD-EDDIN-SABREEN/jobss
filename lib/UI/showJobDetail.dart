import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ShowJob extends StatefulWidget {
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

  ShowJob(
      this.id,
      this.image,
      this.title,
      this.descrption,
      this.price,
      this.requirements,
      this.age,
      this.status,
      this.sectionId,
      this.lat,
      this.lang);

  @override
  State<ShowJob> createState() => _ShowJobState(this.id,
      this.image,
      this.title,
      this.descrption,
      this.price,
      this.requirements,
      this.age,
      this.status,
      this.sectionId,
      this.lat,
      this.lang);
}

class _ShowJobState extends State<ShowJob> {
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

  _ShowJobState(
      this.id,
      this.image,
      this.title,
      this.descrption,
      this.price,
      this.requirements,
      this.age,
      this.status,
      this.sectionId,
      this.lat,
      this.lang);
  List Userid=[];
  var userPref=FirebaseFirestore.instance.collection("Application");
  LatLng ?startLocation;
  Set<Marker>?myMarker;
String ?uid;
  GoogleMapController? mapController;
  getid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = await prefs.getString('id');
    setState(() {

    });
  }
  getUserId() async {
    try {


      var userPref = FirebaseFirestore.instance.collection("Application");
      var query = await userPref.where("jobid", isEqualTo: id).get();
      for (int i = 0; i < query.docs.length; i++) {
        Userid.add(query.docs[i]["userid"]) ;
        setState(() {

        });
      }
    }
    catch(e){
      print(e);
    }
  }
    void initState() {

      getid();
      startLocation = LatLng(double.parse(lat), double.parse(lang));
      myMarker ={
        Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat), double.parse(lang)) )
      };
      super.initState();
    }
 Future<Map<String, dynamic>> getuserData() async {
   var query = await userPref.doc(uid).get();
   Map<String, dynamic> data=query.data()as Map<String, dynamic>;
   return data;

    }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:
      ListView(
        scrollDirection: Axis.vertical,          children: [
          Container(
            height: MediaQuery.of(context).size.height/6,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(

                  fit: BoxFit.fill, image:NetworkImage(image))
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: Card(
            elevation: 3,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              //set border radius more than 50% of height and width to make circle
            ),
            child:
            Container(decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
                child:
                InkWell(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        //height: MediaQuery.of(context).size.height/25
                        //,
                          width: MediaQuery.of(context).size.width
                          ,child:
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8)),
                          Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/14)),

                          Text(price,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16),)
                          ,Text("  SAR",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16),),
                        ],
                      )),
                    ),
                    // Container(
                    //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),
                    //
                    //   child: Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"
                    //
                    //     ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                    // ),


                    Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),child: Text(descrption,style: TextStyle(color: Colors.black45,fontWeight: FontWeight.normal),)),







                    InkWell(
                      child: Container(
                        padding:EdgeInsets.only( top:10,left: 40,right:40 ),

                        height: MediaQuery.of(context).size.height/3,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          //Map widget from google_maps_flutter package
                          zoomGesturesEnabled: true, //enable Zoom in, out on map
                          initialCameraPosition: CameraPosition(
                            //innital position in map
                            target: LatLng(double.parse(lat), double.parse(lang)), //initial position
                            zoom: 14.0,
                            //initial zoom level
                          )
                          ,
                          markers:<Marker>{
                            Marker(markerId: MarkerId("1"),position: LatLng(double.parse(lat), double.parse(lang),), //initial position
                                infoWindow: InfoWindow(
                                    title: title
                                )
                            ),

                          }

                          ,
                          mapType: MapType.normal,
                          onMapCreated: (controller) {
                            //method called when map is created
                            setState(() {
                              mapController = controller;
                            });
                          },

                        ) ,),
                    ),



                  ],),

                ))),
          ),
          // Card(child: Column(
          //   children: [
          //     Center(
          //     child:Text(title)
          //     ),
          //     Center(
          //         child:Text(descrption)
          //     ),
          //     Center(
          //         child:Text(price+" SAR")
          //     ),
          //     Container(
          //       padding: EdgeInsets.only(top: 10),
          //       height: MediaQuery.of(context).size.height/7,child: GoogleMap(
          //
          //       zoomGesturesEnabled: true,
          //       initialCameraPosition: CameraPosition(
          //
          //         target: startLocation!,
          //         zoom: 14.0,
          //       )
          //       ,
          //       markers: myMarker!,
          //       mapType: MapType.normal,
          //       onTap: (latlang){
          //         setState(() {
          //           myMarker!.remove(Marker(markerId: MarkerId("1")));
          //           myMarker!.add( Marker(markerId: MarkerId("1"),position:latlang ));
          //           lat=latlang.latitude.toString();
          //           lang=latlang.longitude.toString();
          //         });
          //         print(latlang.latitude);
          //
          //       },//map type
          //       onMapCreated: (controller) {
          //         //method called when map is created
          //         setState(() {
          //           mapController = controller;
          //         });
          //       },
          //     ) ,),
          //
          //
          //   ],
          // )),

          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.2,
            child: StreamBuilder<dynamic>(
              stream:userPref.where("userid",isEqualTo: uid).where("jobid",isEqualTo:id).snapshots(),
              builder:(context,snapshots){

                if(snapshots.hasError){
                  return Text("erorr".tr());
                }
                if (snapshots.hasData){
                  return
                    ListView.builder(
                    itemCount: snapshots.data.docs!.length,
                    itemBuilder: (context,i)
                    {

                      return
                        InkWell(
                            child: Container(
                              height: MediaQuery.of(context).size.height/7,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  //set border radius more than 50% of height and width to make circle
                                ),
                                margin: EdgeInsets.all(30),
                                elevation: 10,
                                // color: Colors.blue,
                                child:

                                Column(mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                         Padding(
                                           padding: const EdgeInsets.only(top: 5),
                                           child: Container(

                                              width: MediaQuery.of(context).size.width/6,
                                              height: MediaQuery.of(context).size.height/20,
                                              decoration: BoxDecoration(

                                                shape: BoxShape.circle,

                                                  ) ,
                                           child: Icon(Icons.person),),
                                         ),

                                        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [ Text("${snapshots.data.docs[i].data()["name"]}",style: TextStyle(fontSize: 15),),
                                          Text("${snapshots.data.docs[i].data()["email"]}",style: TextStyle(fontSize: 10,color: Colors.black45),),
                                            Text("${snapshots.data.docs[i].data()["notes"]}",style: TextStyle(fontSize: 10,color: Colors.black45),),

                                          ],),
                                      ],)









                                    ]),
                              ),
                            ),

                          //     (){
                          //   getJobData("${snapshots.data.docs[i].data()["sectionid"]}", "${snapshots.data.docs[i].data()["jobid"]}");
                          // },
                        );

                      //   ListTile(
                      //   leading: Icon(Icons.settings_applications_outlined),
                      //  subtitle:Text("${snapshots.data.docs[i].data()["expected salary"]}"),
                      //   title:Text("${snapshots.data.docs[i].data()["notes"]}") ,
                      //   onTap:  (){
                      //   },
                      // );
                    }
                    ,

                  );
                }
                return Center(child: CircularProgressIndicator(),);
              }
        ),
          ),
      ]),

    );
  }
}
