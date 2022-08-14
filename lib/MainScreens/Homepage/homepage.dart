import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:online_shopping/MainScreens/BottomNavigation/CartPage/cartPage.dart';
import 'package:online_shopping/MainScreens/BottomNavigation/ProductPage/productPage.dart';
import 'package:online_shopping/MainScreens/BottomNavigation/ProfilePage/profilePage.dart';
import 'package:online_shopping/MainScreens/BottomNavigation/SearchPage/searchPage.dart';
import 'package:online_shopping/MainScreens/CreateAccountPage/account.dart';
import 'package:online_shopping/MainScreens/LoginPage/login.dart';
import 'package:online_shopping/MainScreens/MyProfilePage/myProfilePage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/AllCartPage/allCartPage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/AllCouponPage/allCouponpage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/CategoryPage/category.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/FavouritePage/favourite.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/NotificationPage/notifications.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/OrderPage/orders.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/TnCPage/tnc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Animation<double> animation;
  AnimationController controller;
  int currentIndex = selectedPage;
  String user_name = "", notification_count = "0";
  String pro_pic = "";
  List notifyList = [];
  int notifCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(userID);
    if (userInfo != null) {
      isLoading = true;
      pro_pic = "${userInfo["pro_pic"]}";
      getNotification();
    }
  }

  final pageOptions = [
    ProductPage(),
    SearchPage(),
    ProfilePage(),
    CartPage(),
  ];

  void clearLog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      isLoggedin = false;
      pro_pic = "";
      userInfo = null;
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> getNotification() async {
    final response = await http.post(
        ip + 'easy_shopping/notification_all_list.php',
        body: {"receiver": userInfo["user_id"]});
    if (response.statusCode == 200) {
      print(response.body);
      var notifyBody = json.decode(response.body);
      print(notifyBody["notification_list"]);

      setState(() {
        notifyList = [];
        isLoading = false;
        var notifList = notifyBody["notification_list"];
        for (int i = 0; i < notifList.length; i++) {
          print(
              "notifylist item ${notifList[i]["receiver"]} . ${userInfo["user_id"]}");
          if (notifList[i]["receiver"] == userInfo["user_id"]) {
            if (notifList[i]["seen"] == "0") {
              notifCount++;
              notification_count = "$notifCount";
            }
            notifyList.add(notifList[i]);
          }
        }

        print("notifylist - $notifyList");
        print("notifylist_count - $notification_count");
      });
    } else {
      throw Exception('Unable to fetch counter from the REST API');
    }
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to logout?'),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text('No')),
              ),
            ),
            GestureDetector(
              onTap: () {
                clearLog();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text('Yes')),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Drawer drawer = new Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()),
                    );
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: isLoggedin
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              children: <Widget>[
                                pro_pic != ""
                                    ? Container(
                                        padding: EdgeInsets.all(1.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              NetworkImage(ip + pro_pic),
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.grey, // border color
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : Container(
                                        //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                        padding: EdgeInsets.all(1.0),
                                        child: CircleAvatar(
                                          radius: 30.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              AssetImage('assets/user.png'),
                                        ),
                                        decoration: new BoxDecoration(
                                          color: Colors.grey, // border color
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Hello,",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black38),
                                      ),
                                      Text(
                                        !isLoggedin
                                            ? "User"
                                            : "${userInfo["full_name"]}",
                                        maxLines: 2,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      SizedBox(
                                        width: 10,
                                        height: isLoggedin ? 0 : 20,
                                      ),
                                      isLoggedin
                                          ? Container()
                                          : Container(
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LoginPage()));
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: mainheader,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 0.1,
                                                                color:
                                                                    mainheader)),
                                                        child: Text(
                                                          "Login",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                  SizedBox(width: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AccountPage()));
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 0.1,
                                                                color: Colors
                                                                    .grey)),
                                                        child: Text(
                                                          "Register",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(right: 30),
                        //     child: Icon(Icons.chevron_right)),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Divider()),
                // Container(
                //   color: Colors.grey[200],
                //   padding: EdgeInsets.all(15),
                //   margin: EdgeInsets.all(20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       GestureDetector(
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => ProfilePage()),
                //           );
                //         },
                //         child: Container(
                //           //width: MediaQuery.of(context).size.width / 4.4,
                //           child: Column(
                //             children: <Widget>[
                //               Icon(
                //                 Icons.account_box,
                //                 color: Colors.black38,
                //               ),
                //               SizedBox(
                //                 height: 3,
                //               ),
                //               Text(
                //                 "Profile",
                //                 style: TextStyle(color: Colors.black38),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => OrderPage()),
                //           );
                //         },
                //         child: Container(
                //           //width: MediaQuery.of(context).size.width / 4.4,
                //           child: Column(
                //             children: <Widget>[
                //               Icon(
                //                 Icons.list,
                //                 color: Colors.black38,
                //               ),
                //               SizedBox(
                //                 height: 3,
                //               ),
                //               Text(
                //                 "Orders",
                //                 style: TextStyle(color: Colors.black38),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //       GestureDetector(
                //         onTap: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => AllCartPage()),
                //           );
                //         },
                //         child: Container(
                //           //width: MediaQuery.of(context).size.width / 4.5,
                //           child: Column(
                //             children: <Widget>[
                //               Icon(
                //                 Icons.shopping_cart,
                //                 color: Colors.black38,
                //               ),
                //               SizedBox(
                //                 height: 3,
                //               ),
                //               Text(
                //                 "Cart",
                //                 style: TextStyle(color: Colors.black38),
                //               )
                //             ],
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                new ListTile(
                    leading: new Icon(Icons.category),
                    title: new Text('Category'),
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage()),
                          )
                        }),
                !isLoggedin
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.list),
                        title: new Text('Orders'),
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderPage()),
                              )
                            }),
                !isLoggedin
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.shopping_cart),
                        title: new Text('Cart'),
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCartPage()),
                              )
                            }),
                !isLoggedin
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.local_activity),
                        title: new Text('Coupon'),
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllCouponPage()),
                              )
                            }),
                !isLoggedin
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.favorite),
                        title: new Text('Favourites'),
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavouritePage()),
                              )
                            }),
                // new ListTile(
                //     leading: new Icon(Icons.notifications),
                //     title: new Text('Notifications'),
                //     onTap: () => {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => NotifyPage()),
                //           )
                //         }),
                Container(
                    margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                    child: Divider()),
                //Divider(color: Colors.grey),
                new ListTile(
                  leading: new Icon(Icons.security),
                  title: new Text('Terms and Condition'),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TnCPage()),
                    )
                  },
                ),
                !isLoggedin
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.settings_power),
                        title: new Text('Logout'),
                        onTap: () => showMyDialog(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      drawer: drawer,
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      width: 30,
                      child: Image.asset('assets/logo.jpg')),
                  Text("Easy Shopping",
                      style: TextStyle(
                          color: subheader,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          actions: [
            userInfo == null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        notifCount = 0;
                        notification_count = "0";
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotifyPage(notifyList)),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.notifications, color: subheader),
                          ),
                          notifCount == 0
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 20),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(notification_count,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal)),
                                )
                        ],
                      ),
                    ),
                  ),
            isLoggedin
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = true;
                      });
                      getNotification();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.refresh_outlined, color: subheader),
                    ),
                  )
                : Container()
          ]),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isoffline
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/wireless.png",
                      width: 120,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        "No internet connected!",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ))
              : pageOptions[currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            primaryColor: mainheader,
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.grey[500]))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 20), title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: new Stack(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: new Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                ]),
                title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Icon(Icons.account_circle, size: 20)),
                title: SizedBox.shrink()),
            BottomNavigationBarItem(
                icon: new Stack(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: new Icon(
                      Icons.shopping_cart,
                      size: 20,
                    ),
                  ),
                  // currentIndex == 3
                  //     ? Container()
                  //     : pageDirect == ""
                  //         ? Positioned(
                  //             right: 0,
                  //             child: Container(
                  //               padding: EdgeInsets.only(
                  //                   top: 1, bottom: 1, right: 5, left: 5),
                  //               margin: EdgeInsets.only(
                  //                   right: 0, left: 0, bottom: 10),
                  //               decoration: BoxDecoration(
                  //                   color: Colors.transparent,
                  //                   borderRadius: BorderRadius.circular(15)),

                  //             ),
                  //           )
                  //         : Positioned(
                  //             right: 0,
                  //             child: Container(
                  //               padding: EdgeInsets.only(
                  //                   top: 1, bottom: 1, right: 5, left: 5),
                  //               margin: EdgeInsets.only(
                  //                   right: 0, left: 0, bottom: 10),
                  //               decoration: BoxDecoration(
                  //                   color: mainheader,
                  //                   borderRadius: BorderRadius.circular(15)),
                  //               child: Text(
                  //                 pageDirect,
                  //                 textAlign: TextAlign.start,
                  //                 style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 10,
                  //                     //fontFamily: 'Oswald',
                  //                     fontWeight: FontWeight.w400),
                  //               ),
                  //             ),
                  //           )
                ]),
                title: SizedBox.shrink()),
          ],
          onTap: (int _selectedPage) {
            setState(() {
              currentIndex = _selectedPage;
              selectedPage = _selectedPage;
            });
            //print(selectedPage);
          },
        ),
      ),
    );
  }
}
