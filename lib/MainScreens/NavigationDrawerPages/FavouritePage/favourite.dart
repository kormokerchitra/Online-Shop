import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/FavCard/favCard.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavouritePageState();
  }
}

class FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "";
  bool _requireConsent = false;
  var prodList = [];

  @override
  void initState() {
    super.initState();
    if (userInfo != null) {
      fetchFavlist();
    }
  }

  Future<void> fetchFavlist() async {
    final response = await http.post(ip + 'easy_shopping/favourite_list.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["favourite_list"]);
      setState(() {
        for (int i = 0; i < productBody["favourite_list"].length; i++) {
          if ("${userInfo["user_id"]}" ==
              productBody["favourite_list"][i]["user_id"]) {
            prodList.add(productBody["favourite_list"][i]);
          }
        }
      });
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch favourite products from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Favourite",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: sub_white,
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 0),
          color: sub_white,
          width: MediaQuery.of(context).size.width,
          ////// <<<<< Favorites List >>>>> //////
          child: prodList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No products added to favourite!"),
                  ),
                )
              : new ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      ////// <<<<< Favorites Card >>>>> //////
                      FavCard(prodList[index]),
                  itemCount: prodList.length,
                ),
        ),
      ),
    );
  }
}
