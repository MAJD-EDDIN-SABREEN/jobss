import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddSection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddSectionState();
  }

}
class AddSectionState extends State<AddSection>{
  bool isLoading = false;
  File ?file;
  var imagepicker = ImagePicker();
  var nameImage;
  var url;
  GlobalKey<FormState>formStateAddSection=new GlobalKey<FormState>();
  TextEditingController title=new TextEditingController();
  addSection(BuildContext context) async {
    var formData=formStateAddSection.currentState;
    if(formData!.validate()) {
      formData.save();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    var userspref = FirebaseFirestore.instance.collection("Section");
    userspref.add({
      "name": title.text,
      if(file!=null)
      "image":url.toString()
    });
      Navigator.pop(context);}
  }
  uplodImages() async {
    var imagePicked = await imagepicker.getImage(source: ImageSource.camera);
    if (imagePicked != null) {
      setState(() {
        file = File(imagePicked.path);
        nameImage = basename(imagePicked.path);
      });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
      title: Text("Add Section".tr()),
        centerTitle: true,
      ),
      body:
      Container(
        //height: MediaQuery.of(context).size.height/2,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              //set border radius more than 50% of height and width to make circle
            ),
margin: EdgeInsets.all(15),
          elevation: 10,
          child: Container(
              height: MediaQuery.of(context).size.height/2,
           // width:  MediaQuery.of(context).size.width/2,
            padding: EdgeInsets.all(10),
            child:
            Column(


                children: [
                  (file==null)?
                  Container(

                    height: MediaQuery.of(context).size.height/6,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
color: Colors.grey

                        ),
                    child: IconButton(onPressed: (){
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
                    }, icon: Icon(Icons.image)),

                    ):
                 InkWell(child:Container(
                   height: MediaQuery.of(context).size.height/6,
                   width: MediaQuery.of(context).size.width/2,
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
                  ,    Padding(padding: EdgeInsets.only(top: 10)),
                  Form(
                    key: formStateAddSection,
                  child:TextFormField(
                    controller: title,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Field is required.'.tr();
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,


                    decoration:  InputDecoration(
                        fillColor: Colors.white,

                        filled: true,
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                       // icon: Icon(Icons.pages_outlined),
                        labelText:'Title'.tr(),

                        labelStyle: TextStyle(color: Colors.black87,fontSize: 10)
                    ),
                  )) ,
                  Spacer(),
                  (isLoading==false) ?
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
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
            if(file!=null){
            var refStorage = FirebaseStorage.instance.ref("images/$nameImage");
            await refStorage.putFile(file!);
            url = await refStorage.getDownloadURL();
            }
            await addSection(context);
            setState((){
              isLoading=false;
            });


    }, child:Text("add")),
                  ):
                  Center(child:CircularProgressIndicator()),


                ]),
          ),
        ),
      ),


    );
  }

}