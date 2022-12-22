import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/SignUp.dart';
import '../main.dart';
import 'Sections.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  String role = "";
  GlobalKey<FormState>formStateLogin=new GlobalKey<FormState>();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();

  getRole() async {
    var userPref = FirebaseFirestore.instance.collection("Users");
    var query = await userPref.where("email", isEqualTo: email.text).get();
    setState(() {
      role = query.docs[0]["role"];
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("role", role!);
  }

  login(BuildContext context) async {
    var formData=formStateLogin.currentState;
    if(formData!.validate()) {
      formData.save();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);
      await getRole();

      String? id = userCredential.user?.uid;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("id", id!);
      await prefs.setString('email', email.text);
      //setState(() {});
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Section(role)),
              (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("No user found for that email."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Cancel"))
              ],
            );
          },
        );
      } else if (e.code == 'wrong-password') {
        print("ffhfhf");
       return  showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("password not correct"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text("Cancel"))
              ],
            );
          },
        );
      }
    }}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 10,right: 10,top:MediaQuery.of(context).size.height/4),
          decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(20),
          ),
          child:Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              //set border radius more than 50% of height and width to make circle
            ),
            elevation: 5,child:
          Form(
            key: formStateLogin,
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Icon(
                            Icons.person,
                            size: MediaQuery.of(context).size.width / 4,
                          )),
                      Center(child: Text("Login" ,style: TextStyle(fontSize: 50),),),
Padding(padding: EdgeInsets.only(top: 10)),
                    Column(children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),

                                  filled: true,
                                  //icon: Icon(Icons.mail),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                      //color: Colors.black87,
                                     // fontWeight: FontWeight.bold
                                  )),
                            ),

                            //color: Colors.blueGrey
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: password,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Field is required.';
                                return null;
                              },
                              textCapitalization: TextCapitalization.words,
                              obscureText: true,
                              style:TextStyle(color: Colors.black) ,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,

                                  border:OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),

                                  filled: true,
                                 // icon: Icon(Icons.password),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      fontSize: 10,
                                      //color: Colors.black87,
                                      //fontWeight: FontWeight.bold
                                  )),
                            ),

                            //color: Colors.blueGrey
                          ),
                        ]),

                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 14)),
                      (isLoading == false)
                          ?
                      Container(
                        height: 50,

                       // decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                        width: MediaQuery.of(context).size.width/1.5,
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
// ElevatedButton.styleFrom(
//
//   backgroundColor:Colors.black ,
//     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//     textStyle: TextStyle(
//         fontSize: 10,
//         fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              await login(context);
                              setState(() {
                                isLoading = false;
                              });

                            },

                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 30),
                            )),
                      )
                          : Center(child: CircularProgressIndicator()),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        child: Text("Don't have an account"),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp("30.044420"," 31.235712")),
                                  (Route<dynamic> route) => false);
                        },
                      )
                    ],
                  ),
                )),
          ),)
       ,
        ) ,
        );
  }
}
