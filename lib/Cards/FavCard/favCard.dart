import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/Homepage/homepage.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';
import '../../main.dart';

class FavCard extends StatefulWidget {
  final fav_item;
  FavCard(this.fav_item);

  @override
  _FavCardState createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
  int discountPercent = 0, discountAmt = 0;
  String rating = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discountAmt = Utils().getProductDiscount(
        widget.fav_item["product_price"], widget.fav_item["prod_discount"]);
    double proRating = double.parse(widget.fav_item["prod_rating"]);
    rating = "${proRating.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    width: 80,
                    child: widget.fav_item["product_img"] == ""
                        ? Image.asset('assets/product_back.jpg')
                        : CachedNetworkImage(
                            imageUrl: "${ip + widget.fav_item["product_img"]}",
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.fav_item["product_name"],
                          //"${prodList[index]["product_name"]}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
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
                                  "$rating",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  //Icon(
                                  //Icons.attach_money,
                                  //color: Colors.black87,
                                  //size: 18,
                                  //),
                                  discountAmt == 0
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: Text(
                                            "Tk. $discountAmt",
                                            style: TextStyle(
                                                fontSize:
                                                    discountAmt == 0 ? 16 : 13,
                                                color: discountAmt == 0
                                                    ? Colors.black87
                                                    : Colors.grey,
                                                decoration: discountAmt == 0
                                                    ? TextDecoration.none
                                                    : TextDecoration
                                                        .lineThrough),
                                          ),
                                        ),
                                  Text(
                                    "Tk. ${widget.fav_item["product_price"]}",
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
                        )

                        //discountAmt == 0
                        //? Container()
                        //: Container(
                        //child: Row(
                        //mainAxisAlignment:
                        //MainAxisAlignment.start,
                        //children: <Widget>[
                        //Container(
                        //margin: EdgeInsets.only(top: 0),
                        //child: Row(
                        //children: <Widget>[
                        // Icon(
                        //   Icons.attach_money,
                        //   color: Colors.black87,
                        //   size: 16,
                        // ),
                        //Row(
                        //children: [
                        //Text(
                        //"Tk. $discountAmt",
                        //"${prodList[index]["product_price"]}/-",
                        //style: TextStyle(
                        //fontSize: 16,
                        //color: Colors.black87),
                        //),
                        //Text(
                        //" (${widget.fav_item["prod_discount"]}%)",
                        //"${prodList[index]["product_price"]}/-",
                        //style: TextStyle(
                        //fontSize: 13,
                        //color: Colors.black87),
                        //),
                        //],
                        //),
                        //],
                        //),
                        //),
                        //],
                        //),
                        //),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showMyDialog();
              },
              child: Container(
                  margin: EdgeInsets.only(right: 3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Do you want to delete from favourite list?'),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text('No')),
              ),
            ),
            GestureDetector(
              onTap: () {
                deleteFavlist();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text('Yes')),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteFavlist() async {
    final response =
        await http.post(ip + 'easy_shopping/favourite_delete.php', body: {
      "user_id": "${userInfo["user_id"]}",
      "prod_id": widget.fav_item["prod_id"],
    });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        if (response.body == "Success") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {}
      });
    } else {
      throw Exception('Unable to fetch favourite products from the REST API');
    }
  }
}
