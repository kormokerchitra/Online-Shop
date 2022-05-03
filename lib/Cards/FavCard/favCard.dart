import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/Homepage/homepage.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class FavCard extends StatefulWidget {
  final fav_item;
  FavCard(this.fav_item);

  @override
  _FavCardState createState() => _FavCardState();
}

class _FavCardState extends State<FavCard> {
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
                      child: widget.fav_item["product_img"] == ""
                          ? Image.asset('assets/product_back.jpg')
                          : Image.asset('assets/product_back.jpg')),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.fav_item["product_name"],
                          //"${prodList[index]["product_name"]}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.black54),
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
                                  "${widget.fav_item["prod_rating"]}",
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
                                  Icon(
                                    Icons.attach_money,
                                    color: Colors.black87,
                                    size: 18,
                                  ),
                                  Text(
                                    "${widget.fav_item["product_price"]}/-",
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
                  margin: EdgeInsets.only(right: 5),
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
