import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
double totalPrice = 0.0;
bool isLoggedin = false;
List userList = [];
var userInfo;
StreamSubscription internetconnection;
bool isoffline = false;

String ip = "http://192.168.100.5/";
//String ip = "http://192.168.43.23/";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivityState();
    getuserInfo();
  }

  getuserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var user = prefs.getString("user_info");
      print("user - $user");

      if (user != null) {
        userInfo = json.decode(user);
        isLoggedin = true;
      }
    });
    print("userInfo");
    print(userInfo);
  }

  Future<void> _checkConnectivityState() async {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    });
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
