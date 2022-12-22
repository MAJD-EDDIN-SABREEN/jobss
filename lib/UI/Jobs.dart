import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobss/UI/showJobDetail.dart';
import 'package:searchfield/searchfield.dart';
import 'package:jobss/UI/Sections.dart';
import 'package:jobss/UI/addJob.dart';
import 'package:jobss/UI/application.dart';
import 'package:jobss/UI/jobDetail.dart';
import 'package:jobss/UI/showApplcaton.dart';

import '../main.dart';

class Jobs extends StatefulWidget{
  String sectionId;
  String sectionName;
  String role;
  Jobs(this.sectionId , this.role,this.sectionName);

  @override
  State<StatefulWidget> createState() {
return JobsState(this.sectionId,this.role,this.sectionName);
  }

}
class JobsState extends State<Jobs>{
  String sectionId;
  String role;
  String sectionName;
  TextEditingController _searchController = TextEditingController();
  List documents = [];
  String searchText = '';
  bool search = false;
  String ?title;
  GoogleMapController? mapController;
  JobsState(this.sectionId,this.role,this.sectionName);
  String ?appnum;
  Future<String?> getUserData(String id) async {

    var userPref = FirebaseFirestore.instance.collection("Application");
    var query = await userPref.where("jobid", isEqualTo: id).get();
 appnum= await query.docs.length.toString();
setState(() {
//print(appnum);
});

return appnum;
  }
  addApllicatonNumber(var id) async {
    var appnum1=await getUserData(id);
    var userspref = FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs").doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "appnum": appnum1,
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }
  getAppnum(){

  }
  @override
  void initState() {
    documents=[];
    super.initState();
    print(sectionName);
  }
   @override
  Widget build(BuildContext context) {
    CollectionReference jobRef =FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs");
   return
     (role=="manger")?
     Scaffold(
     appBar: AppBar(

       title: Text(sectionName),
      backgroundColor: CustomColors.appBar,
       centerTitle: true,
       elevation: 10,
//        actions: [
//          Icon(Icons.search),
//          Container(
//           // color: Colors.white,
//            padding: EdgeInsets.all(1),
//          height: MediaQuery.of(context).size.height,
//          width: MediaQuery.of(context).size.width/1.2 ,
//          child:
//          SearchField(
// onSuggestionTap: (e){
//   print(e.searchKey);
//   setState(() {
//     search=true;
//     title=e.searchKey;
// documents=[];
//
//   });
//
// },
//            autoCorrect: true,
//
//            suggestions: documents!.map(
//                  (e) => SearchFieldListItem(
//                e["title"],
//                item: e,
//              ),
//            )
//                .toList(),
//
//
//
//
//
//
//          ),
//        )
//        ],
     ),
     body:



     (search==true)?
           StreamBuilder<dynamic>(
               stream:jobRef.where("title",isEqualTo: title).snapshots(),
               builder:(context,snapshots){
                 print(search);
                 if(snapshots.hasError){
                   return Text("erorr");
                 }
                 if (snapshots.hasData){

                   return
                     ListView.builder(
                       scrollDirection: Axis.vertical,
                       itemCount: snapshots.data.docs!.length,
                       itemBuilder: (context,i)
                       {
                         documents.add(snapshots.data.docs[i].data());
                         addApllicatonNumber(snapshots.data.docs[i].id);
                         return Card(
                             elevation: 3,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(80),
                               //set border radius more than 50% of height and width to make circle
                             ),

                             child:
                             Container(decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(100),
                         ),
                         child:
                         InkWell(child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [

                             SizedBox(height: MediaQuery.of(context).size.height/15
                                 ,
                                 width: MediaQuery.of(context).size.width
                                 ,child:
                                 Row(
                                   //mainAxisAlignment: MainAxisAlignment.spaceAround,

                                   children: [
                                     Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8)),
                                     Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                     Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/14)),

                                     Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16),)
                                     ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16),),
                                   ],
                                 )),


                             Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),child: Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),)),



                             Container(
                               padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),

                               child: Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                                 ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                             ),

                             Container(padding:EdgeInsets.only( top:10,bottom: 10,left: 40,right:40 ),
                               height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                                 //Map widget from google_maps_flutter package
                                 zoomGesturesEnabled: true, //enable Zoom in, out on map
                                 initialCameraPosition: CameraPosition(
                                   //innital position in map
                                   target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                   zoom: 14.0,
                                   //initial zoom level
                                 )
                                 ,
                                 markers:<Marker>{
                                   Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
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



                           ],),
                           onTap:  (){
                             showDialog(context: context, builder: (
                                 BuildContext context) {
                               return
                                 AlertDialog(
                                   elevation: 50,
                                   backgroundColor: Colors.white,
                                   icon:   Icon(Icons.select_all),
                                   title: Text("please select"),
                                   actions: [
                                     InkWell(
                                       child: Row(
                                         children: [
                                           Icon(Icons.update),
                                           Padding(padding: EdgeInsets.only(left: 10)),
                                           Text("Update job")
                                         ],
                                       )
                                       , onTap: () {
                                       Navigator.push(context,MaterialPageRoute(builder: (context)=>JobDetail(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}","${snapshots.data.docs[i].data()["requirement"]}","${snapshots.data.docs[i].data()["age"]}","${snapshots.data.docs[i].data()["status"]}",sectionId,"${snapshots.data.docs[i].data()["lat"]}","${snapshots.data.docs[i].data()["lang"]}")));
                                     },
                                     ),
                                     Padding(padding: EdgeInsets.all(10),),
                                     InkWell(
                                       child: Row(
                                         children: [
                                           Icon(Icons.padding_rounded),
                                           Padding(padding: EdgeInsets.only(left: 10)),
                                           Text("show applications")
                                         ],
                                       )
                                       , onTap: () {
                                       Navigator.push(context,MaterialPageRoute(builder: (context)=>ShowApplicaton(sectionId, snapshots.data.docs[i].id,"${snapshots.data.docs[i].data()["title"]}")));
                                     },
                                     ),

                                     //onTap: uplodImages(),

                                   ],
                                 );
                             });},
                         )));
                       }
                       ,

                     );
                 }
                 return Center(child: CircularProgressIndicator(),);
               }
           )

         :
     StreamBuilder<dynamic>(
         stream:jobRef.snapshots(),
         builder:(context,snapshots){

           if(snapshots.hasError){
             return Text("erorr");
           }
           if (snapshots.hasData){

             return
               ListView.builder(
               scrollDirection: Axis.vertical,
               itemCount: snapshots.data.docs!.length,
               itemBuilder: (context,i)
               {

                // documents.add(snapshots.data.docs[i].data());
                //addApllicatonNumber(snapshots.data.docs[i].id);
                 return
                   Container(
                     //width: MediaQuery.of(context).size.width/8,
                     padding: EdgeInsets.all(5),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Card(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                           //set border radius more than 50% of height and width to make circle
                         ),

                     margin: EdgeInsets.all(10),
                     elevation: 20,

                     //color: Colors.,


                     child:
                     InkWell(child:
                     Padding(
                       padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                         SizedBox(
                             //height: MediaQuery.of(context).size.height/30
                             //,
                             width: MediaQuery.of(context).size.width
                             ,child:
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.center,

                           children: [
                             Padding(padding: EdgeInsets.only(top: 5)),
                             Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,overflow:TextOverflow.ellipsis ,fontWeight: FontWeight.bold,fontSize: 18),),
                             //Padding(padding: EdgeInsets.only(left: 120)),


Spacer(),
                                 Container(
                               // width: MediaQuery.of(context).size.width,
                                     alignment: Alignment.topRight,
                                     child: Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16,overflow:TextOverflow.fade),)),




                                 Text(" SAR",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16,overflow:TextOverflow.fade),),
                           ],
                         )),
                           Container(
                               //padding: EdgeInsets.only(top: 10,left: MediaQuery.of(context).size.width/8)

                               child: Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.normal),)),

                           // Container(
                           //  // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
                           //
                           //   child: Text("applied ("+"${snapshots.data.docs[i].data()["appnum"]}"+")"
                           //
                           //     ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                           // ),









                           InkWell(
                             child: Container(
                               padding:EdgeInsets.only( top:10,bottom: 10
                                   ,left: 5,right:5
                               ),

                               height: MediaQuery.of(context).size.height/6,
                              // width: MediaQuery.of(context).size.width,
                               child: GoogleMap(
                               //Map widget from google_maps_flutter package
                               zoomGesturesEnabled: true, //enable Zoom in, out on map
                               initialCameraPosition: CameraPosition(
                                 //innital position in map
                                 target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                 zoom: 14.0,
                                 //initial zoom level
                               )
                               ,
                               markers:<Marker>{
                             Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}"),), //initial position
                             infoWindow: InfoWindow(
                               title: "${snapshots.data.docs[i].data()["title"]}"
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
                     ),
                       onTap:  (){
                         showDialog(context: context, builder: (
                             BuildContext context) {
                           return
                             AlertDialog(
                               elevation: 50,
                               backgroundColor: Colors.white,
                               icon:   Icon(Icons.select_all),
                               title: Text("please select"),
                               actions: [
                                 InkWell(
                                   child: Row(

                                     children: [
                                       Icon(Icons.update),
                                       Padding(padding: EdgeInsets.only(left: 10)),
                                       Text("Update job")
                                     ],
                                   )
                                   , onTap: () {
                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>JobDetail(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}","${snapshots.data.docs[i].data()["requirement"]}","${snapshots.data.docs[i].data()["age"]}","${snapshots.data.docs[i].data()["status"]}",sectionId,"${snapshots.data.docs[i].data()["lat"]}","${snapshots.data.docs[i].data()["lang"]}")));
                                 },
                                 ),
                                 Padding(padding: EdgeInsets.all(10),),
                                 InkWell(
                                   child: Row(
                                     children: [
                                       Icon(Icons.padding_rounded),
                                       Padding(padding: EdgeInsets.only(left: 10)),
                                       Text("show applications")
                                     ],
                                   )
                                   , onTap: () {
                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>ShowApplicaton(sectionId, snapshots.data.docs[i].id,"${snapshots.data.docs[i].data()["title"]}")));
                                 },
                                 ),

                                 //onTap: uplodImages(),

                               ],
                             );
                         });},
                     )

                     ),
                   )
                  ;

               }
               ,

             );
           }
           return Center(child: CircularProgressIndicator(),);
         }
     ),

     floatingActionButton: FloatingActionButton(
         backgroundColor: Colors.black,
         onPressed: (){
       Navigator.push(context,MaterialPageRoute(builder: (context)=>AddJob(sectionId,"30.044420"," 31.235712")));
     },child: Icon(Icons.add)),
   ):
     Scaffold(
       appBar: AppBar(

         title: Text(sectionName),
         backgroundColor: CustomColors.appBar,
         centerTitle: true,
         elevation: 10,
       ),

       body:  (search==true)?
       StreamBuilder<dynamic>(
           stream:jobRef.where("title",isEqualTo: title).snapshots(),
           builder:(context,snapshots){
             print(search);
             if(snapshots.hasError){
               return Text("erorr");
             }
             if (snapshots.hasData){

               return
                 ListView.builder(
                   scrollDirection: Axis.vertical,
                   itemCount: snapshots.data.docs!.length,
                   itemBuilder: (context,i)
                   {
                     documents.add(snapshots.data.docs[i].data());
                     addApllicatonNumber(snapshots.data.docs[i].id);
                     return Card(
                         elevation: 3,
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

                                 SizedBox(height: MediaQuery.of(context).size.height/15
                                     ,
                                     width: MediaQuery.of(context).size.width
                                     ,child:
                                     Row(
                                       //mainAxisAlignment: MainAxisAlignment.spaceAround,

                                       children: [
                                         Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8)),
                                         Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                         Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/14)),

                                         Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16),)
                                         ,Text("SAR",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 16),),
                                       ],
                                     )),


                                 Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),child: Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),)),



                                 Container(
                                   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/8),

                                   child: Text("applied number  :   "+"${snapshots.data.docs[i].data()["appnum"]}"

                                     ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                 ),

                                 Container(padding:EdgeInsets.only( top:10,bottom: 10,left: 40,right:40 ),
                                   height: MediaQuery.of(context).size.height/4,child: GoogleMap(
                                     //Map widget from google_maps_flutter package
                                     zoomGesturesEnabled: true, //enable Zoom in, out on map
                                     initialCameraPosition: CameraPosition(
                                       //innital position in map
                                       target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                       zoom: 14.0,
                                       //initial zoom level
                                     )
                                     ,
                                     markers:<Marker>{
                                       Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
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



                               ],),
                       onTap:  (){
                         showDialog(context: context, builder: (
                             BuildContext context) {
                           return
                             AlertDialog(
                               elevation: 50,
                               backgroundColor: Colors.white,
                               icon:   Icon(Icons.select_all),
                               title: Text("please select"),
                               actions: [
                                 InkWell(
                                   child: Row(
                                     children: [
                                       Icon(Icons.update),
                                       Padding(padding: EdgeInsets.only(left: 10)),
                                       Text("Update job")
                                     ],
                                   )
                                   , onTap: () {
                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>JobDetail(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}","${snapshots.data.docs[i].data()["requirement"]}","${snapshots.data.docs[i].data()["age"]}","${snapshots.data.docs[i].data()["status"]}",sectionId,"${snapshots.data.docs[i].data()["lat"]}","${snapshots.data.docs[i].data()["lang"]}")));
                                 },
                                 ),
                                 Padding(padding: EdgeInsets.all(10),),
                                 InkWell(
                                   child: Row(
                                     children: [
                                       Icon(Icons.padding_rounded),
                                       Text("show applications")
                                     ],
                                   )
                                   , onTap: () {
                                   Navigator.push(context,MaterialPageRoute(builder: (context)=>ShowApplicaton(sectionId, snapshots.data.docs[i].id,"${snapshots.data.docs[i].data()["title"]}")));
                                 },
                                 ),

                                 //onTap: uplodImages(),

                               ],
                             );
                         });},
                     )));
                   }
                   ,

                 );
             }
             return Center(child: CircularProgressIndicator(),);
           }
       )

           :
       StreamBuilder<dynamic>(stream:jobRef.snapshots(),
           builder:(context,snapshots){

             if(snapshots.hasError){
               return Text("erorr");
             }
             if (snapshots.hasData){

               return ListView.builder(
                 itemCount: snapshots.data.docs!.length,
                 itemBuilder: (context,i)
                 {
                   // documents.add(snapshots.data.docs[i].data());
                   // addApllicatonNumber(snapshots.data.docs[i].id);
                   return
                     Container(
                       //width: MediaQuery.of(context).size.width/8,
                         padding: EdgeInsets.all(5),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Card(
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20),
                               //set border radius more than 50% of height and width to make circle
                             ),

                             margin: EdgeInsets.all(10),
                             elevation: 20,

                             //color: Colors.,


                             child:
                             InkWell(child:
                             Padding(
                               padding: const EdgeInsets.only(top: 15,left: 10,right: 10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [

                                   SizedBox(
                                     //height: MediaQuery.of(context).size.height/30
                                     //,
                                       width: MediaQuery.of(context).size.width
                                       ,child:
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.center,

                                     children: [
                                       Padding(padding: EdgeInsets.only(top: 5)),
                                       Text("${snapshots.data.docs[i].data()["title"]}",style: TextStyle(color: Colors.black,overflow:TextOverflow.ellipsis ,fontWeight: FontWeight.bold,fontSize: 18),),
                                       //Padding(padding: EdgeInsets.only(left: 120)),


                                       Spacer(),
                                       Container(
                                         // width: MediaQuery.of(context).size.width,
                                           alignment: Alignment.topRight,
                                           child: Text("${snapshots.data.docs[i].data()["salary"]}",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16,overflow:TextOverflow.fade),)),




                                       Text(" SAR",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.normal,fontSize: 16,overflow:TextOverflow.fade),),
                                     ],
                                   )),
                                   Container(
                                     //padding: EdgeInsets.only(top: 10,left: MediaQuery.of(context).size.width/8)

                                       child: Text("${snapshots.data.docs[i].data()["description"]}",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.normal),)),

                                   // Container(
                                   //  // padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10),
                                   //
                                   //   child: Text("applied ("+"${snapshots.data.docs[i].data()["appnum"]}"+")"
                                   //
                                   //     ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal),),
                                   // ),









                                   InkWell(
                                     child: Container(
                                       padding:EdgeInsets.only( top:10,bottom: 10
                                           ,left: 5,right:5
                                       ),

                                       height: MediaQuery.of(context).size.height/6,
                                       // width: MediaQuery.of(context).size.width,
                                       child: GoogleMap(
                                         //Map widget from google_maps_flutter package
                                         zoomGesturesEnabled: true, //enable Zoom in, out on map
                                         initialCameraPosition: CameraPosition(
                                           //innital position in map
                                           target: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}")), //initial position
                                           zoom: 14.0,
                                           //initial zoom level
                                         )
                                         ,
                                         markers:<Marker>{
                                           Marker(markerId: MarkerId("1"),position: LatLng(double.parse("${snapshots.data.docs[i].data()["lat"]}"), double.parse("${snapshots.data.docs[i].data()["lang"]}"),), //initial position
                                               infoWindow: InfoWindow(
                                                   title: "${snapshots.data.docs[i].data()["title"]}"
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
                             ),
                     onTap:  (){
                       showDialog(context: context, builder: (
                           BuildContext context) {
                         return
                           AlertDialog(
                             elevation: 50,
                             backgroundColor: Colors.white,
                             icon:   Icon(Icons.select_all),
                             title: Text("please select"),
                             actions: [
                               InkWell(
                                 child: Row(
                                   children: [
                                     Icon(Icons.update),
                                     Padding(padding: EdgeInsets.only(left: 10)),
                                     Text("applied for job")
                                   ],
                                 )
                                 , onTap: () {
                                 Navigator.push(context,MaterialPageRoute(builder: (context)=>Application(sectionId, snapshots.data.docs[i].id)));
                               },
                               ),

                               Padding(padding: EdgeInsets.all(10),),
                               InkWell(
                                 child: Row(
                                   children: [
                                     Icon(Icons.update),
                                     Padding(padding: EdgeInsets.only(left: 10)),
                                     Text("show job")
                                   ],
                                 )
                                 , onTap: () {
                                 Navigator.push(context,MaterialPageRoute(builder: (context)=>ShowJob(snapshots.data.docs[i].id, "${snapshots.data.docs[i].data()["image"]}", "${snapshots.data.docs[i].data()["title"]}", "${snapshots.data.docs[i].data()["description"]}", "${snapshots.data.docs[i].data()["salary"]}","${snapshots.data.docs[i].data()["requirement"]}","${snapshots.data.docs[i].data()["age"]}","${snapshots.data.docs[i].data()["status"]}",sectionId,"${snapshots.data.docs[i].data()["lat"]}","${snapshots.data.docs[i].data()["lang"]}")));
                               },
                               ),
                               //onTap: uplodImages(),

                             ],
                           );
                       });},
                   )));
                 }
                 ,

               );
             }
             return Center(child: CircularProgressIndicator(),);
           }
       ),

     );
  }

}