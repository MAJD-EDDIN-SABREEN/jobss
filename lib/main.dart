import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/Log_In.dart';
import 'package:jobss/UI/Sections.dart';
import 'package:lottie/lottie.dart';

import 'UI/SplachScreen.dart';
class CustomColors  {
  static Color appBar =  Color(0xf0000000);
  static Color button =  Color(0xf0000000);
  static Color aSidebar =  Color(0xff7C01FF);
  static Color aSoundButton =  Color(0xffA93EF0);
  static Color containerBackground =  Color(0xff555555);
  static Color aSoundButtonText =  Color(0xffFFFFFF);
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var role=  prefs.getString('role');
  var theme=prefs.getBool('theme');
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          routes: <String, WidgetBuilder>{

            '/section': (BuildContext context) => Section(""),

          },
          home:
          SplashScreen()


        //(email==null)?Login():Section(role.toString()),
      ));
}




