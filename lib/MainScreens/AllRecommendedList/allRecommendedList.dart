import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/Cards/AllProductCard/allProductCard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../main.dart';

class AllRecommendedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllRecommendedPageState();
  }
}

class AllRecommendedPageState extends State<AllRecommendedPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  int count = 0;
  var prodList = [];

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final response = await http.get(ip + 'easy_shopping/product_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["product_list"]);
      setState(() {
        for (int i = 0; i < productBody["product_list"].length; i++) {
          double rating =
              double.parse(productBody["product_list"][i]["prod_rating"]);
          if (rating >= 4) {
            prodList.add(productBody["product_list"][i]);
          }
        }
      });
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
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
                      Text("Recommended List",
                          //widget.cat_name,
                          //"${prodList[index]["cat_name"]}",
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
        //height: MediaQuery.of(context).size.height,
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 0, top: 0),
          color: sub_white,
          width: MediaQuery.of(context).size.width,
          child: prodList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No data available!"),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return AllProductCard(prod_item: prodList[index]);
                  },
                  itemCount: prodList.length,
                ),
        ),
      ),
    );
  }
}
