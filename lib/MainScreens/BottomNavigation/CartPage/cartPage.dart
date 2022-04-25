import 'dart:convert';
import 'dart:ui' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/Cards/CartCard/cartCard.dart';
import 'package:online_shopping/Forms/LoginForm/loginForm.dart';
import 'package:online_shopping/MainScreens/CheckoutPage/checkout.dart';
import 'package:online_shopping/MainScreens/LoginPage/login.dart';
import 'package:online_shopping/Utils/utils.dart';
import 'dart:async';
import '../../../main.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartPageState();
  }
}

class CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  var cartList = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCart();
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
          int discountAmt = Utils().getProductDiscount(
              cartList[i]["product_price"], cartList[i]["prod_discount"]);
          totalPrice += (discountAmt == 0 ? total : discountAmt);
        }
        print("totalPrice");
        print(totalPrice);
      });
      print(cartList.length);
    } else {
      throw Exception('Unable to fetch cart from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: sub_white,
        //height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: 40),
              color: sub_white,
              width: MediaQuery.of(context).size.width,
              child: cartList.length == 0
                  ? Center(
                      child: Container(
                        child: Text("No products added to cart!"),
                      ),
                    )
                  : new ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        int discountAmt = Utils().getProductDiscount(
                            cartList[index]["product_price"],
                            cartList[index]["prod_discount"]);
                        return Container(
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 5, bottom: 5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              color: Colors.white,
                              border:
                                  Border.all(width: 0.2, color: Colors.grey)),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  // color: Colors.red,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              cartList[index]["product_name"],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black87),
                                              textAlign: TextAlign.start,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.format_list_numbered,
                                                    color: golden,
                                                    size: 17,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    child: Text(
                                                      cartList[index]
                                                          ["product_qnt"],
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.attach_money,
                                                        color: Colors.black54,
                                                        size: 17,
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        discountAmt == 0
                                                            ? cartList[index][
                                                                "product_price"]
                                                            : "$discountAmt",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20, right: 5),
                                                    child: Row(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Expanded(
                                                                  child:
                                                                      AlertDialog(
                                                                    title: Text(
                                                                        'Delete Cart Item'),
                                                                    content: Text(
                                                                        'Do you want to delete the item?'),
                                                                    actions: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(right: 10, bottom: 10),
                                                                              child: Text('No')),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          deleteCart(cartList[index]
                                                                              [
                                                                              "cart_id"]);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(right: 10, bottom: 10),
                                                                              child: Text('Yes')),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors
                                                                .grey[500],
                                                            size: 20,
                                                          ),
                                                        ),
                                                        // SizedBox(
                                                        //   width: 3,
                                                        // ),
                                                        // Text(
                                                        //   "XXL",
                                                        //   style: TextStyle(
                                                        //       fontSize: 14,
                                                        //       color: Colors.grey),
                                                        // ),
                                                      ],
                                                    ),
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
                                // Container(
                                //     color: Colors.grey[200],
                                //     padding: EdgeInsets.all(10),
                                //     child: Column(
                                //       children: <Widget>[
                                //         Container(
                                //           color: Colors.white,
                                //           child: Icon(
                                //             Icons.add,
                                //             color: Colors.grey,
                                //           ),
                                //         ),
                                //         Container(
                                //             margin: EdgeInsets.only(
                                //                 top: 10, bottom: 10),
                                //             child: Text("1")),
                                //         Container(
                                //           color: Colors.white,
                                //           child: Icon(
                                //             Icons.remove,
                                //             color: Colors.grey,
                                //           ),
                                //         )
                                //       ],
                                //     )),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: cartList.length,
                    ),
            ),
            cartList.length == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 40,
                    color: mainheader,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.card_travel,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text("${cartList.length} Items",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Container(
                                  height: 20,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                  )),
                              Row(
                                children: <Widget>[
                                  Text("$totalPrice/-",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isLoggedin
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckoutPage()),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Check Out",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 1),
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 17,
                                      ))
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
            Container(margin: EdgeInsets.only(top: 32), child: Divider())
          ],
        ),
      ),
    );
  }

  Future<void> deleteCart(String cart_id) async {
    print("cart delete");
    final response = await http
        .post(ip + 'easy_shopping/cart_delete.php', body: {"cart_id": cart_id});
    print("cart_id - " + cart_id);
    print(response.statusCode);
    if (response.statusCode == 200) {
      fetchCart();
    } else {
      throw Exception('Unable to delete cart from the REST API');
    }
  }
}
