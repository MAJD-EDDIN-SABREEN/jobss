import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyApplication extends StatefulWidget {

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  var userPref=FirebaseFirestore.instance.collection("Application");
String ?id;
String ?title;
  String ?des;
  getid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   id = await prefs.getString('id');
   setState(() {

   });





  }
  getJobData(String sectionId,String jobId) async {
    try{
      print(jobId);
      print(sectionId);

      var userPref = FirebaseFirestore.instance.collection("Section").doc(sectionId).collection("Jobs");
      var query = await userPref.doc(jobId).get();
      Map<String, dynamic> data=query.data()as Map<String, dynamic>;

      title =data["title"];
      des =data["description"];
      print(title);
      //image = query.docs[0]["image"];
       //jobdata=await query.data();
      setState(() {

      });
     // print(jobdata);
    }
    catch(e){

      print(e);
    }
  }

    @override
  void initState() {

   getid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
print (id);
    return
      Scaffold(
        appBar: AppBar(
          title: Text("My Application".tr()),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body:
        StreamBuilder<dynamic>(
            stream:userPref.where("userid",isEqualTo: id).snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr".tr());
              }
              if (snapshots.hasData){
                return ListView.builder(
                  itemCount: snapshots.data.docs!.length,
                  itemBuilder: (context,i)
                  {

                    return
                      InkWell(
                        child: Container(
                          height: MediaQuery.of(context).size.height/3,
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
Column(crossAxisAlignment: CrossAxisAlignment.center,
    children:  [
      Padding(
        padding: EdgeInsets.only(top: 10,right: 10,left: 10),
        child:

        Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              Text("job  :".tr(),style: TextStyle(fontWeight: FontWeight.bold),),
              Text(
                  "${snapshots.data.docs[i].data()["jobName"]}")
            ]),

      ),
  Padding(
    padding: EdgeInsets.only(top: 10,right: 10,left: 10),
    child:

    Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [

            Text("Expected salary :".tr(),style: TextStyle(fontWeight: FontWeight.bold),),
            Text(
                "${snapshots.data.docs[i].data()["expected salary"]}")
          ]),

  ),
  Padding(
    padding: EdgeInsets.all(5),
    child:  Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text("Notes :".tr(),style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "${snapshots.data.docs[i].data()["notes"]}")
          ]),

  ),
  Padding(
    padding: EdgeInsets.all(5),
    child:  Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text("Start At :".tr(),style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "${snapshots.data.docs[i].data()["Start_at"]}")
          ]),

  ),
  Padding(
    padding: EdgeInsets.all(5),
    child:  Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text("Created At :".tr(),style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                "${snapshots.data.docs[i].data()["created_at"]}")
          ]),
    ),

  Padding(
    padding: EdgeInsets.all(5),
    child:  Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text("Status :".tr(),style: TextStyle(fontWeight: FontWeight.bold)),
              if ((snapshots.data.docs[i]
                  .data()["status"])
                  .toString() ==
                  "0")
                Text("Wating")
              else if ((snapshots.data.docs[i]
                  .data()["status"])
                  .toString() ==
                  "1")
                Text("Acceptable".tr())
              else if ((snapshots.data.docs[i]
                    .data()["status"])
                    .toString() ==
                    "2")
                  Text("UnAcceptable".tr()),
            ]),
  ),






]),
                        ),
                    ),
                        onTap: (){
                          getJobData("${snapshots.data.docs[i].data()["sectionid"]}", "${snapshots.data.docs[i].data()["jobid"]}");

                          showDialog(context: context, builder: (
                  BuildContext context) {
                  return
                  AlertDialog(
                    title: Text(title!),
                    content:Text(des!) ,
                    // actions: [
                    //   Card(
                    //     child:Column(
                    //       children: [
                    //         Text(des!),
                    //         Text(""),
                    //
                    //       ],
                    //     ),
                    //   )
                    // ],
                  );});
                        }
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

      );

  }
}
