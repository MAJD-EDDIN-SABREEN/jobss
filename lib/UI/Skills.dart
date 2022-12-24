import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Skills extends StatefulWidget {
  const Skills({Key? key}) : super(key: key);

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  var userPref=FirebaseFirestore.instance.collection("Users");
  String ?id;
  getid()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = await prefs.getString('id');
    setState(() {

    });
  }
  @override
  void initState() {

    getid();
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Skills".tr()),
          centerTitle: true,
        ),
        body:
        StreamBuilder<dynamic>(
            stream:userPref.where("id",isEqualTo: id).snapshots(),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height/4,
                        child: Card(

                        margin: EdgeInsets.all(30),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          //set border radius more than 50% of height and width to make circle
                        ),
                        child:  SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text("${snapshots.data.docs[i].data()["skills"]}",style: TextStyle(overflow: TextOverflow.ellipsis),),
                                    // ListView.builder(itemBuilder: (context,j){
                                    //   print(snapshots.data.docs[i].data()["name"]);
                                    //  // Text("${snapshots.data.docs[i].data()["skills"][j]}");
                                    // })
                                  ]),
                        ),







                    ),
                      );


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
