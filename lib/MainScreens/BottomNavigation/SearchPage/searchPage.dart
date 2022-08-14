import 'dart:convert';
import 'dart:ui' as prefix0;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/Cards/AllProductCard/allProductCard.dart';
import 'dart:async';
import '../../../main.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  String result = '';
  TextEditingController searchController = TextEditingController();
  var productBody, keywordBody;
  var prodList = [], keyWordList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (userInfo != null) {
      fetchKeyword();
    }
  }

  Future<void> fetchKeyword() async {
    final response = await http.post(ip + 'easy_shopping/keyword_list.php',
        body: {"user_id": "${userInfo["user_id"]}"});
    if (response.statusCode == 200) {
      print(response.body);
      keywordBody = json.decode(response.body);
      print(keywordBody["keyword_list"]);
      setState(() {
        keyWordList = [];
        int cc = keywordBody["keyword_list"].length;
        print("cc");
        print(cc);
        for (int i = 0; i < cc; i++) {
          keyWordList.add(keywordBody["keyword_list"][i]);
        }
      });
      print("keyWordList.length");
      print(keyWordList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
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
        isLoading = false;
      });
      print("prodList.length");
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> addKeyword(String key) async {
    final response =
        await http.post(ip + 'easy_shopping/keyword_save.php', body: {
      "keyword": "$key",
      "user_id": "${userInfo["user_id"]}",
    });
    print(key);
    if (response.statusCode == 200) {
      print(response.body);
      if (response.body == "Success") {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> deleteKeyword(String key) async {
    final response =
        await http.post(ip + 'easy_shopping/keyword_delete.php', body: {
      "keyword": "$key",
      "user_id": "${userInfo["user_id"]}",
    });
    print(key);
    if (response.statusCode == 200) {
      print(response.body);
      if (response.body == "Success") {
        fetchKeyword();
      }
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: sub_white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 1),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              color: Colors.white,
              border: Border.all(width: 0, color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    border: Border.all(width: 0.5, color: Colors.grey)),
                child: TextField(
                  controller: searchController,
                  autofocus: false,
                  decoration: InputDecoration(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black38,
                      ),
                      hintText: 'Search product here...',
                      contentPadding:
                          EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            if (searchController.text != "") {
                              setState(() {
                                isLoading = true;
                                result = searchController.text;
                              });
                              if (userInfo != null) {
                                addKeyword(result);
                              }
                              fetchProduct(result);
                            }
                          },
                          child: Icon(Icons.send, color: mainheader))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              prodList.length == 0
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (userInfo != null) {
                              fetchKeyword();
                            }

                            setState(() {
                              searchController.clear();
                              prodList = [];
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Clear search",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${prodList.length} items found",
                            style: TextStyle(color: mainheader),
                          ),
                        ),
                      ],
                    ),
              prodList.length == 0
                  ? Container()
                  : SizedBox(
                      height: 10,
                    ),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : prodList.length == 0
                      ? keyWordList.length == 0
                          ? Center(
                              child: Container(
                                child: Text("No items found!"),
                              ),
                            )
                          : Flexible(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: List.generate(
                                          keyWordList.length, (index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              searchController.text =
                                                  keyWordList[index]["keyword"];
                                            });
                                            fetchProduct(
                                                keyWordList[index]["keyword"]);
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Text(keyWordList[index]
                                                      ["keyword"]),
                                                  GestureDetector(
                                                    onTap: () {
                                                      deleteKeyword(
                                                          keyWordList[index]
                                                              ["keyword"]);
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 19,
                                                        )),
                                                  )
                                                ],
                                              )),
                                        );
                                      })),
                                ),
                              ),
                            )
                      : Flexible(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                  children:
                                      List.generate(prodList.length, (index) {
                                return AllProductCard(
                                    prod_item: prodList[index]);
                              })),
                            ),
                          ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
