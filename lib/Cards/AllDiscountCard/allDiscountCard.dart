import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class AllDiscountCard extends StatefulWidget {
  final prod_item;
  AllDiscountCard({this.prod_item});

  @override
  _AllDiscountCardState createState() => _AllDiscountCardState();
}

class _AllDiscountCardState extends State<AllDiscountCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DetailsPage(product_info: widget.prod_item)),
          );
        },
        child: Container(
          //children: List.generate(prodList.length, (index) {
          //return prodList[index]["prod_id"] == widget.prod_id
          //? Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(1.0)),
              color: Colors.white,
              border: Border.all(width: 0.2, color: Colors.grey)),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  // color: Colors.red,
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10, left: 0),
                          height: 90,
                          child: widget.prod_item["product_img"] == ""
                              ? Image.asset('assets/product_back.jpg')
                              : Image.asset('assets/product_back.jpg')),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.prod_item["product_name"],
                              //"${prodList[index]["product_name"]}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: golden,
                                    size: 17,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: Text(
                                      "${widget.prod_item["prod_rating"]}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.attach_money,
                                        color: Colors.black87,
                                        size: 18,
                                      ),
                                      Text(
                                        "${widget.prod_item["product_price"]}/-",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Icon(
                                  //   Icons.delete,
                                  //   color: Colors.grey,
                                  //   size: 23,
                                  // ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                    "Expiry Date: ${widget.prod_item["prod_disc_date"]}",
                                    style: TextStyle(color: subheader, fontSize: 11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: subheader,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: 3),
                          child: Text(
                            "${widget.prod_item["prod_discount"]}%",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        // Container(
                        //   color: Colors.white,
                        //   child: Icon(
                        //     Icons.chevron_right,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    )),
              ],
            ),
          ),
          //),
        ),
      ),
    );
  }
}
