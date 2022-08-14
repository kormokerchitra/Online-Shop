import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';

import '../../main.dart';

class TopRatedCard extends StatefulWidget {
  final prod_item;
  TopRatedCard({this.prod_item});

  @override
  _TopRatedCardState createState() => _TopRatedCardState();
}

class _TopRatedCardState extends State<TopRatedCard> {
  int discountPercent = 0, discountAmt = 0;
  String rating = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discountAmt = Utils().getProductDiscount(
        widget.prod_item["product_price"], widget.prod_item["prod_discount"]);

    double proRating = double.parse(widget.prod_item["prod_rating"]);
    rating = "${proRating.toStringAsFixed(2)}";
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailsPage(product_info: widget.prod_item)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            border: Border.all(width: 0.2, color: Colors.grey)),
        child: Container(
          width: 100,
          child: Column(
            children: <Widget>[
              Container(
                  height: 120,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: <Widget>[
                      Center(
                        child: widget.prod_item["product_img"] == ""
                            ? Image.asset('assets/product_back.jpg')
                            : CachedNetworkImage(
                                imageUrl:
                                    "${ip + widget.prod_item["product_img"]}",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: mainheader,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    ]),
                  )),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.prod_item["product_name"],
                //"${prodList[index]["product_name"]}",
                style: TextStyle(fontSize: 14, color: Colors.black38),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Row(
                        children: <Widget>[
                          //Icon(
                          //Icons.attach_money,
                          //color:
                          //discountAmt == 0 ? Colors.black87 : Colors.grey,
                          //size: discountAmt == 0 ? 18 : 14,
                          //),
                          Text(
                            //"100.50",
                            "Tk. ${widget.prod_item["product_price"]}",
                            //"${prodList[index]["product_price"]}/-",
                            style: TextStyle(
                                fontSize: discountAmt == 0 ? 13 : 12,
                                color: discountAmt == 0
                                    ? Colors.black87
                                    : Colors.grey,
                                decoration: discountAmt == 0
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              discountAmt == 0
                  ? Container()
                  : Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Row(
                              children: <Widget>[
                                //Icon(
                                //Icons.attach_money,
                                //color: Colors.black87,
                                //size: 16,
                                //),
                                Row(
                                  children: [
                                    Text(
                                      "Tk. $discountAmt",
                                      //"${prodList[index]["product_price"]}/-",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                    ),
                                    Text(
                                      " (${widget.prod_item["prod_discount"]}%)",
                                      //"${prodList[index]["product_price"]}/-",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              Container(
                margin: EdgeInsets.only(top: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: golden,
                      size: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      child: Text(
                        //"4 (3)",
                        "$rating (${widget.prod_item["rev_count"]})",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
