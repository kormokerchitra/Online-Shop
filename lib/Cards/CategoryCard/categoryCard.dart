import 'package:flutter/material.dart';
import 'package:online_shopping/MainScreens/AllProductPage/allProductPage.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/AllCartPage/allCartPage.dart';
import 'package:online_shopping/MainScreens/ProductDetailsPage/details.dart';

class CategoryCard extends StatefulWidget {
  final cat_item;
  CategoryCard(this.cat_item);
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          border: Border.all(width: 0.2, color: Colors.grey)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllProductPage(
                      cat_id: widget.cat_item["cat_id"],
                      cat_name: widget.cat_item["cat_name"],
                    )),
          );
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 0),
                    padding: EdgeInsets.only(top: 5),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.category, color: Colors.black54, size: 16),
                        Container(
                          margin: EdgeInsets.only(left: 3),
                          child: Text(
                            widget.cat_item["cat_name"],
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
