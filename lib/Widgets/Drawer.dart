import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timepunchtimesheet/screens/Employee/OptionsScreen.dart';
import 'package:timepunchtimesheet/screens/Employee/StatsScreen.dart';

class Drawers extends StatefulWidget {
  const Drawers({Key key}) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,

      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    foregroundImage: user.photoURL == null ? AssetImage('lib/Images/—Pngtree—dark gray simple avatar_6404677.png') : user.displayName,
                    minRadius: MediaQuery.of(context).size.width * 0.15,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
           RawMaterialButton(
               onPressed: () {},
               elevation: 2.0,
               fillColor: Colors.white,
               padding: EdgeInsets.all(15.0),
               shape: CircleBorder(),
               child: Icon(Icons.home)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          RawMaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatisticsScreen()));
              },
              elevation: 2.0,
              fillColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Icon(Icons.timer)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          RawMaterialButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OptionsScreen()));
              },
              elevation: 2.0,
              fillColor: Colors.white,
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
              child: Icon(Icons.settings)),

        ],
      ),
    );
  }
}

