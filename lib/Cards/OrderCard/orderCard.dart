import 'package:flutter/material.dart';
import 'package:online_shopping/Cards/OrderCard/orderDetails.dart';
import 'package:online_shopping/MainScreens/OrderListPage/orderlist.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class OrderCard extends StatefulWidget {
  final order_item;
  OrderCard(this.order_item);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  double amt = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amt = double.parse(widget.order_item["total_payable"]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailsPage(widget.order_item)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "#${widget.order_item["inv_id"]}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Order by ${widget.order_item["full_name"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.shopping_basket,
                                        color: Colors.grey,
                                        size: 17,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        "${widget.order_item["total_product"]} Items",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Total price: Tk. ${amt.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 15, color: mainheader),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Date: ${widget.order_item["delivery_date"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
