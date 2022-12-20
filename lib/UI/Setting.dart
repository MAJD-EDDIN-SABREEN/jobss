import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/EditInfo.dart';
import 'package:jobss/UI/Myapplication.dart';

import 'Skills.dart';

class Setting extends StatefulWidget {
  String role;

  Setting(this.role);

  @override
  State<Setting> createState() => _SettingState(this.role);
}

class _SettingState extends State<Setting> {
  String? email;
  String? image;
  String? name;
  String role;
  bool isloding=true;

  _SettingState(this.role);

  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = await prefs.getString('email');
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("email", isEqualTo: email).get();
    //image = query.docs[0]["image"];
    name = query.docs[0]["name"];

    setState(() {});

  }

  getDetail() async {
    await getEmail();

    setState(() {
      isloding=false;
    });
    print("hi");

  }
  changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = await prefs.getBool('theme');
    if (theme == false)
      await prefs.setBool("theme", true);
    else
      await prefs.setBool("theme", false);
    setState(() {

    });

  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      getDetail();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Setting"),
      centerTitle: true,
      backgroundColor: Colors.black,),
      body:(isloding==false)?
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
          Container(
            width:MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black,

                      height: MediaQuery.of(context).size.height/3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image != null
                              ? Center(
                            child: Container(
                                height: MediaQuery.of(context).size.height / 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill, image: NetworkImage(image!)),
                                )),
                          )
                              :
                          Container(
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Container(

//height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                //borderRadius: BorderRadius.circular(100)
                                //  ,
                                image: DecorationImage(

                                    fit: BoxFit.fill, image:AssetImage("images/job.jpg")),

                              ),
                              // child: Icon(
                              //   color: Colors.white,
                              //   Icons.person,
                              //   size: MediaQuery.of(context).size.width / 4,
                              // ),
                            ),


                          ),


                          Padding(padding: EdgeInsets.only(top: 10)),

                          Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Center(child: Text("${name!}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),




                                  Card(
                                      margin: EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        //set border radius more than 50% of height and width to make circle
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("${role!}",style: TextStyle(color: Colors.black,fontSize: 8),),
                                      ))
                                ]),
                          ),
                          // Center(child: Text("        ${name!}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                          // Padding(padding: EdgeInsets.only(top: 10)),
                          // Center(child: Text("        ${role!}",style: TextStyle(color: Colors.white),)),
                          Padding(padding: EdgeInsets.only(top: 10))
                          ,Center(child: Text("${email!}",style: TextStyle(color: Colors.white,fontSize: 10),)),


                        ],
                      ),
                    ),

                Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.black ,
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => EditInfo()));
                                },
                                child: Text("Edit info")),
                          ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Padding(padding: EdgeInsets.only(right: 5)),
                          Icon(
                            Icons.padding,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                child: Text(
                                  "My applied"
                                  ,style: TextStyle(fontSize: 20),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => MyApplication()));
                                } ,
                              )
                            // ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor:Colors.black ,
                            //     ),
                            //     onPressed: () {
                            //       Navigator.push(context,
                            //           MaterialPageRoute(builder: (context) => MyApplication()));
                            //     }, child: Text("Section")),
                          ),
                        ]),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.skateboarding,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 36)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                  child: Text(
                                    "Skills"
                                    ,style: TextStyle(fontSize: 20),
                                  ),
                                  onTap:  () { Navigator.push(context,
             MaterialPageRoute(builder: (context) => Skills()));}
                              )),
                          // Padding(padding: EdgeInsets.only(right: 20)),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width / 1.8,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor:Colors.black ,
                          //       ),
                          //       onPressed: () { Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting()));}, child: Text("Setting")),
                          // ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.language,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 36)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                  child: Text(
                                    "Language"
                                    ,style: TextStyle(fontSize: 20),
                                  ),
                                  onTap:  () async{
                                    //signOut();
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // prefs.remove('email');
                                    // prefs.remove('id');
                                    // prefs.remove('theme');
                                  }
                              )),
                          // Padding(padding: EdgeInsets.only(right: 20)),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width / 1.8,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor:Colors.black ,
                          //       ),
                          //       onPressed: () async {
                          //         signOut();
                          //         SharedPreferences prefs = await SharedPreferences.getInstance();
                          //         prefs.remove('email');
                          //         prefs.remove('id');
                          //         prefs.remove('theme');
                          //       },
                          //       child: Text("Logout")),
                          // ),
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.tab_unselected_sharp,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 36)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                  child: Text(
                                    "Theme"
                                    ,style: TextStyle(fontSize: 20),
                                  ),
                                  onTap:  () async{
                                    //signOut();
                                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                                    // prefs.remove('email');
                                    // prefs.remove('id');
                                    // prefs.remove('theme');
                                  }
                              )),
                          // Padding(padding: EdgeInsets.only(right: 20)),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width / 1.8,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor:Colors.black ,
                          //       ),
                          //       onPressed: () async {
                          //         signOut();
                          //         SharedPreferences prefs = await SharedPreferences.getInstance();
                          //         prefs.remove('email');
                          //         prefs.remove('id');
                          //         prefs.remove('theme');
                          //       },
                          //       child: Text("Logout")),
                          // ),
                        ]),
                      ),
                    ),
                  ],
                )),
          ),
          // Container(
          //   height: MediaQuery.of(context).size.height/1.2,
          //   //padding: EdgeInsets.all(10),
          //   child:
          //   Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(50),
          //       //set border radius more than 50% of height and width to make circle
          //     ),
          //     elevation: 10,
          //     margin: EdgeInsets.all(15),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             image != null
          //                 ? Container(
          //                     height: MediaQuery.of(context).size.height / 6,
          //                     decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                       image: DecorationImage(
          //                           fit: BoxFit.fill, image: NetworkImage(image!)),
          //                     ))
          //                 : Container(
          //                     height: MediaQuery.of(context).size.height / 6,
          //                     width: MediaQuery.of(context).size.width / 6,
          //                     decoration: BoxDecoration(
          //                       shape: BoxShape.circle,
          //                     ),
          //                     child: Center(
          //                         child: Icon(
          //                       Icons.person,
          //                       size: MediaQuery.of(context).size.width / 4,
          //                     )),
          //                   ),
          //             Text(email!)
          //           ],
          //         ),
          //         Center(
          //           child: ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor:Colors.black ,
          //               ),
          //               onPressed: () {
          //                 Navigator.push(context,
          //                     MaterialPageRoute(builder: (context) => EditInfo()));
          //               },
          //               child: Text("Edit info")),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height / 10,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //           ),
          //           child: Row(children: [
          //             Icon(
          //               Icons.app_registration_outlined,
          //               color: Colors.black,
          //               size: 30,
          //             ),
          //             Padding(padding: EdgeInsets.only(right: 20)),
          //             SizedBox(
          //               width: MediaQuery.of(context).size.width / 1.5,
          //               child: ElevatedButton(
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor:Colors.black ,
          //                   ),
          //                   onPressed: () {
          //                     Navigator.push(context,
          //                         MaterialPageRoute(builder: (context) => MyApplication()));
          //                   }, child: Text("My applied")),
          //             ),
          //           ]),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height / 10,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //           ),
          //           child: Row(children: [
          //             Icon(
          //               Icons.skateboarding,
          //               color: Colors.black,
          //               size: 30,
          //             ),
          //             Padding(padding: EdgeInsets.only(right: 20)),
          //             SizedBox(
          //               width: MediaQuery.of(context).size.width / 1.5,
          //               child:
          //                   ElevatedButton
          //                     (
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor:Colors.black ,
          //                       ),
          //                       onPressed: () { Navigator.push(context,
          //                       MaterialPageRoute(builder: (context) => Skills()));}, child: Text("Skills")),
          //             ),
          //           ]),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height / 10,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //           ),
          //           child: Row(children: [
          //             Icon(
          //               Icons.language,
          //               color: Colors.black,
          //               size: 30,
          //             ),
          //             Padding(padding: EdgeInsets.only(right: 20)),
          //             SizedBox(
          //               width: MediaQuery.of(context).size.width / 1.5,
          //               child: ElevatedButton(
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor:Colors.black ,
          //                   ),
          //                   onPressed: () {}, child: Text("Language")),
          //             ),
          //           ]),
          //         ),
          //         Container(
          //
          //           height: MediaQuery.of(context).size.height / 10,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //           ),
          //           child: Row(children: [
          //             Icon(
          //               Icons.tab_sharp,
          //               color: Colors.black,
          //               size: 30,
          //             ),
          //             Padding(padding: EdgeInsets.only(right: 20)),
          //             SizedBox(
          //               width: MediaQuery.of(context).size.width / 1.5,
          //               child: ElevatedButton(
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor:Colors.black ,
          //                   ),
          //                   onPressed: () {
          //                     changeTheme();
          //                   },
          //                   child: Text("Theme")),
          //             ),
          //           ]),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
    ):
      Center(child: CircularProgressIndicator()),
    );
  }
}
