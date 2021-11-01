
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timepunchtimesheet/screens/Admin/TeamMembers.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

FirebaseAuth user = FirebaseAuth.instance;

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(" Hey, " + user.currentUser.displayName),
                    SizedBox(
                      width: width * 0.7,
                    ),
                    IconButton(onPressed: logout, icon: Icon(Icons.logout))
                  ],
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Text(
                  "Admin Panel"
                ),
                Center(
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: height *0.25,
                            width: width * 0.25,
                            child: Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                   onPressed:() {
                                     Route route = MaterialPageRoute(builder: (
                                         c) => TeamMembers());
                                     Navigator.pushReplacement(context, route);

                                   },
                                  icon: Icon(Icons.account_circle_rounded,size: MediaQuery.of(context).size.longestSide * 0.1,)),
                            ),
                          ),
                          Text(
                            "Team Members",
                            style: TextStyle(
                              color: Colors.white,
                                decoration: TextDecoration.underline,
                                fontSize: MediaQuery.of(context).size.longestSide * 0.025
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: height *0.25,
                            width: width * 0.25,
                            child: Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                // onPressed: onPressed,
                                  icon: Icon(Icons.account_circle_rounded,
                                    size: MediaQuery.of(context).size.longestSide * 0.1,)),
                            ),
                          ),
                          Text(
                              "Projects",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.longestSide * 0.025
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height *0.25,
                            width: width * 0.25,
                            child: Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                // onPressed: onPressed,
                                  icon: Icon(Icons.account_circle_rounded,
                                  size: MediaQuery.of(context).size.longestSide * 0.1,)),
                            ),
                          ),
                          Text(
                              "Reports",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.longestSide * 0.025
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: height *0.25,
                            width: width * 0.25,
                            child: Card(
                              shape: CircleBorder(),
                              child: IconButton(
                                // onPressed: onPressed,
                                  icon: Icon(Icons.account_circle_rounded,
                                    size: MediaQuery.of(context).size.longestSide * 0.1,)),
                            ),
                          ),
                          Text(
                              "Company Partners",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.longestSide * 0.025
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}
