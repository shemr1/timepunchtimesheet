import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:timepunchtimesheet/Widgets/Drawer.dart';



class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key key}) : super(key: key);

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  User auth = FirebaseAuth.instance.currentUser;
  Stopwatch _stopwatch = Stopwatch();
  String nowt;

  String status;
  DateTime d;
  double t = 0;
  Location location = new Location();

  static const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.defaultImportance,
    priority: Priority.min,
    showWhen: false,
  );
  static const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  DateTime x = DateTime.now();

  bool isThere = false;

  String clockedIN = '';

  String clockedOut = '';

  @override
  Widget build(BuildContext context) {
    checkExist();
    getTime();
    checkPreviousOut();
    Duration duration = Duration(hours: 8);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Material(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          Text(x.toString()),
        ],
      ),
      drawer: Drawers(),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Greetings ' + '' + FirebaseAuth.instance.currentUser.displayName,
                style: TextStyle(color: Colors.white, fontSize: height * 0.025),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Role: ',
                style: TextStyle(color: Colors.white, fontSize: height * 0.025),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Center(
              child: CircularPercentIndicator(
                radius: width * 0.7,
                lineWidth: 15.0,
                percent: _stopwatch.elapsed.inMicroseconds / duration.inMicroseconds,
                center: Center(
                  child: IconButton(
                    iconSize: height * 0.25,
                    padding: EdgeInsets.all(0),
                    icon: isThere
                        ? Text(
                            "Clocked Out",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("Clocked In", style: TextStyle(color: Colors.white)),
                    onPressed: () => clockInOut(),
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.square,
                backgroundColor: Colors.white,
                progressColor: Colors.green,
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Column(
              children: [
                Text(
                  'Clocked In: ' + clockedIN,
                  style: TextStyle(color: Colors.white, fontSize: height * 0.025),
                ),
                Text(
                  'Clocked Out: ' + clockedOut,
                  style: TextStyle(color: Colors.white, fontSize: height * 0.025),
                ),
                // Text(
                //   'Duration: ' + clockedOut.,
                //   style:
                //   TextStyle(color: Colors.white, fontSize: height * 0.025),
                // ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  clockInOut() async {
    String formatted = DateFormat('yyyy-MM-dd').format(x);

    var collection = FirebaseFirestore.instance.collection("Users").doc(auth.uid);
    var books = collection.collection("timeStamps");

    Duration z;
    String time;

    books.doc(formatted).get().then((value) => {
          if (!value.exists)
            {
              books.doc(formatted).set({"Date": DateFormat.yMd().format(DateTime.now()), "Clocked in": DateTime.now()})
            }
          else
            {
              if (value.data().containsKey("Clocked in"))
                {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Clock Out?'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            SimpleDialogOption(
                              onPressed: () async {
                                await Future.delayed(Duration(seconds: 10));
                                z = DateTime.now().difference(value['Clocked in'].toDate());
                                time = _printDuration(z);
                                books.doc(formatted).update({"Clocked out": DateTime.now(), "Time worked": time});
                                Fluttertoast.showToast(msg: " Have a nice day");
                              },
                              child: const Text('Yes'),
                            )
                          ],
                        );
                      })
                }
              else
                {
                  if (value.data().containsKey("Clocked in") && value.data().containsKey("Clocked out"))
                    {Fluttertoast.showToast(msg: "You have already clocked in and out once today. Please speak to your supervisor if this was done in error.")}
                }
            }
        });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  checkExist() {
    String formatted = DateFormat('yyyy-MM-dd').format(x);
    FirebaseFirestore.instance.collection("Users").doc(auth.uid).collection("timeStamps").doc(formatted).get().then((DocumentSnapshot value) {
      if (value.exists) {
        this.setState(() {
          isThere = true;
        });
      }
    });
  }

  checkPreviousOut() {
    Duration z;
    String time;
    DateTime previous = DateTime.now().subtract(Duration(days: 1));
    String formatted = DateFormat('yyyy-MM-dd').format(previous);
    FirebaseFirestore.instance.collection("Users").doc(auth.uid).collection("timeStamps").doc(formatted).get().then((DocumentSnapshot value) {
      if (!value.data().toString().contains('Clocked out')) {
        print("No previous logout yesterday");
        z = DateTime.now().difference(value['Clocked in'].toDate());
        if (z.inHours > 12) {
          Fluttertoast.showToast(
              msg:
                  "You may have forgotten to clock out yesterday. Please contact your supervisor to amend issue. If this message doesn't apply to you ignore it as such ");
          time = _printDuration(z);
          FirebaseFirestore.instance
              .collection("Users")
              .doc(auth.uid)
              .collection("timeStamps")
              .doc(formatted)
              .update({"Clocked out": DateTime.now(), "Time worked": time, "Time worked seconds": z.inSeconds});
        } else {}
      }
    });
  }

  getTime() {
    String formatted = DateFormat('yyyy-MM-dd').format(x);
    FirebaseFirestore.instance.collection("Users").doc(auth.uid).collection("timeStamps").doc(formatted).get().then((DocumentSnapshot value) {
      if (value.exists) {
        this.setState(() {
          clockedIN = DateFormat.Hms().format(value['Clocked in'].toDate());
          clockedOut = DateFormat.Hms().format(value['Clocked out'].toDate());
        });
      }
    });
  }
}
