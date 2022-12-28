import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobss/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/Log_In.dart';
import 'package:jobss/UI/Myapplication.dart';
import 'package:jobss/UI/Setting.dart';
import 'package:jobss/UI/addSection.dart';
import 'package:jobss/UI/sectionDetail.dart';

import 'EditInfo.dart';
import 'Jobs.dart';
import 'Skills.dart';


class Section extends StatefulWidget {
  String role;


  Section(this.role);

  @override
  State<StatefulWidget> createState() {
    return SectionState(this.role);
  }

}

class SectionState extends State<Section> {
  String role;
  SectionState(this.role);
  int _selectedIndex = 0;
  bool isLoding=true;
  void _onItemTapped(int index) {
    if(index==0){

    }
    if(index==1){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>MyApplication()));


    }
    if(index==2){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting(role)));

    }
    setState(() {
     // _selectedIndex = index;
      print(_selectedIndex);
    });
  }
  CollectionReference sectionRef = FirebaseFirestore.instance.collection(
      "Section");

signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Login()),(Route<dynamic> route) => false);

}
  String? email;
  String? image;
  String? name;
  String ?id;
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
  getEmail() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = await prefs.getString('email');
      id=await prefs.getString('id');
      var userPref = FirebaseFirestore.instance.collection("Users");
      var query = await userPref.where("email", isEqualTo: email).get();
      name = query.docs[0]["name"];

    }
  catch(e){
    print("hiiiii");
      print(e);
  }


    setState(() {});
    print(name);
  }

  getDetail() async {
    await getEmail();
    setState(() {
      isLoding=false;
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

    return
      (isLoding==true)?
       Scaffold(
        appBar:AppBar(backgroundColor: Colors.black,
            title: Text("Section".tr()),
            centerTitle: true,
            ),
        // resizeToAvoidBottomInset: false,
        body: Center(child: CircularProgressIndicator(),),
      ):
      (role=="manger")?
      Scaffold(
        drawer: Drawer(
          child:
          Container(
            width:MediaQuery.of(context).size.width/2,
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
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.width / 2,
                                      child: Container(


                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,

                                            image: DecorationImage(

                                            fit: BoxFit.fill, image:AssetImage("images/job.jpg")),

                                        ),

                                        // ),
                                      ),


                            ),


Padding(padding: EdgeInsets.only(top: 10)),

  Center(
    child:
    Row(
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

                          Padding(padding: EdgeInsets.only(top: 10))
                          ,Center(child: Text("${email!}",style: TextStyle(color: Colors.white,fontSize: 10),)),
                

                        ],
                      ),
                    ),



                    Container(

                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Row(children: [
                        Padding(padding: EdgeInsets.only(right: 5)),
                        Icon(
                          Icons.account_tree,
                          color: Colors.black,
                          size: 30,
                        ),
                       Padding(padding: EdgeInsets.only(right: 30)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width/1.8,
                          child:
                            InkWell(
                              child: Text(
                                  "Section".tr()
                                      ,style: TextStyle(fontSize: 20),
                              ),
                              onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
              Section(role)));
        } ,
                            )

                        ),
                      ]),
                    ),

                    Container(

                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 30,
                        ),
                      Padding(padding: EdgeInsets.only(right: 36)),
                      SizedBox(
                          width: MediaQuery.of(context).size.width/1.8,
                          child:
                          InkWell(
                            child: Text(
                              "Setting".tr()
                              ,style: TextStyle(fontSize: 20),
                            ),
                            onTap:  () { Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting(role)));}
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
                    Container(

                      height: MediaQuery.of(context).size.height / 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.logout_sharp,
                          color: Colors.black,
                          size: 30,
                        ),
                        Padding(padding: EdgeInsets.only(right: 36)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width/1.8,
                            child:
                            InkWell(
                                child: Text(
                                  "Logout".tr()
                                  ,style: TextStyle(fontSize: 20),
                                ),
                                onTap:  () async{
                                  signOut();
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.remove('email');
                                          prefs.remove('id');
                                          prefs.remove('theme');
                                 }
                            )),

                      ]),
                    ),
                  ],
                )),
          ),
        ),
        appBar: AppBar(backgroundColor: Colors.black,
        title: Text("Section".tr()),
        centerTitle: true,
        actions: [

          // IconButton(onPressed: (){
          //   Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting()));
          // }, icon:Icon(Icons.settings)),
        ]),
        backgroundColor: Colors.black,
      body: Container(color: Colors.black,child:StreamBuilder<dynamic>(stream: sectionRef.where("mid",isEqualTo: id).snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr".tr());
              }
              if(snapshots.hasData){
                return



                    //SizedBox(height: 15.0),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        //height: MediaQuery.of(context).size.height,
                        child: GridView.builder(
                          //childAspectRatio: (1 / .4),
                          //shrinkWrap: true,
                         // scrollDirection: Axis.vertical,
                          gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,

                            //mainAxisSpacing: 50
                            childAspectRatio: 1 /MediaQuery.of(context).size.height/4,
                          ),
                          itemCount: snapshots.data.docs!.length,
                          itemBuilder: (BuildContext context, int postion) {
                            return  Container(
                               // height: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(20)
                              ),

                                padding: EdgeInsets.only(top: 6, bottom: 2.0, left: 5.0, right: 5.0),
                                child: InkWell(
                                  child: Container(
                                      //height: MediaQuery.of(context).size.height,
                                    child: Column(children: [
                                      //Padding(padding: EdgeInsets.only(top: 10)),


                                        Container(

                                          height: MediaQuery.of(context).size.height/6,

                                          //margin: EdgeInsets.only(top: 50),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30),
                                              image: DecorationImage(
                                                  image: NetworkImage("${snapshots.data.docs[postion].data()["image"]}"), fit: BoxFit.fill)),
                                        ),

                                       Container(
                                           // height: MediaQuery.of(context).size.height/10,
                                          //color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                              "${snapshots.data.docs[postion].data()["name"]}" ,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  //fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),

                                    ]),
                                  ),
                                  onTap: () {
                                    showDialog(context: context, builder: (
                                        BuildContext context) {
                                      return
                                        AlertDialog(
                                          elevation: 50,
                                        backgroundColor: Colors.white,
                                        icon:   Icon(Icons.select_all),
                                          title: Text("please select".tr()),
                                          actions: [
                                            InkWell(
                                              child: Row(
                                                
                                                children: [
                                                  Icon(Icons.update),
                                                  Padding(padding: EdgeInsets.only(left: 10)),
                                                  Text("Update Section".tr())
                                                ],
                                              )
                                              , onTap: () {
                                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SectionDetail(snapshots.data.docs[postion].id,"${snapshots.data.docs[postion].data()["image"]}", "${snapshots.data.docs[postion].data()["name"]}" )));
                                            },
                                            ),
                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.work),
                                                  Padding(padding: EdgeInsets.only(left: 10)),
                                                  Text("show Jobs".tr())
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs("${snapshots.data.docs[postion].id}",role.toString(),"${snapshots.data.docs[postion].data()["name"]}")));
                                              },
                                            )
                                            //onTap: uplodImages(),

                                          ],
                                        );
                                    });

                                  },
                                ));


                          },
                        ));




              }

              return Center(child: CircularProgressIndicator());
            }
        ) ,),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSection()));
    },child: Icon(Icons.add)),



      ):
      Scaffold(
          drawer: Drawer(
            child:
            Container(
              width:MediaQuery.of(context).size.width/2,
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
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Container(


                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                  image: DecorationImage(

                                      fit: BoxFit.fill, image:AssetImage("images/job.jpg")),

                                ),

                                // ),
                              ),


                            ),


                            Padding(padding: EdgeInsets.only(top: 10)),

                            Center(
                              child:
                              Row(
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

                            Padding(padding: EdgeInsets.only(top: 10))
                            ,Center(child: Text("${email!}",style: TextStyle(color: Colors.white,fontSize: 10),)),


                          ],
                        ),
                      ),



                      Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Padding(padding: EdgeInsets.only(right: 5)),
                          Icon(
                            Icons.account_tree,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 30)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                child: Text(
                                  "Section".tr()
                                  ,style: TextStyle(fontSize: 20),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => Section(role)));
                                } ,
                              )

                          ),
                        ]),
                      ),

                      Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 36)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                  child: Text(
                                    "Setting".tr()
                                    ,style: TextStyle(fontSize: 20),
                                  ),
                                  onTap:  () { Navigator.push(context,MaterialPageRoute(builder: (context)=>Setting(role)));}
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
                      Container(

                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.logout_sharp,
                            color: Colors.black,
                            size: 30,
                          ),
                          Padding(padding: EdgeInsets.only(right: 36)),
                          SizedBox(
                              width: MediaQuery.of(context).size.width/1.8,
                              child:
                              InkWell(
                                  child: Text(
                                    "Logout".tr()
                                    ,style: TextStyle(fontSize: 20),
                                  ),
                                  onTap:  () async{
                                    signOut();
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.remove('email');
                                    prefs.remove('id');
                                    prefs.remove('theme');
                                  }
                              )),

                        ]),
                      ),
                    ],
                  )),
            ),
          ),
        appBar: AppBar(backgroundColor: Colors.black,
title: Text("Section".tr()),
            centerTitle: true,

            actions: [

            ]),

        backgroundColor: Colors.black,
        body:
        Container(color: Colors.black,child:StreamBuilder<dynamic>(stream: sectionRef.snapshots(),
            builder:(context,snapshots){

              if(snapshots.hasError){
                return Text("erorr".tr());
              }
              if(snapshots.hasData){
                print( "${snapshots.data}");
                return
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height,
                      child: GridView.builder(

                        //childAspectRatio: (1 / .4),
                        //shrinkWrap: true,
                        // scrollDirection: Axis.vertical,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,


                          //mainAxisSpacing: 50
                          childAspectRatio: 1 /MediaQuery.of(context).size.height/4,
                        ),
                        itemCount: snapshots.data.docs!.length,

                        itemBuilder: (BuildContext context, int postion) {
                          print(  "${snapshots.data.docs[postion].data()["name"]}" );
                          return  Container(
                            // height: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(20)
                              ),

                              padding: EdgeInsets.only(top: 6, bottom: 2.0, left: 5.0, right: 5.0),
                              child: InkWell(
                                child: Container(
                                 // height: MediaQuery.of(context).size.height/1,
                                  child: Column(children: [
                                    //Padding(padding: EdgeInsets.only(top: 10)),


                                    Container(

                                      height: MediaQuery.of(context).size.height/6,

                                      //margin: EdgeInsets.only(top: 50),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          image: DecorationImage(
                                              image: NetworkImage("${snapshots.data.docs[postion].data()["image"]}"), fit: BoxFit.fill)),
                                    ),

                                    Container(
                                      // height: MediaQuery.of(context).size.height/10,
                                      //color: Colors.grey,
                                      child: Center(
                                        child: Text(
                                          "${snapshots.data.docs[postion].data()["name"]}" ,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),

                                  ]),
                                ),
                                  onTap: () {
                                    showDialog(context: context, builder: (

                                        BuildContext context) {
                                      return
                                        AlertDialog(
                                          elevation: 50,
                                          backgroundColor: Colors.white,
                                          icon:   Icon(Icons.select_all),
                                          title: Text("please select".tr()),
                                          actions: [

                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWell(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.work),
                                                  Padding(padding: EdgeInsets.only(left: 10)),
                                                  Text("show Jobs".tr())
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Jobs("${snapshots.data.docs[postion].id}",role,"${snapshots.data.docs[postion].data()["name"]}")));
                                              },
                                            )
                                            //onTap: uplodImages(),

                                          ],
                                        );
                                    });

                                  },
                                ));


                          },
                        ));

              }

              return Center(child: CircularProgressIndicator());
            }
        ) ,),
          bottomNavigationBar: BottomNavigationBar(
            items:  <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'My application'.tr(),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile'.tr(),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          )


      )

    ;
    }

  }