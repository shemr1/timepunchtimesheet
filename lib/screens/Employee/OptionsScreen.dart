import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timepunchtimesheet/screens/WelcomeScreen.dart';


class OptionsScreen extends StatefulWidget {
  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

bool isLoggedIn = true;




class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Material(
      child: Scaffold(
          body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            Row(
            children: [
              Text(""),
            ],
            ),
            Text(
              "Account",
              style: TextStyle(fontSize: height * 0.05),
            ),
            Card(
              child: ListTile(
                title: Text(
                  "Account",
                ),
              ),
            ),
            SizedBox(height: height * 0.1),
            Text(
              "Settings",
              style: TextStyle(fontSize: height * 0.05),
            ),
            Card(
              child: ListTile(
                title: Text("Notification"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Privacy"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Help Center"),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("About us"),
              ),
            ),
            ElevatedButton(
                 onPressed:() async {
                   await FirebaseAuth.instance.signOut();
                   Route route = MaterialPageRoute(builder: (c) => WelcomeScreen());
                   Navigator.pop(context);
                   Navigator.push(context, route);
                 },

                child: Text("Logout"))
          ],
        ),
      )),
    );
  }

   void logout() async{
    await FirebaseAuth.instance.signOut();
  }


}
