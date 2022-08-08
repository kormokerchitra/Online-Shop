import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/Cards/AllProductCard/allProductCard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../main.dart';

class AllTrendingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllTrendingPageState();
  }
}
class AllTrendingPageState extends State<AllTrendingPage>
    with SingleTickerProviderStateMixin {
      Animation<double> animation;
  AnimationController controller;
  int count = 0;
  var orderProductList = [],
      tempProductList = [];

  @override
  void initState() {
    super.initState();
    fetchOrderProduct();
  }

  Future<void> fetchOrderProduct() async {
    final response = await http.get(ip + 'easy_shopping/order_product_all.php');
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["list"]);
      setState(() {
        for (int i = 0; i < productBody["list"].length; i++) {
          if (!tempProductList.contains(productBody["list"][i]["prod_id"])) {
            tempProductList.add(productBody["list"][i]["prod_id"]);
          }
        }
      });
      print("tempProductList");
      print(tempProductList);

      for (int i = 0; i < tempProductList.length; i++) {
        String id = tempProductList[i];
        final response1 = await http.post(
            ip + 'easy_shopping/order_product_count.php',
            body: {"prod_id": "$id"});
        print(id);
        if (response1.statusCode == 200) {
          print(response1.body);
          var dataCount = json.decode(response1.body);
          print("$id / $dataCount");

          final response = await http.post(
              ip + 'easy_shopping/product_search.php',
              body: {"product_name": "$id"});
          print(id);
          if (response.statusCode == 200) {
            print(response.body);
            productBody = json.decode(response.body);
            print(productBody["product_list"]);
            setState(() {
              int cc = productBody["product_list"].length;
              print("cc");
              print(cc);
              orderProductList.add({
                "fullBody": productBody["product_list"][0],
                "count": dataCount
              });
            });
          } else {
            throw Exception('Unable to fetch products from the REST API');
          }
        } else {
          throw Exception('Unable to fetch products from the REST API');
        }
      }

      orderProductList.sort((a, b) => b["count"].compareTo(a["count"]));
      print("orderProductList");
      print(orderProductList);
    } else {
      throw Exception('Unable to fetch category from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                      Text("Top Selling Products",
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
          child: orderProductList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No data available!"),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return AllProductCard(prod_item: orderProductList[index]["fullBody"]);
                  },
                  itemCount: orderProductList.length,
                ),
        ),
      ),
    );
  }
}
