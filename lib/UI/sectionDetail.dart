import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class SectionDetail extends StatefulWidget{
  String id;
  String image;
  String title;

  SectionDetail(this.id, this.image, this.title);

  @override
  State<StatefulWidget> createState() {
    return SectionDetailState(this.id, this.image, this.title);
  }

}
class SectionDetailState extends State<SectionDetail>{
  String id;
  String image;
  String title;

  SectionDetailState(this.id, this.image, this.title);
  bool isLoading = false;
  File ?file;
  GlobalKey<FormState>formStateUpdateSection=new GlobalKey<FormState>();
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  TextEditingController title1=new TextEditingController();
  updateData(var id,BuildContext context) async {
    var formData=formStateUpdateSection.currentState;
    if(formData!.validate()) {
      formData.save();
    var userspref = FirebaseFirestore.instance
        .collection("Section")
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.update(userspref, {
          "name": title1.text,
          if(file!=null)
          "image":url.toString()

        });
      }
      else {
        print("no");
      }
    });
      Navigator.pop(context);
  }
  }
  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {

        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });



      //  url= await refStorage.getDownloadURL();
      print(url);
    }
    else
      print("please select image");
  }

  uplodImagesFromGallery() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(() {

        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });


      var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
      await refStorage.putFile(file!);

      url = await refStorage.getDownloadURL();
      //  url= await refStorage.getDownloadURL();
      print(url);
    }
    else
      print("please select image");
  }
  deleteData(var id) async {
    var userspref = FirebaseFirestore.instance
        .collection("Section");
    userspref.doc(id).delete();
  }
  @override
  void initState() {
title1.text=title;  }
  @override
  Widget build(BuildContext context) {
return
  Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text("Update Section".tr()),
      centerTitle: true,
    ),
  body: 
  Container(padding: EdgeInsets.all(5),

    child:
    Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        //set border radius more than 50% of height and width to make circle
      ),
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        padding: EdgeInsets.all(10),
      child: Form(key:formStateUpdateSection ,

        child: Column(

            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
           // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 5)),
              (file==null)?
              InkWell(child:  Container(

                height: MediaQuery.of(context).size.height/6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:NetworkImage(image)
                    )
                ),


              ),
                onTap:(){  showDialog(context: context, builder: (
                    BuildContext context) {
                  return
                    AlertDialog(
                      title: Text("please select".tr()),
                      actions: [
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt),
                              Text("From camera".tr())
                            ],
                          )
                          , onTap: () {
                          Navigator.pop(context);
                          uplodImages();
                        },
                        ),
                        Padding(padding: EdgeInsets.all(10),),
                        InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              Text("From gallery".tr())
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            uplodImagesFromGallery();
                          },
                        )
                        //onTap: uplodImages(),

                      ],
                    );
                });} ,)

                  :
              InkWell(child:Container(
                height: MediaQuery.of(context).size.height/6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image:FileImage(file!)
                    )

                ),) ,
                  onTap: (){
                    showDialog(context: context, builder: (
                        BuildContext context) {
                      return
                        AlertDialog(
                          title: Text("please select".tr()),
                          actions: [
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.camera_alt),
                                  Text("From camera".tr())
                                ],
                              )
                              , onTap: () {
                              Navigator.pop(context);
                              uplodImages();
                            },
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            InkWell(
                              child: Row(
                                children: [
                                  Icon(Icons.image),
                                  Text("From gallery".tr())
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                uplodImagesFromGallery();
                              },
                            )
                            //onTap: uplodImages(),

                          ],
                        );
                    });
                  })
              ,

              Padding(
                padding: EdgeInsets.only(top: 10,right: 8,left: 8),
                child: TextFormField(
                  controller: title1,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Field is required.'.tr();
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,


                  decoration:  InputDecoration(
                      fillColor: Colors.white,

                      border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      filled: true,
                      //icon: Icon(Icons.pages_outlined),
                      labelText:'Title'.tr(),

                      labelStyle: TextStyle(color: Colors.black87,fontSize: 15)
                  ),
                ),
              ) ,
             Spacer()
              ,Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (isLoading==false) ?
                      SizedBox(width: MediaQuery.of(context).size.width/2.6,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(18.0), // radius you want
                                      side: BorderSide(
                                        color: Colors.transparent, //color
                                      ),
                                    ))),
                          onPressed: () async {
                            setState((){
                              isLoading=true;
                            });
                            var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
                            if(file!=null)
                            {
                              await refStorage.putFile(file!);
                              url = await refStorage.getDownloadURL();
                            }
                            else{
                              url=image;
                            }
                            await updateData(id,context);
                            setState((){
                              isLoading=false;
                            });
                          }, child:Text("Update".tr())) ,)

                      :
                  Center(child:CircularProgressIndicator()),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  (isLoading==false) ?
                  SizedBox(width: MediaQuery.of(context).size.width/2.6,
                      child:  ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(18.0), // radius you want
                                    side: BorderSide(
                                      color: Colors.transparent, //color
                                    ),
                                  ))),
                      onPressed: () async {
                        setState((){
                          isLoading=true;
                        });
                        await deleteData(id);
                        setState((){
                          isLoading=false;
                        });
                        Navigator.pop(context);}, child:Text("Delete".tr())))
                 :
                  Center(child:CircularProgressIndicator())
                ],
              ),
              //Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/15)),

            ]),
      ),),
    ),
  )



);
  }

}