import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'addEmpForm.dart';

class TeamMembers extends StatefulWidget {
  const TeamMembers({Key key}) : super(key: key);

  @override
  _TeamMembersState createState() => _TeamMembersState();
}

class _TeamMembersState extends State<TeamMembers> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  // final String documentId;
  //
  // GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  //onPressed: onPressed,
                  icon: Icon(Icons.arrow_back),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Team Members")
              ],
            ),
            check(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: ()  {
                  Route route = MaterialPageRoute(builder: (c) => addEmpForm());
                  Navigator.pushReplacement(context, route);
                },
                    child: Text("Add New Employee")
                )
              ],
            )
          ],
        ),
      ),
    );
  }


}


check(){
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Users').snapshots();


  return StreamBuilder<QuerySnapshot>(
    stream: _usersStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      return new ListView(
        shrinkWrap: true,
        children: snapshot.data.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return new ListTile(
            title: new Text(data['name']),
            subtitle: new Text(data['role']),
            trailing: IconButton(
              onPressed: ()=> empPop(context),
              icon: Icon(Icons.arrow_forward),),
          );
        }).toList(),
      );
    },
  );
}

  empPop(BuildContext context) {
 showDialog(
   context: context,
   builder:(_)=> SimpleDialog(
      title: const Text("Choose an option"),
      children: [
        SimpleDialogOption(
          onPressed: (){},
          child: const Text("Edit"),
        ),
        SimpleDialogOption(
          onPressed: (){},
          child: const Text("View"),
        )
      ],
    ),
 );
}
