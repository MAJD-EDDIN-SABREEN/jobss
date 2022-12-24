import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'CustomColors.dart';

class EditInfo extends StatefulWidget {
  String role;

  EditInfo(this.role);

  @override
  State<EditInfo> createState() => _EditInfoState(this.role);
}

class _EditInfoState extends State<EditInfo> {
  List<Widget> skills = [];
  String role;

  _EditInfoState(this.role);

  String Id = "";
  String userId = "";
  TextEditingController skill = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController expactedSal = new TextEditingController();
  TextEditingController workPos = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  List SkillsString = [];
  Set<Marker>?myMarker;
  GoogleMapController? mapController;
  String ?lat;
  String ?lang;
  LatLng ?startLocation;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = (await prefs.getString('id'))!;
    print(Id);
    setState(() {});
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("id", isEqualTo: Id).get();
    setState(() {
      name.text = query.docs[0]["name"];
       workPos.text = query.docs[0]["workPostion"];
       expactedSal.text = query.docs[0]["expactedsalary"];
      // print("${query.docs[0]["skills"][1]}");
       SkillsString=query.docs[0]["skills"];
      // lat =query.docs[0]["lat"];
      // lang =query.docs[0]["lang"];

      phone.text=(query.docs[0]["phone"]).toString();
    });
    setState(() {
      startLocation = LatLng(double.parse(lat!), double.parse(lang!));
      myMarker ={
        Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat!), double.parse(lang!)) )
      };
    });
  }
  getvv()async{
    await getUserData();
  }

  getUserid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Id = (await prefs.getString('id'))!;
    setState(() {});
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("id", isEqualTo: Id).get();
    setState(() {
      userId = query.docs[0].id;

    });
  }

  onAddSkills(String skill) {
    setState(() {
      skills.add(InkWell(
        child: Flexible(
            child: Card(
          child: Text(skill),
        )),
        onTap: () {},
      ));
      SkillsString.add(skill);
      print(skills);
    });
  }

  updateData() async {
    await getUserid();
    var userspref = FirebaseFirestore.instance.collection("Users").doc(userId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "name": name.text,
              "workPostion": workPos.text,
              "expactedsalary": expactedSal.text,
              "skills": SkillsString,
              "phone": phone.text
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      getvv();
    });

  }

  @override
  Widget build(BuildContext context) {

    // startLocation = LatLng(double.parse(lat!), double.parse(lang!));
    // myMarker ={
    //   Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat!), double.parse(lang!)) )
    // };
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Card(
          margin: EdgeInsets.all(20),
                    elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            //set border radius more than 50% of height and width to make circle
          ),
          child:
          (role=="manger")?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.width / 4,
                  )),
                ),
              ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        fillColor: Colors.white,
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),

                        labelText: 'name'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,  fontSize: 10)),
                  ),
                ),




              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    controller: phone,
                    textCapitalization: TextCapitalization.words,
                    decoration:  InputDecoration(
                        fillColor: Colors.white,
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        labelText: 'Phone'.tr(),
                        labelStyle: TextStyle(
                            color: Colors.black87,  fontSize: 10)),
                  ),
              ),





              Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.3,
                  child: ElevatedButton(
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
                        updateData();
                        Navigator.pop(context);
                      },
                      child: Text("Update".tr())),
                ),
              )
            ],
          ):
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.width / 4,
                      )),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: name,
                  textCapitalization: TextCapitalization.words,
                  decoration:  InputDecoration(
                      fillColor: Colors.white,
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),

                      labelText: 'name'.tr(),
                      labelStyle: TextStyle(
                          color: Colors.black87,  fontSize: 10)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: workPos,
                  textCapitalization: TextCapitalization.words,
                  decoration:  InputDecoration(
                      fillColor: Colors.white,
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'work position'.tr(),
                      labelStyle: TextStyle(
                          color: Colors.black87,  fontSize: 10)),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: phone,
                  textCapitalization: TextCapitalization.words,
                  decoration:  InputDecoration(
                      fillColor: Colors.white,
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Phone'.tr(),
                      labelStyle: TextStyle(
                          color: Colors.black87,  fontSize: 10)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: expactedSal,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                      fillColor: Colors.white,
                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      labelText: 'Expected salary'.tr(),
                      labelStyle: TextStyle(
                          color: Colors.black87, fontSize: 10)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: skill,
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration:  InputDecoration(
                              fillColor: Colors.white,
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              labelText: 'Skills'.tr(),
                              labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10)),
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            onAddSkills(skill.text);
                            print(skills);
                          });
                        },
                        icon: Icon(Icons.add))
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              (skills.isNotEmpty)
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: skills!,
              ),
                  )
                  :
              Center(child: Text(""),),

              Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/1.3,
                  child: ElevatedButton(
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
                        updateData();
                        Navigator.pop(context);
                      },
                      child: Text("Update".tr())),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
