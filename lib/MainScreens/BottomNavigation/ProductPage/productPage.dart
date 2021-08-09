import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/CategoryCard/categoryCard.dart';
import 'package:online_shopping/Cards/DiscountCard/discountCard.dart';
import 'package:online_shopping/Cards/NewArrivalCard/newArrivalCard.dart';
import 'package:online_shopping/Cards/RecommendedCard/recommendedCard.dart';
import 'package:online_shopping/Cards/TrendingCard/trendingCard.dart';
import 'package:online_shopping/MainScreens/AllProductPage/allProductPage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/CategoryPage/category.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        CategoryCard(),
                    itemCount: 20,
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
                          "New Arrival",
                          style: TextStyle(fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllProductPage()));
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
                  height: 210,
                  child: new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        ////// <<<<< New Arrival Card >>>>> //////
                        NewArrivalCard(),
                    itemCount: 20,
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
                                    builder: (context) => AllProductPage()));
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
                  height: 210,
                  child: new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                        ////// <<<<< Discount Card >>>>> //////
                        DiscountCard(),
                    itemCount: 20,
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
                                    builder: (context) => AllProductPage()));
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
                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                  color: sub_white,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  height: 210,
                  child: new ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) =>
                    ////// <<<<< Recommended Card >>>>> //////
                        RecommendedCard(),
                    itemCount: 20,
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
