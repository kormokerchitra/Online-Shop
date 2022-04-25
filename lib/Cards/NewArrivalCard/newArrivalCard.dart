import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';

import '../../main.dart';

class NewArrivalCard extends StatefulWidget {
  final prod_item;
  NewArrivalCard(this.prod_item);

  @override
  _NewArrivalCardState createState() => _NewArrivalCardState();
}

class _NewArrivalCardState extends State<NewArrivalCard> {
  int discountPercent = 0, discountAmt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discountAmt = Utils().getProductDiscount(
        widget.prod_item["product_price"], widget.prod_item["prod_discount"]);
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
                            : Image.asset('assets/product_back.jpg'),
                      ),
                      Container(
                          padding: EdgeInsets.all(5),
                          //color: mainheader,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: mainheader,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child:
                              Text("New", style: TextStyle(color: sub_white)))
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
                                // Icon(
                                //   Icons.attach_money,
                                //   color: Colors.black87,
                                //   size: 16,
                                // ),
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
                        "${widget.prod_item["prod_rating"]}",
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
