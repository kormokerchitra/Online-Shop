import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';

class SearchProduct extends StatefulWidget {
  final String cat_id;

  SearchProduct({this.cat_id});
  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Animation<double> animation;
  AnimationController controller;
  String result = '';
  TextEditingController searchController = TextEditingController();
  var productBody;
  var prodList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
        if (widget.cat_id == "") {
          for (int i = 0; i < cc; i++) {
            prodList.add(productBody["product_list"][i]);
          }
        } else {
          for (int i = 0; i < cc; i++) {
            if (widget.cat_id == productBody["product_list"][i]["cat_id"]) {
              prodList.add(productBody["product_list"][i]);
            }
          }
        }

        isLoading = false;
      });
      print("prodList.length");
      print(prodList.length);
    } else {
      throw Exception('Unable to fetch products from the REST API');
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
                Text("Product Search",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
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
                  contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  if (val != "") {
                    setState(() {
                      isLoading = true;
                      result = val;
                      fetchProduct(result);
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            prodList.length == 0
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${prodList.length} items found",
                      style: TextStyle(color: mainheader),
                    ),
                  ),
            prodList.length == 0
                ? Container()
                : SizedBox(
                    height: 10,
                  ),
            prodList.length == 0
                ? Center(
                    child: Container(
                      child: Text("No items found!"),
                    ),
                  )
                : Flexible(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        child: Column(
                            children: List.generate(prodList.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, prodList[index]);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(prodList[index]["product_name"]),
                            ),
                          );
                        })),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
