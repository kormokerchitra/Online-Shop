import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_shopping/MainScreens/NavigationDrawerPages/OrderPage/orders.dart';
import 'package:online_shopping/MainScreens/NotifyDetailsPage/notifydet.dart';

class NotifyCard extends StatefulWidget {
  final notifyItem;
  NotifyCard(this.notifyItem);

  @override
  _NotifyCardState createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  String dayDiff = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTime();
  }

  getTime() {
    var now = DateTime.now();
    var formatterDate = DateFormat('yyyy-MM-dd HH:mm:ss');
    String todayDate = formatterDate.format(now);
    String itemDate = widget.notifyItem["datetime"];

    DateTime dt1 = DateTime.parse(todayDate);
    DateTime dt2 = DateTime.parse(itemDate);

    Duration diff = dt1.difference(dt2);

    int diffDay = diff.inDays;
    print("diffDay");
    print(diffDay);

    if (diffDay == 0) {
      dayDiff = "Today";
    } else if (diffDay == 1) {
      dayDiff = "1 day ago";
    } else {
      dayDiff = "$diffDay days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderPage(inv_id: widget.notifyItem["inv_id"],)),
          );
        },
        child: Container(
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
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10, left: 0),
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/logo.jpg')),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Order status changed to ${widget.notifyItem["status"]} for invoice id #${widget.notifyItem["inv_id"]}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                dayDiff,
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
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
