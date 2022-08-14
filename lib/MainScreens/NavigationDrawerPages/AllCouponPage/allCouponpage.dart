import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/main.dart';
import 'package:http/http.dart' as http;

class AllCouponPage extends StatefulWidget {
  @override
  _AllCouponPageState createState() => _AllCouponPageState();
}

class _AllCouponPageState extends State<AllCouponPage> {
  bool isAvailableClicked = true;
  TextEditingController vNameController = new TextEditingController();
  TextEditingController vNameController1 = new TextEditingController();
  TextEditingController vDateController = new TextEditingController();
  TextEditingController vDateController1 = new TextEditingController();
  TextEditingController vAmtController = new TextEditingController();
  TextEditingController vAmtController1 = new TextEditingController();
  TextEditingController vExpAmtController = new TextEditingController();
  TextEditingController vExpAmtController1 = new TextEditingController();
  TextEditingController vStatusController1 = new TextEditingController();
  List couponListActive = [], couponListUsed = [];
  bool isLoading = true;
  String runningdate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = new DateTime.now();
    runningdate = new DateFormat("yyyy-MM-dd").format(now);
    fetchCoupon();
  }

  Future<void> fetchCoupon() async {
    couponListActive.clear();
    couponListUsed.clear();
    final response = await http.get(ip + 'easy_shopping/voucher_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var couponBody = json.decode(response.body);
      print(couponBody["voucher_list"]);
      setState(() {
        var couponList = couponBody["voucher_list"];
        for (int i = 0; i < couponList.length; i++) {
          String voucherExpDate = couponList[i]["vou_exp_date"];
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
          if (couponList[i]["voucher_status"] == "1" && !isExpired) {
            couponListActive.add(couponList[i]);
          } else {
            couponListUsed.add(couponList[i]);
          }
        }
        isLoading = false;
      });
      print("used : " + couponListUsed.length.toString());
    } else {
      throw Exception('Unable to fetch voucher from the REST API');
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
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Voucher/Coupon List",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAvailableClicked = true;
                    });
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isAvailableClicked ? subheader : sub_white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        border: Border.all(
                            width: 0.5,
                            color:
                                isAvailableClicked ? subheader : Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Active",
                          style: TextStyle(
                              color: isAvailableClicked
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAvailableClicked = false;
                    });
                  },
                  child: Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: !isAvailableClicked ? subheader : sub_white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        border: Border.all(
                            width: 0.5,
                            color:
                                !isAvailableClicked ? subheader : Colors.grey)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Inactive",
                          style: TextStyle(
                              color: !isAvailableClicked
                                  ? Colors.white
                                  : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isAvailableClicked
                    ? couponListActive.length == 0
                        ? Center(child: Text("No data available!"))
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                children: List.generate(couponListActive.length,
                                    (index) {
                                  return Container(
                                    child: Card(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "#${couponListActive[index]["voucher_name"]}",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Amount: Tk. ${couponListActive[index]["voucher_amount"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Expire Date: ${couponListActive[index]["vou_exp_date"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Expected Amount: Tk. ${couponListActive[index]["voucher_exp_amount"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Text(
                                                //   "Active",
                                                //   style: TextStyle(
                                                //       color: Colors.green,
                                                //       fontWeight:
                                                //           FontWeight.normal),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(ClipboardData(
                                                        text: couponListActive[
                                                                index]
                                                            ["voucher_name"]));
                                                    copyMsg();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.copy,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                    : couponListUsed.length == 0
                        ? Center(child: Text("No data available!"))
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: Column(
                                children: List.generate(couponListUsed.length,
                                    (index) {
                                  return Container(
                                    child: Card(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "#${couponListUsed[index]["voucher_name"]}",
                                                    style: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Amount: Tk. ${couponListUsed[index]["voucher_amount"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Expire Date: ${couponListUsed[index]["vou_exp_date"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Voucher Expected Amount: Tk. ${couponListUsed[index]["voucher_exp_amount"]}",
                                                      style: TextStyle(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.end,
                                            //   children: [
                                            //     Container(
                                            //       child: Text(
                                            //         "Inactive",
                                            //         style: TextStyle(
                                            //             color: Colors.redAccent
                                            //                 .withOpacity(0.7),
                                            //             fontWeight:
                                            //                 FontWeight.normal),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
          )
        ],
      ),
    );
  }

  copyMsg() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 100.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: new Center(
                  child: new Text("Copied"),
                )),
          );
        });
  }
}
