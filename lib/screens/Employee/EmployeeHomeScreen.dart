import 'dart:async';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';

import '../../notification_service.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({Key key}) : super(key: key);

  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {

  Stopwatch _stopwatch = Stopwatch();
  User user = FirebaseAuth.instance.currentUser;
  Timer _timer;
  String nowt ;
  String status;
  DateTime d;
  double t = 0;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String elapsedTime = '';
  IconData btn = Icons.play_arrow;


  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      'your channel id', 'your channel name',
      importance: Importance.defaultImportance,
      priority: Priority.min,
      showWhen: false,
      );
  static const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  DateTime x = DateTime.now();


  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    // re-render every 30ms
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    getNowTime();
    Duration duration = Duration(hours: 8);
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;

    status = currentStatus();


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
              Text(nowt),
            ],
          ),
          drawer: Drawer(),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Greetings ' + '' +
                      FirebaseAuth.instance.currentUser.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.025
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Role: ',style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.025
                  ),
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                CircularPercentIndicator(
                  radius:
                      width * 0.7,
                  lineWidth: 15.0,
                  percent: _stopwatch.elapsed.inMicroseconds / duration.inMicroseconds,
                  center: Center(
                    child: IconButton(
                      iconSize: height * 0.25,
                      padding: EdgeInsets.all(0),
                      icon: !_stopwatch.isRunning ? Icon(btn,color: Colors.white,): Icon(btn,color: Colors.white,),
                      onPressed:() => clockInOut(),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.square,
                  backgroundColor: Colors.white,
                  progressColor: Colors.green,
                ),
                SizedBox(height: height * 0.1,),
                Center(
                  child: Text(
                    'Time elapsed: ' + formatTime(_stopwatch.elapsedMilliseconds),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.025
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


  void getNowTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(now);
    setState(() {
      nowt = formatted;
    });

  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');

    return "$hours:$minutes:$seconds";
  }

  Future<void> clockInOut() async {
    if (_stopwatch.isRunning) {
     stopWatch();
     setState(() {
       btn = Icons.play_arrow;
     });
    } else {
      _stopwatch.start();
      setState(() {
        elapsedTime = formatTime(_stopwatch.elapsedMilliseconds);
        btn = Icons.pause;
      });

      setState(() {});
    }

    while (_stopwatch.isRunning) {
      await flutterLocalNotificationsPlugin.show(
          0, 'Clocked in', formatTime(_stopwatch.elapsedMilliseconds),
          platformChannelSpecifics,
          payload: 'item x');
    }
    setState(() {});
  }

  startWatch() {
    setState(() {
      _stopwatch.start();

    });
  }

  setTime() {
    var timeSoFar = _stopwatch.elapsedMilliseconds;
    setState(() {
      elapsedTime = formatTime(timeSoFar);
    });
  }

  stopWatch() {
    setState(() {
      _stopwatch.stop();
      setTime();
    });
  }



  String currentStatus() {
    if (_stopwatch.isRunning) {
      return "On the Clock";
    } else {
      if (_stopwatch.elapsed != Duration.zero) {
        return "On Break";
      } else {
        return "Off the Clock";
      }
    }
  }

  Future<void> clockOut() async {
    stopWatch();
    _stopwatch.reset();
    //save time, date and project.......maybe
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData.toString());
    await flutterLocalNotificationsPlugin.cancel(0);
  }
}




