import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/AllProductCard/allProductCard.dart';
import 'package:online_shopping/Cards/CategoryCard/categoryCard.dart';
import 'package:online_shopping/Cards/DiscountCard/discountCard.dart';
import 'package:online_shopping/Cards/NewArrivalCard/newArrivalCard.dart';
import 'package:online_shopping/Cards/RecommendedCard/recommendedCard.dart';
import 'package:online_shopping/Cards/TrendingCard/trendingCard.dart';
import 'package:online_shopping/MainScreens/AllProductPage/allProductPage.dart';
import 'package:online_shopping/MainScreens/AllRecommendedList/allRecommendedList.dart';
import 'package:online_shopping/MainScreens/DiscountProductList/discountProductList.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/CategoryPage/category.dart';
import 'package:online_shopping/MainScreens/NewArrivalProductList/newArrivalProductList.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../../main.dart';

class ProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductPageState();
  }
}

class ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  var categoryList = [];
  var prodList = [], discList = [], recomList = [];
  int discountCount = 0;

  @override
  void initState() {
    super.initState();
    fetchCategory();
    fetchProduct();
  }

  Future<void> fetchCategory() async {
    final response = await http.get(ip + 'easy_shopping/category_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var categoryBody = json.decode(response.body);
      print(categoryBody["cat_list"]);
      setState(() {
        int cc = categoryBody["cat_list"].length <= 5
            ? categoryBody["cat_list"].length
            : 5;
        for (int i = 0; i < cc; i++) {
          categoryList.add(categoryBody["cat_list"][i]);
        }
      });
      print(categoryList.length);
    } else {
      throw Exception('Unable to fetch category from the REST API');
    }
  }

  Future<void> fetchProduct() async {
    final response = await http.get(ip + 'easy_shopping/product_list.php');
    if (response.statusCode == 200) {
      print(response.body);
      var productBody = json.decode(response.body);
      print(productBody["product_list"]);
      setState(() {
        int cc = productBody["product_list"].length <= 5
            ? productBody["product_list"].length
            : 5;
        print("cc");
        print(cc);
        for (int i = 0; i < cc; i++) {
          prodList.add(productBody["product_list"][i]);
          if (prodList[i]["prod_discount"] != "0") {
            discountCount++;
            discList.add(productBody["product_list"][i]);
          }
          double rating = double.parse(prodList[i]["prod_rating"]);

          if (rating >= 4) {
            recomList.add(productBody["product_list"][i]);
          }
        }
      });
      print("rodList.length");
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sub_white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: sub_white,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Category",
                          style: TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryPage()));
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Show All",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                Icon(Icons.chevron_right, color: Colors.black45)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                ////// <<<<< Category List >>>>> //////
                Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  color: sub_white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  height: 55,
                  child: new ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          ////// <<<<< Category Card >>>>> //////
                          CategoryCard(categoryList[index]),
                      itemCount: categoryList.length),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "New Arrival",
                          style: TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewArrivalProductList()));
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Show All",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                Icon(Icons.chevron_right, color: Colors.black45)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                ////// <<<<< New Arrival List >>>>> //////
                Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  color: sub_white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  height: prodList.length == 0 ? 50 : 230,
                  child: prodList.length == 0
                      ? Center(
                          child: Text("No data available!",
                              style: TextStyle(color: Colors.grey)))
                      : new ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              ////// <<<<< New Arrival Card >>>>> //////
                              NewArrivalCard(prodList[index]),
                          itemCount: prodList.length,
                        ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //     width: MediaQuery.of(context).size.width,
                //     margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Text(
                //           "Trending",
                //           style: TextStyle(fontSize: 20),
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => AllProductPage()));
                //           },
                //           child: Container(
                //             child: Row(
                //               children: <Widget>[
                //                 Text(
                //                   "Show All",
                //                   style: TextStyle(
                //                       fontSize: 15, color: Colors.black45),
                //                 ),
                //                 Icon(Icons.chevron_right, color: Colors.black45)
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     )),
                // SizedBox(
                //   height: 10,
                // ),
                // ////// <<<<< Trending List >>>>> //////
                // Container(
                //   margin: EdgeInsets.only(left: 0, right: 0),
                //   color: sub_white,
                //   width: MediaQuery.of(context).size.width,
                //   padding: EdgeInsets.only(left: 10),
                //   height: 210,
                //   child: new ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (BuildContext context, int index) =>
                //         ////// <<<<< Trending Card >>>>> //////
                //         TrendingCard(),
                //     itemCount: 20,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Discount",
                          style: TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DiscountProductList()));
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Show All",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                Icon(Icons.chevron_right, color: Colors.black45)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                ////// <<<<< Discount List >>>>> //////
                Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  color: sub_white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  height: discList.length == 0 ? 50 : 230,
                  child: discList.length == 0
                      ? Center(
                          child: Text("No data available!",
                              style: TextStyle(color: Colors.grey)))
                      : new ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              ////// <<<<< Discount Card >>>>> //////
                              DiscountCard(
                            prod_item: discList[index],
                          ),
                          itemCount: discList.length,
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Recommended",
                          style: TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllRecommendedPage()));
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Show All",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                ),
                                Icon(Icons.chevron_right, color: Colors.black45)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                ////// <<<<< Recommended List >>>>> //////
                Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  color: sub_white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 10),
                  height: prodList.length == 0 ? 50 : 230,
                  child: prodList.length == 0
                      ? Center(
                          child: Text("No data available!",
                              style: TextStyle(color: Colors.grey)))
                      : new ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) =>
                              ////// <<<<< New Arrival Card >>>>> //////
                              RecommendedCard(
                            prodList[index],
                          ),
                          itemCount: prodList.length,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
