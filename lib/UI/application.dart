import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobss/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Application extends StatefulWidget {
  String sectionId;
   String jobId;
  Application(this.sectionId,this.jobId);

  @override
  State<Application> createState() => _ApplicationState(this.sectionId,this.jobId);
}

class _ApplicationState extends State<Application>  {
  String sectionId;
  String jobId;
  String id='';
   bool applied=false;
  _ApplicationState(this.sectionId, this.jobId);
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  TextEditingController expactSalary=new TextEditingController();
  TextEditingController notes=new TextEditingController();
  TextEditingController date=new TextEditingController();
  getapplied()async{
    final prefs = await SharedPreferences.getInstance();
     id= (await prefs.getString("id"))!;
     setState(() {

     });
     try{var userPref=await FirebaseFirestore.instance.collection("Application");
     var query=await userPref.where("userid",isEqualTo:id.toString()).where("jobid",isEqualTo: jobId).get();
     if(query.docs[0]==null){
       applied=false;
     }
     else{
       setState(() {
         applied=true;
       });
     }
     }
     catch(e){
       applied=false;
     }


  }
  addAppli() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    final prefs = await SharedPreferences.getInstance();
    String? id1= await prefs.getString("id");
    setState(() {
    id=id1.toString();
    });
    var userspref = await FirebaseFirestore.instance.collection("Application");
    userspref.add({
      "expected salary": expactSalary.text,
      "notes":notes.text,
      "Start_at":"${selectedDate.year}"+"-"+"${selectedDate.month}"+"-"+"${selectedDate.day}",
      "userid":id,
      "status":"0",
      "created_at":date.toString()
      ,"jobid":jobId,
      "sectionid":sectionId
    });
  }
  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
      lastDate: DateTime(DateTime.now().year,DateTime.now().month+1,DateTime.now().day),

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        date.text='${selectedDate.year}' +
            '/' +
            '${selectedDate.month}' +
            '/' +
            '${selectedDate.day}';
      });
  }
@override
  void initState() {
    date.text='${selectedDate.year}' +
        '/' +
        '${selectedDate.month}' +
        '/' +
        '${selectedDate.day}';

  }
  @override
  Widget build(BuildContext context) {
    getapplied();
    return  Scaffold(
      appBar: AppBar(title: Text("Add Application"),
      backgroundColor: Colors.black,
      centerTitle: true),
      body: 
      Container(
height: MediaQuery.of(context).size.height/2,
       // padding: EdgeInsets.all(10),
        child:
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            //set border radius more than 50% of height and width to make circle
          ),
          elevation: 10,
          margin: EdgeInsets.all(15),
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
Padding(padding: EdgeInsets.only(top: 10)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: expactSalary,
                    textCapitalization: TextCapitalization.words,

keyboardType: TextInputType.number,
                    decoration: const InputDecoration(

                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText:'Expacted Salary',

                        labelStyle: TextStyle(color: Colors.black87,fontSize: 10)
                    ),
                  ),
                ) ,

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: notes,
                    textCapitalization: TextCapitalization.words,


                    decoration: const InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText:'notes',

                        labelStyle: TextStyle(color: Colors.black87,fontSize: 10)
                    ),
                  ),
                ) ,
                InkWell(child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: date,
                    onTap: (){ _selectedDate(context);},
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText:'date',


                        labelStyle: TextStyle(color: Colors.black87,fontSize: 10)
                    ),
                  ),
                ),
                onTap:(){ _selectedDate(context);} ) ,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Icon(
                //       Icons.date_range,
                //       size: 20,
                //       color: Colors.black54,
                //     ),
                //     Text(
                //         "date",
                //         style: TextStyle(
                //             color: Colors.black54,
                //             fontStyle: FontStyle.italic,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20)),
                //     Text(
                //       '${selectedDate.year}' +
                //           '/' +
                //           '${selectedDate.month}' +
                //           '/' +
                //           '${selectedDate.day}',
                //       style: TextStyle(
                //         color: Colors.black54,
                //         fontStyle: FontStyle.italic,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20,
                //       ),
                //     ),
                //     ElevatedButton(
                //       style: ButtonStyle(
                //           backgroundColor: MaterialStateProperty.all<Color>(
                //               Colors.blue)),
                //       child: Text(
                //         "selectDate",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontStyle: FontStyle.italic,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20),
                //       ),
                //       onPressed: () {
                //         _selectedDate(context);
                //       },
                //     ),
                //   ],
                // ),
                Padding(padding: EdgeInsets.only(top: 80)),
                (applied==false)?

                SizedBox(
                  width: MediaQuery.of(context).size.width,
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
                      onPressed: () async {
                    setState((){
                      isLoading=true;
                    });

                    await addAppli();
                    setState((){
                      isLoading=false;
                    });
                    Navigator.pop(context);

                  }, child:Text("add")),
                ):
                Text("you applied alredy"),


              ]),
        ),
      ),

    );
  }
}
