import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'CustomColors.dart';

class ShowApplicaton extends StatefulWidget {
  String sectionId;
  String jobId;
  String jobname;
  ShowApplicaton(this.sectionId, this.jobId,this.jobname);

  @override
  State<ShowApplicaton> createState() =>
      _ShowApplicatonState(this.sectionId, this.jobId,this.jobname);
}

class _ShowApplicatonState extends State<ShowApplicaton> {
  String sectionId;
  String jobId;
  String jobname;
  String username = "";
  String email = "";

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id');
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("id", isEqualTo: id).get();
    setState(() {
      username = (query.docs[0]["name"]).toString();
      email = (query.docs[0]["email"]).toString();
    });
  }

  onPressAcce(String appId) async {
    var userspref =
        FirebaseFirestore.instance.collection("Application").doc(appId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "status": "1",
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }

  onPressunAcce(String appId) async {
    var userspref =
        FirebaseFirestore.instance.collection("Application").doc(appId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot docsnap = await transaction.get(userspref);
      if (docsnap.exists) {
        transaction.set(
            userspref,
            {
              "status": "2",
            },
            SetOptions(merge: true));
      } else {
        print("no");
      }
    });
  }

  _ShowApplicatonState(this.sectionId, this.jobId,this.jobname);

  @override
  Widget build(BuildContext context) {
    CollectionReference jobRef =
        FirebaseFirestore.instance.collection("Application");
    getUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBar,
        title: Text(jobname),
        centerTitle: true,

      ),
      body: StreamBuilder<dynamic>(
          stream: jobRef.where("jobid",isEqualTo: jobId).snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasError) {
              return Text("erorr".tr());
            }
            if (snapshots.hasData) {
              return ListView.builder(
                itemCount: snapshots.data.docs!.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    //trailing: Icon(Icons.monetization_on),
                    leading: Icon(Icons.padding),
                    title: Text("${snapshots.data.docs[i].data()["name"]}"),
                    subtitle: Text("${snapshots.data.docs[i].data()["email"]}"),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("${snapshots.data.docs[i].data()["name"]}"),
                              actions: [
                                Center(
                                  child: Card(child: Text("${snapshots.data.docs[i].data()["email"]}")),
                                ),
                                Card(
                                  //elevation: 3,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Expected salary".tr()),
                                        Text(
                                            "${snapshots.data.docs[i].data()["expected salary"]}")
                                      ]),
                                ),
                                Card(
                                  //elevation: 3,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Notes".tr()),
                                        Text(
                                            "${snapshots.data.docs[i].data()["notes"]}")
                                      ]),
                                ),
                                Card(
                                 // elevation: 3,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Start At".tr()),
                                        Text(
                                            "${snapshots.data.docs[i].data()["Start_at"]}")
                                      ]),
                                ),
                                Card(
                                 // elevation: 3,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Created At".tr()),
                                        Text(
                                            "${snapshots.data.docs[i].data()["created_at"]}")
                                      ]),
                                ),
                                Card(
                                   // elevation: 3,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Status".tr()),
                                          if ((snapshots.data.docs[i]
                                                      .data()["status"])
                                                  .toString() ==
                                              "0")
                                            Text("Wating".tr())
                                          else if ((snapshots.data.docs[i]
                                                      .data()["status"])
                                                  .toString() ==
                                              "1")
                                            Text("Acceptable")
                                          else if ((snapshots.data.docs[i]
                                                      .data()["status"])
                                                  .toString() ==
                                              "2")
                                            Text("UnAcceptable"),
                                        ])),
                                ((snapshots.data.docs[i].data()["status"])
                                            .toString() ==
                                        "0")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
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
                                                onPressAcce(
                                                    (snapshots.data.docs[i].id)
                                                        .toString());
                                                Navigator.pop(context);
                                              },
                                              child: Text("Acceptable".tr())),
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
                                                onPressunAcce(
                                                    (snapshots.data.docs[i].id)
                                                        .toString());
                                                Navigator.pop(context);
                                              },
                                              child: Text("UnAcceptable".tr()))
                                        ],
                                      )
                                    : Center()
                              ],
                            );
                          });
                    },
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
