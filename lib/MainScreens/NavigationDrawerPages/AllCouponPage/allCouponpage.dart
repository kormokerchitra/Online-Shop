import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shopping/main.dart';

class AllCouponPage extends StatefulWidget {
  @override
  _AllCouponPageState createState() => _AllCouponPageState();
}

class _AllCouponPageState extends State<AllCouponPage> {
  bool isAvailableClicked = true;

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
                      Text("Coupon",
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
                          "Available",
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
                          "Used",
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
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: isAvailableClicked
                  ? Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: List.generate(10, (index) {
                          return Container(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "#V383434987V",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Discount amount: 100/-",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Date: 12-09-2021",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Available",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: "V383434987V"));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.copy,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: List.generate(10, (index) {
                          return Container(
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "#V383434987V",
                                            style: TextStyle(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Discount amount: 100/-",
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              "Date: 12-09-2021",
                                              style: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Used",
                                        style: TextStyle(
                                            color: Colors.redAccent.withOpacity(0.7),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
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
}
