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
  var prodList = [],
      tempRecommendedList = [], recomList = [];

  @override
  void initState() {
    super.initState();
    fetchRecommended();
  }

  Future<void> fetchRecommended() async {
    final response = await http.post(
        ip + 'easy_shopping/keyword_product_list.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["product_key_list"]);
      for (int i = 0; i < productBody["product_key_list"].length; i++) {
        if (!tempRecommendedList
            .contains(productBody["product_key_list"][i]["prod_id"])) {
          tempRecommendedList
              .add(productBody["product_key_list"][i]["prod_id"]);
        }
      }

      print("tempRecommendedList");
      print(tempRecommendedList);

      for (int i = 0; i < tempRecommendedList.length; i++) {
        String id = tempRecommendedList[i];
        print("proid - $id");
        final response = await http.post(
            ip + 'easy_shopping/product_search_id.php',
            body: {"product_name": "$id"});
        print(id);
        if (response.statusCode == 200) {
          print(response.body);
          productBody = json.decode(response.body);
          print(productBody["product_list"]);
          setState(() {
            recomList.add(productBody["product_list"][0]);
          });
        } else {
          throw Exception('Unable to fetch products from the REST API');
        }

        print("recomList - ${recomList[i]}");
      }
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
                      Text("Recommended Products",
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
          child: recomList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No data available!"),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return AllProductCard(prod_item: recomList[index]);
                  },
                  itemCount: recomList.length,
                ),
        ),
      ),
    );
  }
}
