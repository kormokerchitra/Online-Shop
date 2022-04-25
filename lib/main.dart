import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainScreens/SplashScreen/splash.dart';

void main() => runApp(MyApp());

Color mainheader = Colors.blue;
Color subheader = Colors.lightBlue;
Color sub_white = Color(0xFFf4f4f4);
Color white = Color(0xFFFFFFFF);
Color golden = Color(0xFFCFB53B);

String pageDirect = "";
String userID = "";
int selectedPage = 0;
bool isLoggedin = false;

String ip = "http://192.168.100.5/";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getuserID();
  }

  getuserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString("userId");
      if (userID != null) {
        isLoggedin = true;
      }
    });
    print("userID");
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy shopping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: subheader,
        fontFamily: 'Nunito',
      ),
      home: SplashScreen(),
      //routes: routes,
    );
  }
}
