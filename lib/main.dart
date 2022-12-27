import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobss/UI/Log_In.dart';
import 'package:jobss/UI/Sections.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';

import 'UI/SplachScreen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var role=  prefs.getString('role');
  var theme=prefs.getBool('theme');
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets', // <-- change the path of the translation files
      fallbackLocale: Locale('en', 'US'),
      child:MyApp()
    ));
}
class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> notifier = ValueNotifier(ThemeMode.light);
  ThemeMode themeMode = ThemeMode.system;
  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder<ThemeMode>(
        valueListenable: notifier,
        builder: (_, mode, __) {
          return MaterialApp(

        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',

              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),

              themeMode: notifier.value,
              routes: <String, WidgetBuilder>{

          '/section': (BuildContext context) => Section(""),

        },
        home:
        SplashScreen()

    );
  });
}}




