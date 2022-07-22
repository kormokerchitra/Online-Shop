import 'dart:ui' as prefix0;

import 'package:online_shopping/Cards/NotifyCard/notifyCard.dart';
import 'package:online_shopping/MainScreens/NotifyDetailsPage/notifydet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';

class NotifyPage extends StatefulWidget {
  final List notifyList;
  NotifyPage(this.notifyList);

  @override
  State<StatefulWidget> createState() {
    return NotifyPageState();
  }
}

class NotifyPageState extends State<NotifyPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool _isLoggedIn = false;
  String _debugLabelString = "";
  bool _requireConsent = false;

  @override
  void initState() {
    super.initState();
    changeNotifySeen();
  }

  Future<void> changeNotifySeen() async {
    for (int i = 0; i < widget.notifyList.length; i++) {
      if (widget.notifyList[i]["seen"] == "0") {
        final response = await http.post(
          ip + 'easy_shopping/notification_seen_update.php',
          body: {
            "notification_id": widget.notifyList[i]["notification_id"],
            "receiver": widget.notifyList[i]["receiver"],
          },
        );
        if (response.statusCode == 200) {
          print(response.body);
          if (response.body == "Success") {
            print("Seen");
          }
        } else {
          throw Exception('Unable to fetch counter from the REST API');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Notification",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: sub_white,
        child: Container(
          margin: EdgeInsets.only(left: 0, right: 0),
          color: sub_white,
          width: MediaQuery.of(context).size.width,
          ////// <<<<< Notifacation List >>>>> //////
          child: widget.notifyList.length == 0
              ? Center(
                  child: Container(
                    child: Text("No notifications available!"),
                  ),
                )
              : new ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      ////// <<<<< Notifacation List >>>>> //////
                      NotifyCard(widget.notifyList[index]),
                  itemCount: widget.notifyList.length,
                ),
        ),
      ),
    );
  }
}
