import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi/pages/addtaxi.dart';
import 'package:taxi/pages/homescreen.dart';
import 'package:taxi/pages/login.dart';
import 'package:taxi/pages/message.dart';
import 'package:taxi/pages/signupsuccess.dart';

SharedPreferences prefs;
var userid;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()  ; 
  prefs = await SharedPreferences.getInstance();
  userid = prefs.getString("id");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 10, color: Colors.red),
          headline2: TextStyle(
              fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w600),
          headline3: TextStyle(
              fontSize: 23, color: Colors.blue, fontWeight: FontWeight.w600),
          bodyText1: TextStyle(fontSize: 20),
          bodyText2: TextStyle(fontSize: 13),
        ),
      ),
      home: userid == null ? Login() : HomeScreen(),
      routes: {
        "home": (context) => HomeScreen(),
        "addtaxi": (context) => AddTaxi(),
        "login": (context) => Login() , 
        "success" : (context) => SignUpSuccess()  , 
        "message" : (context) => Message()
      },
    );
  }
}
