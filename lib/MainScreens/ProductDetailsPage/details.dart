import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/ComapreItem/compareItem.dart';
import 'package:online_shopping/MainScreens/CheckoutPage/checkout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shopping/MainScreens/Homepage/homepage.dart';
import 'package:online_shopping/MainScreens/LoginPage/login.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/Utils/utils.dart';

import '../../main.dart';

class DetailsPage extends StatefulWidget {
  final product_info;
  DetailsPage({this.product_info});

  @override
  State<StatefulWidget> createState() {
    return DetailsPageState();
  }
}

class DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _reviewController = TextEditingController();
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "", review = '', _ratingStatus = '', rating = "0.0";
  bool _requireConsent = false, isfav = false, reviewAvailable = false;
  CarouselSlider carouselSlider;
  int _current = 0,
      num = 0,
      totalFav = 10,
      count = 0,
      discountPercent = 0,
      discountAmt = 0,
      quantity = 0;
  double tk = 0.0;
  List imgList = [
    "assets/tshirt.png",
    "assets/shirt.jpg",
    "assets/pant.jpg",
    "assets/shoe.png"
  ];
  var cartList = [];
  double totalPrice = 0.0;
  var reviewList = [];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchReview();
    if (userInfo != null) {
      fetchCart();
      fetchFavlist();
      fetchReviewAvailable();
    }

    discountAmt = Utils().getProductDiscount(
        widget.product_info["product_price"],
        widget.product_info["prod_discount"]);
    quantity = int.parse(widget.product_info["prod_quantity"]);

    double proRating = double.parse(widget.product_info["prod_rating"]);
    rating = "${proRating.toStringAsFixed(2)}";
  }

  int _rating = 0;

  void rate(int rating) {
    _rating = rating;
    setState(() {
      if (rating == 1) {
        _ratingStatus = "Poor";
      }
      if (rating == 2) {
        _ratingStatus = "Average";
      }
      if (rating == 3) {
        _ratingStatus = "Good";
      }
      if (rating == 4) {
        _ratingStatus = "Very Good";
      }
      if (rating == 5) {
        _ratingStatus = "Excellent";
      }
    });
  }

  Future<void> fetchReview() async {
    final response =
        await http.post(ip + 'easy_shopping/review_list.php', body: {
      "prod_id": widget.product_info["prod_id"],
      "cat_id": widget.product_info["cat_id"]
    });
    if (response.statusCode == 200) {
      print(response.body);
      var reviewBody = json.decode(response.body);
      print(reviewBody["list"]);
      setState(() {
        reviewList = reviewBody["list"];
      });
      print(reviewList.length);
    } else {
      throw Exception('Unable to fetch reviews from the REST API');
    }

    for (int i = 0; i < reviewList.length; i++) {
      if (reviewList[i]["prod_id"] == widget.product_info["prod_id"]) {
        setState(() {
          count++;
        });
      }
    }
  }

  Future<void> fetchReviewAvailable() async {
    print("hit");
    final response = await http
        .post(ip + 'easy_shopping/order_product_list.php', body: {
      "prod_id": widget.product_info["prod_id"],
      "user_id": "${userInfo["user_id"]}"
    });
    print({
      "prod_id": widget.product_info["prod_id"],
      "user_id": "${userInfo["user_id"]}"
    });
    if (response.statusCode == 200) {
      print(response.body);
      if (response.body == "Yes") {
        setState(() {
          reviewAvailable = true;
        });

        print("reviewAvailable - $reviewAvailable");
      }
    } else {
      throw Exception('Unable to fetch reviews from the REST API');
    }
  }

  Future<void> addToFavlist() async {
    final response =
        await http.post(ip + 'easy_shopping/favourite_add.php', body: {
      "prod_id": widget.product_info["prod_id"],
      "user_id": "${userInfo["user_id"]}",
    });
    if (response.statusCode == 200) {
      setState(() {
        isfav = true;
      });
      showConfirmation("Added to favourite successfully!");
    } else {
      throw Exception('Unable to add favourite in the REST API');
    }
  }

  Future<void> fetchFavlist() async {
    final response = await http
        .post(ip + 'easy_shopping/favourite_get_with_product.php', body: {
      "user_id": "${userInfo["user_id"]}",
      "prod_id": widget.product_info["prod_id"],
    });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        if (response.body == "Success") {
          isfav = true;
        } else {
          isfav = false;
        }
      });
    } else {
      throw Exception('Unable to fetch favourite products from the REST API');
    }
  }

  Future<void> addReview() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    final response =
        await http.post(ip + 'easy_shopping/review_add.php', body: {
      "prod_id": widget.product_info["prod_id"],
      "cat_id": widget.product_info["cat_id"],
      "rating": "$_rating",
      "reviews": _reviewController.text,
      "user_id": "${userInfo["user_id"]}",
      "product_name": widget.product_info["product_name"],
      "date": formattedDate,
    });
    if (response.statusCode == 200) {
      selectedPage = 0;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      showConfirmation("Review added successfully!");
    } else {
      throw Exception('Unable to fetch reviews from the REST API');
    }
  }

  Future<void> fetchCart() async {
    totalPrice = 0.0;
    final response = await http.post(ip + 'easy_shopping/cart_list.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      var cartBody = json.decode(response.body);
      print(cartBody["cart_list"]);
      setState(() {
        cartList = cartBody["cart_list"];

        for (int i = 0; i < cartList.length; i++) {
          int qty = int.parse(cartList[i]["product_qnt"]);
          double price = double.parse(cartList[i]["product_price"]);
          double total = qty * price;
          String discStr = "$total";
          int discountAmt =
              Utils().getProductDiscount(discStr, cartList[i]["prod_discount"]);
          totalPrice += (discountAmt == 0 ? total : discountAmt);
        }
        setState(() {
          tk = totalPrice;
        });
        print("totalPrice");
        print(totalPrice);
      });
      print(cartList.length);
    } else {
      throw Exception('Unable to fetch cart from the REST API');
    }
  }

  Future<void> addToCart() async {
    print("cart delete");
    final response = await http.post(ip + 'easy_shopping/cart_add.php', body: {
      "cat_id": widget.product_info["cat_id"],
      "prod_id": widget.product_info["prod_id"],
      "product_qnt": "$num",
      "user_id": "${userInfo["user_id"]}",
    });
    print(response.body);
    if (response.statusCode == 200) {
      showConfirmation("Added to cart!");
      fetchCart();
    } else {
      throw Exception('Unable to add cart from the REST API');
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
      "prod_id": widget.product_info["prod_id"],
    });
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        if (response.body == "Success") {
          isfav = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {}
      });
    } else {
      throw Exception('Unable to fetch favourite products from the REST API');
    }
  }

  showConfirmation(String msg) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(msg,
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).secondaryHeaderColor,
        backgroundColor: Colors.white,
        // title:
        //     Container(padding: EdgeInsets.all(10), color: mainheader, child: Icon(Icons.menu)),
        title: Center(
          child: Container(
            child: Row(
              children: <Widget>[
                Text("Product details",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
                Stack(
                  children: <Widget>[
                    Container(
                        height: 300,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: widget.product_info["product_img"] == ""
                              ? Image.asset(
                                  'assets/product_back.jpg',
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${ip + widget.product_info["product_img"]}",
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                          // child: CarouselSlider(
                          //   //height: 400.0,
                          //   // carouselController: buttonCarouselController,
                          //   options: CarouselOptions(
                          //     autoPlay: false,
                          //     enlargeCenterPage: true,
                          //     viewportFraction: 0.9,
                          //     aspectRatio: 2.0,
                          //     initialPage: 1,
                          //     autoPlayInterval: Duration(seconds: 10),
                          //     autoPlayAnimationDuration:
                          //         Duration(milliseconds: 2000),
                          //     scrollDirection: Axis.horizontal,
                          //     onPageChanged: (index, reason) {
                          //       setState(() {
                          //         _current = index;
                          //       });
                          //     },
                          //   ),

                          //   items: imgList.map((imgUrl) {
                          //     return Builder(
                          //       builder: (BuildContext context) {
                          //         return Container(
                          //           width: MediaQuery.of(context).size.width,
                          //           margin:
                          //               EdgeInsets.symmetric(horizontal: 10.0),
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //           ),
                          //           child: GestureDetector(
                          //             onTap: () {
                          //               //viewImage(_current);
                          //             },
                          //             child: imgUrl == null
                          //                 ? CircularProgressIndicator()
                          //                 : Image.asset(
                          //                     imgUrl,
                          //                     fit: BoxFit.contain,
                          //                   ),
                          //           ),
                          //         );
                          //       },
                          //     );
                          //   }).toList(),
                          // ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product_info["product_name"],
                        //widget.product_info["product_name"],
                        style: TextStyle(fontSize: 17, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Product Code: ",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                          Text(widget.product_info["product_code"],
                              //widget.product_info["product_code"],
                              style: TextStyle(
                                fontSize: 14,
                                color: mainheader,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Size: ",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                          Text(
                              widget.product_info["product_size"] == ""
                                  ? "N/A"
                                  : widget.product_info["product_size"],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54))
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Color: ",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                          Text(
                              widget.product_info["prod_color"] == ""
                                  ? "N/A"
                                  : widget.product_info["prod_color"],
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54))
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            child: Row(
                              children: <Widget>[
                                //Icon(
                                //Icons.attach_money,
                                //color: discountAmt == 0.0
                                //? Colors.black
                                //: Colors.grey,
                                //size: 20,
                                //),
                                SizedBox(
                                  width: 0,
                                ),
                                Text(
                                  "Tk. ${widget.product_info["product_price"]}",
                                  style: TextStyle(
                                      color: discountAmt == 0.0
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: 17,
                                      decoration: discountAmt == 0.0
                                          ? TextDecoration.none
                                          : TextDecoration.lineThrough),
                                )
                              ],
                            ),
                          ),
                          discountAmt == 0.0
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      //Icon(
                                      //Icons.attach_money,
                                      //color: Colors.black,
                                      //size: 20,
                                      //),
                                      SizedBox(
                                        width: 0,
                                      ),
                                      Text(
                                        "Tk. $discountAmt (${widget.product_info["prod_discount"]}%)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17),
                                      )
                                    ],
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star,
                                  color: golden,
                                  size: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 3),
                                  child: Text(
                                    // "${widget.product_info["prod_rating"]} (${widget.product_info["rev_count"]})",
                                    "$rating (${widget.product_info["rev_count"]})",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              ],
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
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Product Description",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.product_info["prod_description"],
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15, color: Colors.black45),
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
                        "Product Information",
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
                                    "Product dimension",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                      widget.product_info["prod_dimension"] ==
                                              ""
                                          ? "N/A"
                                          : widget
                                              .product_info["prod_dimension"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.black54),
                                    )),
                                  )
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
                                    "Shipping Weight",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                      widget.product_info["shipping_weight"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.black54),
                                    )),
                                  )
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
                                    "Manufacturer",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                      widget.product_info["manuf_name"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.black54),
                                    )),
                                  )
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
                                    "SIN",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                        child: Text(
                                      widget.product_info["prod_serial_num"],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(color: Colors.black54),
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin:
                //       EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 5),
                //   padding:
                //       EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 1),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //       color: Colors.white,
                //       border: Border.all(width: 0.2, color: Colors.grey)),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text(
                //         "Product Comparison",
                //         style: TextStyle(fontSize: 17, color: Colors.black),
                //         textAlign: TextAlign.center,
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Container(
                //             width: MediaQuery.of(context).size.width / 6,
                //             child: Container(
                //               //padding: EdgeInsets.only(left: 20),
                //               width: 100,
                //               child: Column(
                //                 children: <Widget>[
                //                   Container(
                //                     height: 100,
                //                   ),
                //                   Text(
                //                     "Name",
                //                     style: TextStyle(
                //                         fontSize: 13, color: Colors.black38),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                   Container(
                //                     margin: EdgeInsets.only(top: 10),
                //                     child: Text(
                //                       "Rating",
                //                       style: TextStyle(
                //                           fontSize: 13, color: Colors.black38),
                //                       textAlign: TextAlign.center,
                //                     ),
                //                   ),
                //                   Container(
                //                     margin: EdgeInsets.only(top: 10),
                //                     child: Text(
                //                       "Price",
                //                       style: TextStyle(
                //                           fontSize: 13, color: Colors.black38),
                //                       textAlign: TextAlign.center,
                //                     ),
                //                   ),
                //                   Container(
                //                     margin: EdgeInsets.only(top: 10),
                //                     child: Text(
                //                       "Shipping",
                //                       style: TextStyle(
                //                           fontSize: 13, color: Colors.black38),
                //                       textAlign: TextAlign.center,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //           Expanded(
                //             child: Container(
                //               margin: EdgeInsets.only(left: 0, right: 0),
                //               //color: sub_white,
                //               width: MediaQuery.of(context).size.width / 1,
                //               padding: EdgeInsets.only(left: 10),
                //               height: 240,
                //               child: new ListView.builder(
                //                 scrollDirection: Axis.horizontal,
                //                 itemBuilder:
                //                     (BuildContext context, int index) =>
                //                         new Container(
                //                   //color: Colors.white,
                //                   margin: EdgeInsets.all(5),
                //                   padding: EdgeInsets.all(10),
                //                   decoration: BoxDecoration(
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(1.0)),
                //                       color: Colors.white,
                //                       border: Border.all(
                //                           width: 0.2, color: Colors.grey)),
                //                   child: GestureDetector(
                //                     onTap: () {
                //                       Navigator.push(
                //                         context,
                //                         MaterialPageRoute(
                //                             builder: (context) =>
                //                                 DetailsPage()),
                //                       );
                //                     },
                //                     child: Container(
                //                       //padding: EdgeInsets.only(left: 20),
                //                       width: 100,
                //                       child: Column(
                //                         children: <Widget>[
                //                           Container(
                //                               height: 100,
                //                               child: Image.asset(
                //                                   'assets/shirt.jpg')),
                //                           SizedBox(
                //                             height: 10,
                //                           ),
                //                           Text(
                //                             "Product Name",
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 color: Colors.black38),
                //                             textAlign: TextAlign.center,
                //                           ),
                //                           Container(
                //                             margin: EdgeInsets.only(
                //                                 left: 5, top: 5),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: <Widget>[
                //                                 Icon(
                //                                   Icons.star,
                //                                   color: golden,
                //                                   size: 17,
                //                                 ),
                //                                 Icon(
                //                                   Icons.star,
                //                                   color: golden,
                //                                   size: 17,
                //                                 ),
                //                                 Icon(
                //                                   Icons.star,
                //                                   color: golden,
                //                                   size: 17,
                //                                 ),
                //                                 Icon(
                //                                   Icons.star,
                //                                   color: golden,
                //                                   size: 17,
                //                                 ),
                //                                 Icon(
                //                                   Icons.star,
                //                                   color: golden,
                //                                   size: 17,
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: EdgeInsets.only(top: 10),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: <Widget>[
                //                                 Row(
                //                                   children: <Widget>[
                //                                     Icon(
                //                                       Icons.attach_money,
                //                                       color: Colors.black54,
                //                                       size: 16,
                //                                     ),
                //                                     Text(
                //                                       "20.25",
                //                                       style: TextStyle(
                //                                           fontSize: 13,
                //                                           color:
                //                                               Colors.black54),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           Container(
                //                             margin: EdgeInsets.only(top: 10),
                //                             child: Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: <Widget>[
                //                                 Row(
                //                                   children: <Widget>[
                //                                     Icon(
                //                                       Icons.attach_money,
                //                                       color: Colors.black54,
                //                                       size: 16,
                //                                     ),
                //                                     Text(
                //                                       "20.25",
                //                                       style: TextStyle(
                //                                           fontSize: 13,
                //                                           color:
                //                                               Colors.black54),
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ],
                //                             ),
                //                           )
                //                         ],
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 itemCount: 20,
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CompareItem(widget.product_info)));
                    },
                    child: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: mainheader,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Text(
                          "Add to compare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      quantity == 0
                          ? Container(
                              child: Text("Out of stock",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold)),
                            )
                          : Row(
                              children: <Widget>[
                                // Icon(Icons.confirmation_number, color: Colors.black),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                Text(
                                  "Qty : ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Container(
                                    color: Colors.grey[200],
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (num <= 0) {
                                                num = 0;
                                              } else {
                                                num--;
                                              }
                                            });
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          num.toString(),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              num++;
                                              if (num == quantity) {
                                                num = quantity;
                                              } else if (num > quantity) {
                                                num = quantity;
                                                showAlert("No more products!");
                                              }
                                            });
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            quantity == 0
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      if (isLoggedin) {
                                        if (num > 0) {
                                          setState(() {
                                            double price = double.parse(widget
                                                .product_info["product_price"]);
                                            double tkTotal = num * price;
                                            tk += tkTotal;
                                          });
                                          addToCart();
                                        }
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            color: mainheader,
                                            border: Border.all(
                                                width: 0.2,
                                                color: Colors.grey)),
                                        child: Text(
                                          "Add to cart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )),
                                  ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isLoggedin) {
                                    if (isfav) {
                                      showMyDialog();
                                    } else {
                                      addToFavlist();
                                    }
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      isfav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isfav
                                          ? Colors.redAccent
                                          : Colors.grey,
                                    ),
                                    // Text(
                                    //   " ($totalFav)",
                                    //   style: TextStyle(
                                    //       color: Colors.black45, fontSize: 12),
                                    // )
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                  padding:
                      EdgeInsets.only(left: 0, top: 15, bottom: 15, right: 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          "Product Reviews",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      count == 0
                          ? Center(
                              child: Container(
                                child: Text("No reviews available!"),
                              ),
                            )
                          : Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Container(
                                //   width: MediaQuery.of(context).size.width / 6,
                                //   child: Container(
                                //     //padding: EdgeInsets.only(left: 20),
                                //     width: 100,
                                //     child: Column(
                                //       children: <Widget>[
                                //         Container(
                                //           height: 55,
                                //         ),
                                //         Text(
                                //           "Name",
                                //           style: TextStyle(
                                //               fontSize: 13, color: Colors.black38),
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         Container(
                                //           margin: EdgeInsets.only(top: 10),
                                //           child: Text(
                                //             "Rating",
                                //             style: TextStyle(
                                //                 fontSize: 13, color: Colors.black38),
                                //             textAlign: TextAlign.center,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 0, right: 0),
                                    //color: sub_white,
                                    padding: EdgeInsets.only(left: 2),
                                    child: Column(
                                      children: List.generate(reviewList.length,
                                          (index) {
                                        String pro_pic =
                                            reviewList[index]["pro_pic"];

                                        return reviewList[index]["prod_id"] ==
                                                widget.product_info["prod_id"]
                                            ? Container(
                                                //color: Colors.white,
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                1.0)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        width: 0.2,
                                                        color: Colors.grey)),
                                                child: Container(
                                                  //padding: EdgeInsets.only(left: 20),
                                                  child: Center(
                                                    child: Row(
                                                      children: <Widget>[
                                                        pro_pic != ""
                                                            ? ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                                child:
                                                                    Container(
                                                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              1.0),
                                                                  height: 50,
                                                                  width: 50,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        "${ip + pro_pic}",
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                          color: Colors
                                                                              .grey, // border color
                                                                          shape:
                                                                              BoxShape.circle),
                                                                ),
                                                              )
                                                            : Container(
                                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            1.0),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 25.0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          'assets/user.png'),
                                                                ),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  color: Colors
                                                                      .grey, // border color
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child: Text(
                                                                      reviewList[
                                                                              index]
                                                                          [
                                                                          "full_name"],
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color: Colors
                                                                              .black38,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    reviewList[
                                                                            index]
                                                                        [
                                                                        "date"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Icon(
                                                                      Icons
                                                                          .star,
                                                                      color:
                                                                          golden,
                                                                      size: 14,
                                                                    ),
                                                                    Text(
                                                                      "${reviewList[index]["rating"]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black38),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                child: Text(
                                                                  reviewList[
                                                                          index]
                                                                      [
                                                                      "reviews"],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .black38),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
                !isLoggedin
                    ? Container()
                    : !reviewAvailable
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 5, left: 20, right: 20, bottom: 5),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.white,
                                border:
                                    Border.all(width: 0.2, color: Colors.grey)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Write a review",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new GestureDetector(
                                              child: new Icon(
                                                Icons.star,
                                                color: _rating >= 1
                                                    ? golden
                                                    : Colors.grey,
                                              ),
                                              onTap: () => rate(1),
                                            ),
                                            new GestureDetector(
                                              child: new Icon(
                                                Icons.star,
                                                color: _rating >= 2
                                                    ? golden
                                                    : Colors.grey,
                                              ),
                                              onTap: () => rate(2),
                                            ),
                                            new GestureDetector(
                                              child: new Icon(
                                                Icons.star,
                                                color: _rating >= 3
                                                    ? golden
                                                    : Colors.grey,
                                              ),
                                              onTap: () => rate(3),
                                            ),
                                            new GestureDetector(
                                              child: new Icon(
                                                Icons.star,
                                                color: _rating >= 4
                                                    ? golden
                                                    : Colors.grey,
                                              ),
                                              onTap: () => rate(4),
                                            ),
                                            new GestureDetector(
                                              child: new Icon(
                                                Icons.star,
                                                color: _rating >= 5
                                                    ? golden
                                                    : Colors.grey,
                                              ),
                                              onTap: () => rate(5),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _ratingStatus,
                                      style: TextStyle(color: mainheader),
                                    )
                                  ],
                                ),
                                // Container(
                                //   height: 100,
                                //   margin: EdgeInsets.only(top: 15),
                                //   decoration: BoxDecoration(
                                //       borderRadius:
                                //           BorderRadius.all(Radius.circular(5.0)),
                                //       color: Colors.white,
                                //       border: Border.all(width: 0.5, color: Colors.grey)),
                                //   child: TextField(
                                //     autofocus: false,
                                //     controller: _reviewController,
                                //     decoration: InputDecoration(
                                //       hintText: "Type your review...",
                                //       contentPadding:
                                //           EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                                //       border: InputBorder.none,
                                //     ),
                                //     onChanged: (value) {
                                //       review = value;
                                //     },
                                //   ),
                                // ),
                                Container(
                                  //height: 100,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(top: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 0.5, color: Colors.grey)),
                                  child: new ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 100.0,
                                    ),
                                    child: new Scrollbar(
                                      child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        reverse: true,
                                        child: new TextField(
                                          maxLines: null,
                                          autofocus: false,
                                          controller: _reviewController,
                                          decoration: InputDecoration(
                                            hintText: "Type your review...",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                0.0, 10.0, 20.0, 10.0),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            review = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        addReview();
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              color: mainheader,
                                              border: Border.all(
                                                  width: 0.2,
                                                  color: Colors.grey)),
                                          child: Text(
                                            "Submit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: tk == 0.0 ? 0 : 50,
        width: MediaQuery.of(context).size.width,
        color: mainheader,
        child: Container(
          margin: EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Container(
              //     padding: EdgeInsets.all(4),
              //     decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(15)),
              //     child: Text("$num",
              //         style: TextStyle(color: Colors.black, fontSize: 13))),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    goToCheckout();
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Checkout",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                        Icon(Icons.keyboard_arrow_right,
                            size: 15, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  child: Row(
                children: <Widget>[
                  Text(
                    "Tk. ${tk.toStringAsFixed(2)}",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  goToCheckout() async {
    String isCart = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutPage()),
    );

    if (isCart == "true") {
      if (userInfo != null) {
        fetchCart();
      }
    }

    print("isCart - $isCart");
  }
}
