import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/OrderCard/orderCard.dart';
import 'package:online_shopping/Cards/OrderCard/orderDetails.dart';
import 'package:online_shopping/MainScreens/OrderListPage/orderlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../../../main.dart';

class OrderPage extends StatefulWidget {
  final inv_id;
  OrderPage({this.inv_id});

  @override
  State<StatefulWidget> createState() {
    return OrderPageState();
  }
}

class OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "";
  bool _requireConsent = false;
  var orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (userInfo != null) {
      fetchOrder();
    }
  }

  Future<void> fetchOrder() async {
    final response = await http.post(ip + 'easy_shopping/order_details.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      var corderBody = json.decode(response.body);
      print(corderBody["order_list"]);
      setState(() {
        orderList = corderBody["order_list"];
      });
      print(orderList.length);

      if (widget.inv_id != "") {
        checkForInvID();
      }
    } else {
      throw Exception('Unable to fetch order from the REST API');
    }
  }

  checkForInvID() {
    for (int i = 0; i < orderList.length; i++) {
      if (widget.inv_id == orderList[i]["inv_id"]) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(orderList[i])),
        );
      }
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
                      Text("Order list",
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
          ////// <<<<< Order List >>>>> //////
          child: orderList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No orders available!"),
                  ),
                )
              : new ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      ////// <<<<< Order Card >>>>> //////
                      OrderCard(orderList[index]),
                  itemCount: orderList.length,
                ),
        ),
      ),
    );
  }
}
