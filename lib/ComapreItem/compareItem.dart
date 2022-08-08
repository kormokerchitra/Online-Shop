import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/MainScreens/BottomNavigation/ProductPage/productSearch.dart';
import 'package:online_shopping/Utils/utils.dart';

import '../main.dart';

class CompareItem extends StatefulWidget {
  final item;
  CompareItem(this.item);

  @override
  State<CompareItem> createState() => _CompareItemState();
}

class _CompareItemState extends State<CompareItem> {
  int discountAmt = 0,
      quantity = 0,
      searchDiscount = 0,
      searchQuantity = 0,
      val1 = 0,
      val2 = 0;
  String rating = "0.0", searchRating = "0.0";
  String result = '';
  double val1Perent = 0.0, val2Perent = 0.0;
  TextEditingController searchController = TextEditingController();
  var productBody;
  var prodList = [];
  bool isLoading = false;
  var searchProduct, mainProduct;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainProduct = widget.item;
    discountAmt = Utils().getProductDiscount(
        mainProduct["product_price"], mainProduct["prod_discount"]);
    quantity = int.parse(mainProduct["prod_quantity"]);

    double proRating = double.parse(mainProduct["prod_rating"]);
    rating = "${proRating.toStringAsFixed(2)}";
  }

  Future<void> fetchProduct(String name) async {
    final response = await http.post(ip + 'easy_shopping/product_search.php',
        body: {"product_name": "$name"});
    print(name);
    if (response.statusCode == 200) {
      print(response.body);
      productBody = json.decode(response.body);
      print(productBody["product_list"]);
      setState(() {
        prodList = [];
        int cc = productBody["product_list"].length;
        print("cc");
        print(cc);
        for (int i = 0; i < cc; i++) {
          prodList.add(productBody["product_list"][i]);
        }
      });
      print("prodList.length");
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> findProduct2() async {
    var product = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchProduct(cat_id: mainProduct["cat_id"])));

    if (product != null) {
      setState(() {
        searchProduct = product;
        searchDiscount = Utils().getProductDiscount(
            searchProduct["product_price"], searchProduct["prod_discount"]);
        searchQuantity = int.parse(searchProduct["prod_quantity"]);

        double proRating = double.parse(searchProduct["prod_rating"]);
        searchRating = "${proRating.toStringAsFixed(2)}";
        percentCheck();
      });
    }
  }

  Future<void> findProduct1() async {
    var product = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SearchProduct(cat_id: "")));

    if (product != null) {
      setState(() {
        mainProduct = product;
        searchProduct = null;
        percentCheck();
      });
    }
  }

  percentCheck() {
    if (discountAmt != 0.0) {
      val1++;
    }
    if (searchDiscount != 0.0) {
      val2++;
    }

    if (discountAmt < searchDiscount) {
      val1++;
    }
    if (searchDiscount < discountAmt) {
      val2++;
    }

    print("val1");
    print(val1);
    print("val2");
    print(val2);

    val1Perent = (double.parse("$val1") / 2) * 100;
    val2Perent = (double.parse("$val2") / 2) * 100;
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
                Text("Product Comparison",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            // Container(
            //   color: mainheader.withOpacity(0.1),
            //   child: Column(
            //     children: [
            //       Container(
            //         height: 170,
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 10, right: 5, top:40, bottom: 40),
            //         child: Text(
            //           "Product\nName",
            //           //widget.product_info["product_name"],
            //           style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 10, right: 5, top:40, bottom: 40),
            //         child: Text(
            //           "Price",
            //           //widget.product_info["product_name"],
            //           style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 10, right: 5, top:40, bottom: 40),
            //         child: Text(
            //           "Rating",
            //           //widget.product_info["product_name"],
            //           style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 10, right: 5, top:40, bottom: 40),
            //         child: Text(
            //           "Description",
            //           //widget.product_info["product_name"],
            //           style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //       Container(
            //         padding: EdgeInsets.only(left: 10, right: 5, top:40, bottom: 40),
            //         child: Text(
            //           "Manufacturer\nName",
            //           //widget.product_info["product_name"],
            //           style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: mainProduct["product_img"] == ""
                                      ? Image.asset(
                                          'assets/product_back.jpg',
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              "${ip + mainProduct["product_img"]}",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                )),
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              child: Text(
                                "vs",
                                //widget.product_info["product_name"],
                                style:
                                    TextStyle(fontSize: 17, color: mainheader),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            searchProduct == null
                                ? Container(
                                    height: 150,
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    height: 150,
                                    width: 150,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: searchProduct["product_img"] == ""
                                          ? Image.asset(
                                              'assets/product_back.jpg',
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  "${ip + searchProduct["product_img"]}",
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                    )),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product Name",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      child: Text(
                                        mainProduct["product_name"],
                                        //widget.product_info["product_name"],
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      findProduct1();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: mainheader.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(Icons.search,
                                            color: mainheader),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 80,
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  searchProduct == null
                                      ? Flexible(
                                          child: Container(
                                              width: 150,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Select product",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: mainheader),
                                              )),
                                        )
                                      : Flexible(
                                          child: Text(
                                            searchProduct["product_name"],
                                            //widget.product_info["product_name"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  GestureDetector(
                                    onTap: () {
                                      findProduct2();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: mainheader.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(Icons.search,
                                            color: mainheader),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   padding: EdgeInsets.all(10),
                      //   color: Colors.grey[200],
                      //   child: Text(
                      //     "Product Percentage",
                      //     //widget.product_info["product_name"],
                      //     style: TextStyle(
                      //         fontSize: 12,
                      //         color: Colors.grey,
                      //         fontWeight: FontWeight.bold),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      // Container(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: [
                      //       Container(
                      //         padding: EdgeInsets.only(right: 10, left: 10),
                      //         width: MediaQuery.of(context).size.width / 2,
                      //         child: Text(
                      //           "56%",
                      //           //widget.product_info["product_name"],
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.black),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ),
                      //       Container(
                      //         width: 0.5,
                      //         color: Colors.grey,
                      //         height: 50,
                      //       ),
                      //       Container(
                      //         padding: EdgeInsets.only(right: 10, left: 10),
                      //         width: MediaQuery.of(context).size.width / 2,
                      //         child: Text(
                      //           "44%",
                      //           //widget.product_info["product_name"],
                      //           style: TextStyle(
                      //               fontSize: 14, color: Colors.black),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product Price with discount",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 0,
                                        ),
                                        Text(
                                          "Tk. ${mainProduct["product_price"]}",
                                          style: TextStyle(
                                              color: discountAmt == 0.0
                                                  ? Colors.black
                                                  : mainheader,
                                              fontSize: 14,
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 0,
                                              ),
                                              Text(
                                                "Tk. $discountAmt (${mainProduct["prod_discount"]}%)",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 80,
                            ),
                            searchProduct == null
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 0,
                                              ),
                                              Text(
                                                "Tk. ${searchProduct["product_price"]}",
                                                style: TextStyle(
                                                    color: searchDiscount == 0.0
                                                        ? Colors.black
                                                        : mainheader,
                                                    fontSize: 14,
                                                    decoration:
                                                        searchDiscount == 0.0
                                                            ? TextDecoration
                                                                .none
                                                            : TextDecoration
                                                                .lineThrough),
                                              )
                                            ],
                                          ),
                                        ),
                                        searchDiscount == 0.0
                                            ? Container()
                                            : Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 0,
                                                    ),
                                                    Text(
                                                      "Tk. $searchDiscount (${searchProduct["prod_discount"]}%)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product rating",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: golden,
                                        size: 25,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 3),
                                        child: Text(
                                          // "${mainProduct["prod_rating"]} (${mainProduct["rev_count"]})",
                                          "$rating (${mainProduct["rev_count"]})",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 50,
                            ),
                            searchProduct == null
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: golden,
                                              size: 25,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3),
                                              child: Text(
                                                // "${mainProduct["prod_rating"]} (${mainProduct["rev_count"]})",
                                                "$searchRating (${searchProduct["rev_count"]})",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product Description",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                mainProduct["prod_description"],
                                //widget.product_info["product_name"],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 100,
                            ),
                            searchProduct == null
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      searchProduct["prod_description"],
                                      //widget.product_info["product_name"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product Manufacturer Name",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                mainProduct["manuf_name"],
                                //widget.product_info["product_name"],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 80,
                            ),
                            searchProduct == null
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      searchProduct["manuf_name"],
                                      //widget.product_info["product_name"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        color: Colors.grey[200],
                        child: Text(
                          "Product Percentage",
                          //widget.product_info["product_name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "$val1Perent%",
                                //widget.product_info["product_name"],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 0.5,
                              color: Colors.grey,
                              height: 50,
                            ),
                            searchProduct == null
                                ? Container(
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text("N/A"))
                                : Container(
                                    padding:
                                        EdgeInsets.only(right: 10, left: 10),
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "$val2Perent%",
                                      //widget.product_info["product_name"],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
