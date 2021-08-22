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
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final response = await http.get(ip + 'easy_shopping/favourite_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["favourite_list"]);
      setState(() {
        for (int i = 0; i < productBody["favourite_list"].length; i++) {
          if (userID == productBody["favourite_list"][i]["user_id"]) {
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
          child: new ListView.builder(
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
