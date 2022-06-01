import 'dart:convert';
import 'dart:ui' as prefix0;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:online_shopping/MainScreens/Homepage/homepage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/OrderPage/orders.dart';
import 'package:online_shopping/MainScreens/OrderListPage/orderlist.dart';
import 'package:online_shopping/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutPageState();
  }
}

class CheckoutPageState extends State<CheckoutPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _reviewController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  String _debugLabelString = "",
      review = '',
      runningdate = '',
      place = "",
      phone = "",
      payment = "",
      user_id = "";
  var dday, finalDate;
  int val = 0, qtyProduct = 0;
  double discTotal = 0.0, subTotal = 0.0, couponPrice = 0.0, payablePrice = 0.0;
  DateTime _date = DateTime.now();
  bool placeEdit = false, phoneEdit = false, paymentChoose = false;
  var cartList = [], voucherList = [];

  @override
  void initState() {
    var now = new DateTime.now();
    runningdate = new DateFormat("yyyy-MM-dd").format(now);
    fetchCart();
    placeController.text = "${userInfo["address"]}";
    place = placeController.text;
    phoneController.text = "${userInfo["phone_num"]}";
    phone = phoneController.text;
    super.initState();
  }

  Future<void> fetchCart() async {
    totalPrice = 0.0;
    qtyProduct = 0;
    discTotal = 0;
    subTotal = 0;
    payablePrice = 0;
    cartList.clear();
    final response = await http.post(ip + 'easy_shopping/cart_list.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      var cartBody = json.decode(response.body);
      print("fetch cartList - ${cartBody["cart_list"]}");
      setState(() {
        cartList = cartBody["cart_list"];

        for (int i = 0; i < cartList.length; i++) {
          int qty = int.parse(cartList[i]["product_qnt"]);
          double price = double.parse(cartList[i]["product_price"]);
          double total = qty * price;
          totalPrice += total;
          qtyProduct += qty;

          double disc = double.parse(cartList[i]["prod_discount"]);
          double discPrice = total * (disc / 100);
          print("price - $total, discPrice - $discPrice");
          discTotal += discPrice;
        }
        print("totalPrice");
        print(totalPrice);

        subTotal = totalPrice - discTotal;
        payablePrice = subTotal + 100;
      });
      print(cartList.length);
    } else {
      throw Exception('Unable to fetch cart from the REST API');
    }
  }

  Future<void> fetchCouponAmount() async {
    if (_reviewController.text.isEmpty) {
      showAlert("Voucher code is empty");
    } else {
      final response = await http.post(ip + 'easy_shopping/voucher_apply.php',
          body: {"voucher_name": _reviewController.text});
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          var voucherBody = json.decode(response.body);
          voucherList = voucherBody["voucher_info"];

          for (int i = 0; i < voucherList.length; i++) {
            String voucherExpDate = voucherList[i]["vou_exp_date"];

            List expArr = voucherExpDate.split("-");
            String day = expArr[0];
            int dayInt = int.parse(day);
            String month = expArr[1];
            int monthInt = int.parse(month);
            String year = expArr[2];
            int yearInt = int.parse(year);

            final now = DateTime.now();
            final expirationDate = DateTime(yearInt, monthInt, dayInt);
            final bool isExpired = expirationDate.isBefore(now);

            if (!isExpired) {
              String voucherAmt = voucherList[i]["voucher_amount"];
              couponPrice = double.parse(voucherAmt);
              payablePrice = (subTotal - couponPrice) + 100;
            } else {
              showAlert("Voucher date expired!");
            }
          }
          _reviewController.clear();
          showSuccess("Voucher applied successfully!");
        });
      } else {
        throw Exception('Unable to fetch cart from the REST API');
      }
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1915),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        runningdate = new DateFormat("yyyy-MM-dd").format(picked);
      });
    }
  }

  int _rating = 0;

  void rate(int rating) {
    //Other actions based on rating such as api calls.
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context, "true");
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //backgroundColor: Theme.of(context).secondaryHeaderColor,
          backgroundColor: Colors.white,
          // title:
          //     Container(padding: EdgeInsets.all(10), color: mainheader, child: Icon(Icons.menu)),
          title: Center(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        BackButton(
                          onPressed: () {
                            Navigator.pop(context, "true");
                          },
                        ),
                        Text("Checkout",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     bottomSheetMenu();
                  //   },
                  //   child: Container(
                  //       padding: EdgeInsets.all(5),
                  //       //color: mainheader,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //         color: mainheader,
                  //         boxShadow: <BoxShadow>[
                  //           BoxShadow(
                  //             color: Colors.grey,
                  //             //offset: Offset(1.0, 6.0),
                  //             blurRadius: 2.0,
                  //           ),
                  //         ],
                  //       ),
                  //       child: Container(
                  //           child: Icon(
                  //         Icons.menu,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ))),
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: sub_white,
            //height: MediaQuery.of(context).size.height,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: 5, left: 20, right: 20, bottom: 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.white,
                          border: Border.all(width: 0.2, color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Deliver To",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 5, right: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          //color: Colors.grey[200],
                                          //padding: EdgeInsets.all(20),
                                          child: Text(
                                        "${userInfo["full_name"]}",
                                        style: TextStyle(color: Colors.black54),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 0, right: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.location_on,
                                                  color: Colors.grey, size: 16),
                                              Flexible(
                                                child: placeEdit == true
                                                    ? Container(
                                                        //height: 100,
                                                        child: new TextField(
                                                          maxLines: null,
                                                          autofocus: true,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Oswald',
                                                          ),
                                                          controller:
                                                              placeController,
                                                          decoration:
                                                              InputDecoration(
                                                            alignLabelWithHint:
                                                                true,
                                                            hintText:
                                                                "Place name",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        5.0,
                                                                        10.0,
                                                                        20.0,
                                                                        10.0),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              place = value;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          place == ""
                                                              ? "Add Address"
                                                              : place,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (placeEdit == true) {
                                              placeEdit = false;
                                            } else {
                                              placeEdit = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              placeEdit == true
                                                  ? "Done"
                                                  : "Edit",
                                              style:
                                                  TextStyle(color: mainheader),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 0, right: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(Icons.phone,
                                                  color: Colors.grey, size: 16),
                                              Flexible(
                                                child: phoneEdit == true
                                                    ? Container(
                                                        //height: 100,
                                                        child: new TextField(
                                                          maxLines: null,
                                                          autofocus: true,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Oswald',
                                                          ),
                                                          controller:
                                                              phoneController,
                                                          decoration:
                                                              InputDecoration(
                                                            alignLabelWithHint:
                                                                true,
                                                            hintText:
                                                                "Phone number",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        5.0,
                                                                        10.0,
                                                                        20.0,
                                                                        10.0),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              phone = value;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          phone == ""
                                                              ? "Contact Name"
                                                              : phone,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (phoneEdit == true) {
                                              phoneEdit = false;
                                            } else {
                                              phoneEdit = true;
                                            }
                                          });
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              phoneEdit == true
                                                  ? "Done"
                                                  : "Edit",
                                              style:
                                                  TextStyle(color: mainheader),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, right: 5, bottom: 3),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          //color: Colors.grey[200],
                                          //padding: EdgeInsets.all(20),
                                          child: Text(
                                        "Delivery Date",
                                        style: TextStyle(color: Colors.black54),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 0, right: 5, bottom: 5),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.calendar_today,
                                                color: Colors.grey, size: 16),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  runningdate,
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _selectDate(context);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Choose",
                                              style:
                                                  TextStyle(color: mainheader),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Product List",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: List.generate(cartList.length, (index) {
                              return Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "${cartList[index]["product_name"]}",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              String qnt = cartList[index]
                                                  ["product_qnt"];
                                              val = int.parse(qnt);
                                              val--;
                                              if (val <= 0) {
                                                val = 1;
                                              }
                                              print(val);
                                              cartList[index]["product_qnt"] =
                                                  "$val";
                                              print("cartList - $cartList");

                                              updateCart(
                                                  cartList[index]["cart_id"],
                                                  cartList[index]
                                                      ["product_qnt"]);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[500]),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(
                                                left: 3, right: 10),
                                            child: Icon(Icons.remove,
                                                size: 15,
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Text(
                                          "${cartList[index]["product_qnt"]}",
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              int qty = int.parse(
                                                  cartList[index]
                                                      ["main_product_qnt"]);
                                              String qnt = cartList[index]
                                                  ["product_qnt"];
                                              val = int.parse(qnt);
                                              val++;
                                              print(val);
                                              if (val > qty) {
                                                showAlert("No more products");
                                              } else {
                                                cartList[index]["product_qnt"] =
                                                    "$val";
                                                print("cartList - $cartList");

                                                updateCart(
                                                    cartList[index]["cart_id"],
                                                    cartList[index]
                                                        ["product_qnt"]);
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey[500]),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.all(2),
                                            margin: EdgeInsets.only(
                                                left: 10, right: 3),
                                            child: Icon(Icons.add,
                                                size: 15,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Apply Coupon",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  child: TextField(
                                    autofocus: false,
                                    controller: _reviewController,
                                    decoration: InputDecoration(
                                        hintText: "Type coupon number..."),
                                    onChanged: (value) {
                                      review = value;
                                    },
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  fetchCouponAmount();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: mainheader,
                                        border: Border.all(
                                            width: 0.2, color: Colors.grey)),
                                    child: Text(
                                      "Apply",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Shopping Details",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Total Products",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Text(
                                      qtyProduct.toString(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.black54),
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Total Price",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Tk. " +
                                              totalPrice.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Discount",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(Icons.remove,
                                            size: 15, color: mainheader),
                                        Text(
                                          "Tk. " + discTotal.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: mainheader),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Sub Total",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        //Icon(Icons.attach_money,
                                        //size: 15, color: Colors.black54),
                                        Text(
                                          "Tk. " + subTotal.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Coupon Discount",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Icon(Icons.remove,
                                            size: 15, color: mainheader),
                                        Text(
                                          "Tk. " +
                                              couponPrice.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: mainheader),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Shipping Cost",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Tk. 100.00",
                                          textAlign: TextAlign.start,
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        //color: Colors.grey[200],
                                        //padding: EdgeInsets.all(20),
                                        child: Text(
                                      "Total Payable",
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                    Container(
                                        child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Tk. " +
                                              payablePrice.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Payment Details",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, right: 5, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, right: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              //color: Colors.grey[200],
                                              //padding: EdgeInsets.all(20),
                                              child: Text(
                                            "Bkash Payment",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, right: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.credit_card,
                                                    color: Colors.grey,
                                                    size: 16),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "01786273137",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //paymentSelect();
                                              setState(() {
                                                paymentChoose = false;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: paymentChoose == false
                                                      ? mainheader
                                                      : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                padding: EdgeInsets.all(2),
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Icon(Icons.done,
                                                    color:
                                                        paymentChoose == false
                                                            ? Colors.white
                                                            : Colors.grey,
                                                    size: 15)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, right: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              //color: Colors.grey[200],
                                              //padding: EdgeInsets.all(20),
                                              child: Text(
                                            "Cash on delivery",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0, right: 5, bottom: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,
                                                    color: Colors.grey,
                                                    size: 16),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      place == ""
                                                          ? "N/A"
                                                          : place,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              //paymentSelect();
                                              setState(() {
                                                paymentChoose = true;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: paymentChoose == true
                                                      ? mainheader
                                                      : Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                                padding: EdgeInsets.all(2),
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Icon(Icons.done,
                                                    color: paymentChoose == true
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    size: 15)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      submitOrder();
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: mainheader,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Text(
                          "Submit Order",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void paymentSelect() {
    if (paymentChoose == false) {
      setState(() {
        paymentChoose = true;
      });
    } else {
      setState(() {
        paymentChoose = false;
      });
    }
  }

  showAlert(String msg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(msg,
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  showSuccess(String msg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(msg,
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  Future<void> submitOrder() async {
    if (placeController.text.isEmpty) {
      showAlert("Please provide your address");
    } else if (phoneController.text.isEmpty) {
      showAlert("Please provide your phone number");
    } else if (phoneController.text.length < 11) {
      showAlert("Please provide valid phone number");
    } else {
      print("cart delete");
      final response =
          await http.post(ip + 'easy_shopping/order_submit.php', body: {
        "user_id": "${userInfo["user_id"]}",
        "total_product": qtyProduct.toString(),
        "total_price": totalPrice.toString(),
        "prod_discount": discTotal.toString(),
        "sub_total": subTotal.toString(),
        "coupon_discount": couponPrice.toString(),
        "shipping_cost": "100",
        "total_payable": payablePrice.toString(),
        "payment_method": paymentChoose ? "Cash" : "Bkash",
        "address": placeController.text,
        "phon_number": phoneController.text,
        "delivery_date": runningdate,
      });
      print(response.statusCode);
      print("order_id check - ${response.body}");
      if (response.statusCode == 200) {
        String order_id = response.body;
        showSuccess(
            "Order placed successfully. Go to orders section to find your order.");
        for (int i = 0; i < cartList.length; i++) {
          int qty = int.parse(cartList[i]["product_qnt"]);
          String id = cartList[i]["prod_id"];
          addProductToCheckout(id, qty, order_id);
        }
        deleteCart();
      } else {
        throw Exception('Unable to add order from the REST API');
      }
    }
  }

  Future<void> updateCart(String cart_id, String num) async {
    print("cart update");
    final response = await http.post(ip + 'easy_shopping/cart_edit.php', body: {
      "cart_id": cart_id,
      "product_qnt": num,
    });
    print(response.body);
    if (response.statusCode == 200) {
      fetchCart();
    } else {
      throw Exception('Unable to add cart from the REST API');
    }
  }

  Future<void> addProductToCheckout(String id, int qty, String order_id) async {
    final response =
        await http.post(ip + "easy_shopping/order_product_add.php", body: {
      "prod_id": id,
      "product_count": qty.toString(),
      "user_id": "${userInfo["user_id"]}",
      "order_id": order_id,
    });

    print("sts code stock - ${response.statusCode}");
    if (response.statusCode == 200) {
      stockClearance(id, qty);
    } else {
      throw Exception('Unable to add order from the REST API');
    }
  }

  Future<void> stockClearance(String id, int qty) async {
    final response =
        await http.post(ip + "easy_shopping/stock_clearance.php", body: {
      "prod_id": id,
      "product_qnt": qty.toString(),
    });

    print("sts code stock - ${response.statusCode}");
    if (response.statusCode == 200) {
    } else {
      throw Exception('Unable to add order from the REST API');
    }
  }

  Future<void> deleteCart() async {
    final response =
        await http.post(ip + "easy_shopping/cart_delete_with_user.php", body: {
      "user_id": "${userInfo["user_id"]}",
    });

    print("sts code stock - ${response.statusCode}");
    if (response.statusCode == 200) {
      selectedPage = 0;
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      throw Exception('Unable to add order from the REST API');
    }
  }
}
