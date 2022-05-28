import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';
import '../../main.dart';

class OrderDetailsPage extends StatefulWidget {
  final orderDetails;
  OrderDetailsPage(this.orderDetails);

  @override
  State<StatefulWidget> createState() {
    return OrderDetailsPageState();
  }
}

class OrderDetailsPageState extends State<OrderDetailsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _reviewController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "", review = '', runningdate = '', statustxt = "";
  bool _requireConsent = false;
  var dd, finalDate;
  DateTime _date = DateTime.now();
  List statusList = [
    "Processing",
    "Picked",
    "Shipped",
    "Delivered",
    "Cancelled"
  ];
  List productList = [];
  double totalPrice = 0.0,
      discTotal = 0.0,
      subTotal = 0.0,
      couponPrice = 0.0,
      shippingCost = 0.0,
      amt = 0.0;

  @override
  void initState() {
    // runningdate = _formatDateTime1(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getDate());
    var now = new DateTime.now();
    runningdate = new DateFormat("dd-MM-yyyy").format(now);
    statustxt = widget.orderDetails["status"];
    super.initState();

    totalPrice = double.parse(widget.orderDetails["total_price"]);
    discTotal = double.parse(widget.orderDetails["prod_discount"]);
    subTotal = double.parse(widget.orderDetails["sub_total"]);
    couponPrice = double.parse(widget.orderDetails["coupon_discount"]);
    shippingCost = double.parse(widget.orderDetails["shipping_cost"]);
    amt = double.parse(widget.orderDetails["total_payable"]);

    fetchOrderProduct();
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final String formattedDateTime1 = _formatDateTime1(now);
    setState(() {
      runningdate = formattedDateTime1;
    });
  }

  String _formatDateTime1(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1915),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      dd = DateTime.parse(_date.toString());
      finalDate = "${dd.day}-${dd.month}-${dd.year}";
      runningdate = finalDate.toString();
      //print('Birth Date : $finalDate');
      //print('Birth Date : $date');
      setState(() {
        _date = picked;
        var dd1 = DateTime.parse(_date.toString());
        var finalDate1 = "${dd1.day}-${dd1.month}-${dd1.year}";
        runningdate = finalDate1.toString();
        // DateTime dateTime = DateTime.parse(date);
        // Fluttertoast.showToast(msg: dateTime.toString(),toastLength: Toast.LENGTH_SHORT);
        // _date = dateTime;
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

  Future<void> fetchOrderProduct() async {
    final response = await http
        .post(ip + 'easy_shopping/order_product_by_id.php', body: {
      "order_id": widget.orderDetails["order_id"],
      "user_id": "${userInfo["user_id"]}"
    });
    if (response.statusCode == 200) {
      print(response.body);
      var reviewBody = json.decode(response.body);
      print(reviewBody["list"]);
      setState(() {
        productList = reviewBody["list"];
      });
      print(productList.length);
    } else {
      throw Exception('Unable to fetch reviews from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
        title: Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Order Details",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: mainheader),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    statustxt,
                    style: TextStyle(fontSize: 12, color: mainheader),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: sub_white,
          //height: MediaQuery.of(context).size.height,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // GestureDetector(
                //   onTap: () {
                //     viewProducts();
                //   },
                //   child: Container(
                //       width: MediaQuery.of(context).size.width,
                //       margin: EdgeInsets.only(
                //           top: 5, left: 20, right: 20, bottom: 5),
                //       padding: EdgeInsets.all(15),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //           color: Colors.white,
                //           border: Border.all(width: 0.2, color: Colors.grey)),
                //       child: Column(
                //         children: <Widget>[
                //           Text(
                //             "View Products",
                //             style: TextStyle(
                //                 fontSize: 17,
                //                 color: mainheader,
                //                 fontWeight: FontWeight.bold),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       )),
                // ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Delivered To",
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
                                      widget.orderDetails["full_name"],
                                      style: TextStyle(color: Colors.black54),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0, right: 5, bottom: 5),
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
                                          Icon(Icons.location_on,
                                              color: Colors.grey, size: 16),
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                widget.orderDetails["address"],
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0, right: 5, bottom: 5),
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
                                          Icon(Icons.phone,
                                              color: Colors.grey, size: 16),
                                          Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                widget.orderDetails[
                                                    "phon_number"],
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )),
                                        ],
                                      ),
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
                          padding: EdgeInsets.only(top: 0, right: 5, bottom: 5),
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
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                widget.orderDetails[
                                                    "delivery_date"],
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              )),
                                        ],
                                      ),
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
                          children: List.generate(productList.length, (index) {
                            int discountAmt = Utils().getProductDiscount(
                                productList[index]["product_price"],
                                productList[index]["prod_discount"]);
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
                                    "${productList[index]["product_name"]}",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Row(
                                    children: <Widget>[
                                      Text(
                                        "${productList[index]["product_count"]}",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Text(
                                        " * ",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Text(
                                        discountAmt == 0
                                            ? "${productList[index]["product_price"]}"
                                            : "$discountAmt",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
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
                                    "Invoice ID",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Text(
                                    "#${widget.orderDetails["inv_id"]}",
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
                                    "Total Products",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Text(
                                    widget.orderDetails["total_product"],
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
                                      //Icon(Icons.attach_money,
                                      //size: 15, color: Colors.black54),
                                      Text(
                                        "Tk. ${totalPrice.toStringAsFixed(2)}",
                                        //"Tk. " + widget.orderDetails["total_price"],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
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
                                      //Icon(Icons.attach_money,
                                      //size: 15, color: mainheader),
                                      Text(
                                        "Tk. ${discTotal.toStringAsFixed(2)}",
                                        //"Tk. " + widget.orderDetails["prod_discount"],
                                        //"${prodList[index]["prod_discount"]}",
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
                                        "Tk. ${subTotal.toStringAsFixed(2)}",
                                        //"Tk. " + widget.orderDetails["sub_total"],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
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
                                      //Icon(Icons.attach_money,
                                      //size: 15, color: mainheader),
                                      Text(
                                        "Tk. ${couponPrice.toStringAsFixed(2)}",
                                        //"Tk. " + widget.orderDetails["coupon_discount"],
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
                                      //Icon(Icons.attach_money,
                                      //size: 15, color: Colors.black54),
                                      Text(
                                        "Tk. ${shippingCost.toStringAsFixed(2)}",
                                        //"Tk. " + widget.orderDetails["shipping_cost"],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Colors.black54),
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
                                      //Icon(Icons.attach_money,
                                      //size: 15, color: Colors.black),
                                      Text(
                                        //"Tk. " + widget.orderDetails["total_payable"],
                                        //"Tk. ${widget.product_info["total_payable"]}",
                                        "Tk. ${amt.toStringAsFixed(2)}",
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
                        "Payment Method",
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
                              padding:
                                  EdgeInsets.only(top: 0, right: 5, bottom: 5),
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
                                          widget.orderDetails["payment_method"],
                                          style: TextStyle(color: Colors.grey),
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}
