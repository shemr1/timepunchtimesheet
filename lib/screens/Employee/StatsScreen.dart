import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:timepunchtimesheet/Widgets/Drawer.dart';


class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  User user = FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {

    var userTime = FirebaseFirestore.instance.collection(user.uid).doc("timeStamps").snapshots();
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawers(),
      body:StreamBuilder (
        stream: userTime,
        builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
          return !snapshot.hasData
          ? Center(child: CircularProgressIndicator(backgroundColor: Colors.red,))
          : ListView.builder(
            itemCount: snapshot.data.data().,
          itemBuilder: (context,index){
            DocumentSnapshot data = snapshot.data.data()[index];
            return Card(
              child: ListTile(
                      title: Text(data["Date"]),
                      subtitle: Text(data ["Time worked"]),
                ),
            );

          }
          );
        },
      )
    );
  }

}

