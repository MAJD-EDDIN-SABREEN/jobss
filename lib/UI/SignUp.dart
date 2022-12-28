
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobss/UI/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/Log_In.dart';
import '../main.dart';
import 'CustomColors.dart';
import 'Sections.dart';

class SignUp extends StatefulWidget{
  String  lat;
  String lang;
  String email;
  String password;
  String gender;
  String role;
  String name;


  SignUp(this.lat, this.lang,this.email,this.password,this.gender,this.role,this.name);

  @override
  State<StatefulWidget> createState() {
return SignUpState(this.lat, this.lang,this.email,this.password,this.gender,this.role,this.name);
  }

}class SignUpState extends State<SignUp>{
  bool isLoading = false;
  String emaill;
  String passwordd;
  String gender;
  String role;
  LatLng ?startLocation ;
  String  lat;
  String lang;
  String namee;

  SignUpState(this.lat, this.lang,this.emaill,this.passwordd,this.gender,this.role,this.namee);

  GoogleMapController? mapController;
  Set<Marker>?myMarker;
  TextEditingController name=new TextEditingController();
  TextEditingController password=new TextEditingController();
  TextEditingController email=new TextEditingController();
  GlobalKey<FormState>formStateSignUp=new GlobalKey<FormState>();
   String? validatePassword(String ?value) {
    if (value==null)
      return 'Password Can not Empty';
    else if (value!.trim().length<8)
      return 'Password Can not less than 8 charً';
  else  if(value!.trim().length>12)
      return 'Password Can not more than 8 charً';
  }

  createUser(String id) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var userspref = FirebaseFirestore.instance.collection("Users");
    userspref.add({
      "id":id,
      "name": name.text,
      "email": email.text,
      "kind": gender,
      "role": role,
      "created_at": date,
      "password":password.text,
      "lat":lat,
      "lang":lang
    });
  }
  signUp(BuildContext context) async {
    var formData=formStateSignUp.currentState;
    if(formData!.validate()) {
      formData.save();
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );
        print("helllo");
        print(credential.user!.uid);
        String? id =  await credential.user!.uid;
        setState(() {

        });
        print(id);
        createUser(id!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", id);
        await prefs.setString('email', email.text);
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Section(role.toString())),(Route<dynamic> route) => false);
print("helllo");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("The password provided is too weak.".tr()),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang,this.emaill,this.passwordd,this.gender,this.role,this.namee)));}, child:Text("Cancel") )],
              );
            },
          );

        } else if (e.code == 'email-already-in-use') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("The account already exists for that email.".tr()),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang,this.emaill,this.passwordd,this.gender,this.role,this.namee)));}, child:Text("Cancel") )],
              );
            },
          );


        }
        else if (e.code == 'auth/invalid-email'){
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("invalid-email".tr()),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang,this.emaill,this.passwordd,this.gender,this.role,this.namee)));}, child:Text("Cancel") )],
              );
            },
          );
        }
      } catch (e) {
        print(e);
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("No Internet Access".tr()),
              actions: [
                ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp(lat,lang,this.emaill,this.passwordd,this.gender,this.role,this.namee)));}, child:Text("Cancel") )],
            );
          },
        );
      }
    }

  }
  bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

   @override
  void initState() {
     startLocation = LatLng(double.parse(lat),double.parse(lang));
     myMarker={
       Marker(markerId: MarkerId("1"),position:LatLng(double.parse(lat),double.parse(lang)) )
     };
     name.text=namee;
     email.text=emaill;
     password.text=passwordd;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body:
         SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Container(

               padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/20),
             decoration:
             BoxDecoration(
               borderRadius: BorderRadius.circular(33)


       ),
           child:  Form(
               key: formStateSignUp,
             child:

           Container(
padding: const EdgeInsets.symmetric(horizontal: 16.0),


              child:

                  Card(elevation: 3,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),

                    ),
                      borderOnForeground: true,child:    Container(
                   // height: MediaQuery.of(context).size.height,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(children: [
                            Container(

                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20,top:70),
                              child:
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: name,
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Field is required.'.tr();
                                    return null;
                                  },

                                  decoration:  InputDecoration(
                                      fillColor: Colors.white,

                                      border:OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))),
                                      labelText:'Name'.tr(),

                                      labelStyle: TextStyle(color: Colors.black87,fontSize: 15)
                                  ),
                                ),
                              ) ,

                              //color: Colors.blueGrey
                            ),
                            Container(alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Field is required.'.tr();
                                    if(isEmail(value)==false)
                                      return "Invalid email";

                                  },
                                  controller: email,
                                  textCapitalization: TextCapitalization.words,


                                  decoration:  InputDecoration(
                                    fillColor: Colors.white,

                                    border:OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                      labelText:'Email'.tr(),

                                      labelStyle: TextStyle(color: Colors.black87,fontSize: 15)
                                  ),
                                ),
                              ) ,

                              //color: Colors.blueGrey
                            ),
                            Container(alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator:validatePassword,
                                  controller: password,
                                  textCapitalization: TextCapitalization.words,
                                  obscureText: true,

                                  decoration:  InputDecoration(
                                    fillColor: Colors.white,

                                    border:OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                      labelText:'Password'.tr(),

                                      labelStyle: TextStyle(color: Colors.black87,fontSize: 15)
                                  ),
                                ),
                              ) ,

                              //color: Colors.blueGrey
                            ),
                          ]),


                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text("Gender".tr(),style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        CupertinoRadioChoice(
                            choices: {'male' : 'Male', 'female' : 'Female', 'other': 'Other'},
                            onChange: (selectedGender) {gender=selectedGender;
                              },
                            selectedColor: Colors.black,

                           initialKeyValue: gender),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text("Role".tr(),style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        CupertinoRadioChoice(
                            selectedColor: Colors.black,
                            choices: {'manger' : 'manger', 'employee' : 'Employee' },
                            onChange: (selected) {role = selected;},
                            initialKeyValue: role),

                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.height / 4,
                            child: Stack(children: [
                              GoogleMap(

                                //Map widget from google_maps_flutter package
                                zoomGesturesEnabled: true, //enable Zoom in, out on map
                                initialCameraPosition: CameraPosition(
                                  //innital position in map
                                  target: startLocation!, //initial position
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

                            ]),
                          ),
                          onLongPress: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap("","","","","","","","",lat, lang,0,"",email.text,password.text,gender,role,name.text,"")));
                          },
                        ),
                        Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/20)),
                        (isLoading==false) ?
                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.5,

                          child: ElevatedButton(

                              onPressed: ()async{
                                setState((){
                                  isLoading=true;
                                });
                                await signUp(context);
                                setState((){
                                  isLoading=false;
                                });
                                   },
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
                              child: Text("Sign Up".tr(),style: TextStyle(fontSize: 30),)),
                        ): Center(child:CircularProgressIndicator())
                ,Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/30)),
                         InkWell(child: Text("I have an account".tr()),
                            onTap:(){Navigator.pushAndRemoveUntil(
                                context
                                ,MaterialPageRoute(builder: (context)=>Login()),(Route<dynamic> route) => false);} )
                        ,Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/30))
                      ],) ,) ,)


             ),
           ) ,),
         )

   );
  }

}