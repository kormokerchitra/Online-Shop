import 'dart:convert';

import 'package:online_shopping/MainScreens/CheckoutPage/checkout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:online_shopping/MainScreens/LoginPage/login.dart';
import 'package:http/http.dart' as http;

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
  String _debugLabelString = "", review = '', _ratingStatus = '';
  bool _requireConsent = false, isfav = false;
  CarouselSlider carouselSlider;
  int _current = 0, num = 0, totalFav = 10, count = 0;
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
    fetchCart();
  }

  int _rating = 0;

  void rate(int rating) {
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
  }

  Future<void> fetchReview() async {
    final response = await http.get(ip + 'easy_shopping/review_list.php');
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

  Future<void> fetchCart() async {
    totalPrice = 0.0;
    final response = await http
        .post(ip + 'easy_shopping/cart_list.php', body: {"user_id": userID});
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
          totalPrice += total;
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
      "product_name": widget.product_info["product_name"],
      "product_price": widget.product_info["product_price"],
      "product_qnt": "$num",
      "prod_discount": widget.product_info["prod_discount"],
      "user_id": userID,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      fetchCart();
    } else {
      throw Exception('Unable to add cart from the REST API');
    }
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
                              : Image.asset(
                                  'assets/product_back.jpg',
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
                            "Product Code : ",
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
                            "Size : ",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                          Text(widget.product_info["product_size"],
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
                        children: <Widget>[
                          Icon(
                            Icons.attach_money,
                            color: Colors.black,
                            size: 20,
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          Text(
                            widget.product_info["product_price"],
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          )
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
                                    widget.product_info["prod_rating"],
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
                                  Container(
                                      child: Text(
                                    widget.product_info["prod_dimension"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black54),
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
                                    "Shipping Weight",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Text(
                                    widget.product_info["shipping_weight"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black54),
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
                                    "Manufacturer",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Text(
                                    widget.product_info["manuf_name"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black54),
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
                                    "SIN",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                                  Container(
                                      child: Text(
                                    widget.product_info["prod_serial_num"],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.black54),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
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
                            GestureDetector(
                              onTap: () {
                                if (isLoggedin) {
                                  setState(() {
                                    double price = double.parse(
                                        widget.product_info["product_price"]);
                                    double tkTotal = num * price;
                                    tk += tkTotal;
                                  });
                                  addToCart();
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
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
                                          width: 0.2, color: Colors.grey)),
                                  child: Text(
                                    "Add to cart",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isLoggedin) {
                                    isfav = true;
                                    totalFav++;
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  }
                                });
                              },
                              child: Container(
                                //padding: EdgeInsets.all(5),
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
                                    Text(
                                      " ($totalFav)",
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                    )
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
                                                        Container(
                                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  1.0),
                                                          child: CircleAvatar(
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
                                                            shape:
                                                                BoxShape.circle,
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
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 20, right: 20, bottom: 5),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white,
                            border: Border.all(width: 0.2, color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Write a review",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
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
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: mainheader,
                                        border: Border.all(
                                            width: 0.2, color: Colors.grey)),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white),
                                    )),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutPage()));
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
                    "$tk/-",
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
}
