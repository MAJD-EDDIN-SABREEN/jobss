import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jobss/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/EditInfo.dart';
import 'package:jobss/UI/Myapplication.dart';

import 'CustomColors.dart';
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
  bool isloading = true;

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
      isloading = false;
    });
    print("hi");
  }

  changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var theme = await prefs.getBool('theme');
    if (theme == false) {
      await prefs.setBool("theme", true);
    } else {
      await prefs.setBool("theme", false);
    }
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDetail();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting".tr()),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: (isloading == false)
          ? (role == "manger")
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  image != null
                                      ? Center(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        NetworkImage(image!)),
                                              )),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      "images/job.jpg")),
                                            ),
                                          ),
                                        ),

                                  Padding(padding: EdgeInsets.only(top: 10)),

                                  Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child: Text(
                                            "${name!}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                          Card(
                                              margin: EdgeInsets.all(5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                //set border radius more than 50% of height and width to make circle
                                              ),
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${role!}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8),
                                                ),
                                              ))
                                        ]),
                                  ),
                                  // Center(child: Text("        ${name!}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                                  // Padding(padding: EdgeInsets.only(top: 10)),
                                  // Center(child: Text("        ${role!}",style: TextStyle(color: Colors.white),)),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                  Center(
                                      child: Text(
                                    "${email!}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditInfo(role)));
                                  },
                                  child: Text("Edit info".tr())),
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
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                          child: Text(
                                            "Language".tr(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Select language".tr()),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Card(
                                                    margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                    "Arabic"
                                                                        .tr(),style: TextStyle(fontSize: 20),),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale(
                                                                          'ar',
                                                                          'SA'));
                                                                },
                                                              ),
                                                            ),
                                                            Card(
                                                              margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                    "english"
                                                                        .tr(),style: TextStyle(fontSize: 20)),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale('en',
                                                                          'US'));
                                                                  setState(() {});
                                                                },
                                                              ),
                                                            ),
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
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Text(
                                                                    "Cancel"
                                                                        .tr()))
                                                          ]),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          })),
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
                            ),  Padding(
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
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                          child: Text(
                                            "Language".tr(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Select language".tr()),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Card(
                                                              margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                  "Arabic"
                                                                      .tr(),style: TextStyle(fontSize: 20),),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale(
                                                                          'ar',
                                                                          'SA'));
                                                                },
                                                              ),
                                                            ),
                                                            Card(
                                                              margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                    "english"
                                                                        .tr(),style: TextStyle(fontSize: 20)),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale('en',
                                                                          'US'));
                                                                  setState(() {});
                                                                },
                                                              ),
                                                            ),
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
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                          () {});
                                                                },
                                                                child: Text(
                                                                    "Cancel"
                                                                        .tr()))
                                                          ]),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          })),
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
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  image != null
                                      ? Center(
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image:
                                                        NetworkImage(image!)),
                                              )),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      "images/job.jpg")),
                                            ),
                                          ),
                                        ),

                                  const Padding( padding:  EdgeInsets.only(top: 10)),

                                  Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                              child:  Text(
                                            "${name!}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                          Card(
                                              margin: const EdgeInsets.all(5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                //set border radius more than 50% of height and width to make circle
                                              ),
                                              elevation: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  role!,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8),
                                                ),
                                              ))
                                        ]),
                                  ),
                                  // Center(child: Text("        ${name!}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                                  // Padding(padding: EdgeInsets.only(top: 10)),
                                  // Center(child: Text("        ${role!}",style: TextStyle(color: Colors.white),)),
                                  const Padding(padding: EdgeInsets.only(top: 10)),
                                  Center(
                                      child: Text(
                                    email!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                ],
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditInfo(role)));
                                  },
                                  child: Text("Edit info".tr())),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Row(children: [
                                  const Padding(padding: EdgeInsets.only(right: 5)),
                                  const Icon(
                                    Icons.padding,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  const Padding(padding: EdgeInsets.only(right: 30)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                        child: Text(
                                          "My applied".tr(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyApplication()));
                                        },
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Row(children: [
                                  const Icon(
                                    Icons.skateboarding,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  const Padding(padding: EdgeInsets.only(right: 36)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                          child: Text(
                                            "Skills".tr(),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Skills()));
                                          })),
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
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                          child: Text(
                                            "Language".tr(),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Select language".tr()),
                                                  actions: [
                                                    Center(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Card(
                                                              margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                  "Arabic"
                                                                      .tr(),style: TextStyle(fontSize: 20),),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale(
                                                                          'ar',
                                                                          'SA'));
                                                                },
                                                              ),
                                                            ),
                                                            Card(
                                                              margin: EdgeInsets.all(10),
                                                              child: InkWell(
                                                                child: Text(
                                                                    "english"
                                                                        .tr(),style: TextStyle(fontSize: 20)),
                                                                onTap: () {
                                                                  context.setLocale(
                                                                      Locale('en',
                                                                          'US'));
                                                                  setState(() {});
                                                                },
                                                              ),
                                                            ),
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
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                          () {});
                                                                },
                                                                child: Text(
                                                                    "Cancel"
                                                                        .tr()))
                                                          ]),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          })),
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
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Row(children: [
                                  const Icon(
                                    Icons.theaters_rounded,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  const Padding(padding: EdgeInsets.only(right: 36)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.8,
                                      child: InkWell(
                                          child: Text(
                                            "Theme".tr(),
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          onTap: () {
                                            MyApp().notifier.value =  ThemeMode.dark;
                                          })),
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
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
