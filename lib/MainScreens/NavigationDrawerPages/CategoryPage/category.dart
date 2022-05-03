import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/AllCategoryCard/allCategoryCard.dart';
import 'package:online_shopping/MainScreens/AllProductPage/allProductPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "";
  bool _requireConsent = false;
  var categoryList = [];

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    final response = await http.get(ip + 'easy_shopping/category_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var categoryBody = json.decode(response.body);
      print(categoryBody["cat_list"]);
      setState(() {
        categoryList = categoryBody["cat_list"];
      });
      print(categoryList.length);
    } else {
      throw Exception('Unable to fetch category from the REST API');
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
                      Text("Category List",
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
          margin: EdgeInsets.only(left: 0, right: 0),
          color: sub_white,
          width: MediaQuery.of(context).size.width,
          ////// <<<<< All Category List >>>>> //////
          child: new ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ////// <<<<< All Category Card >>>>> //////
                AllCategoryCard(categoryList[index]),
            itemCount: categoryList.length,
          ),
        ),
      ),
    );
  }
}
