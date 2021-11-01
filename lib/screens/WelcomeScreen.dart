import 'package:flutter/material.dart';
import 'package:timepunchtimesheet/authentication/Login.dart';
import 'package:timepunchtimesheet/authentication/Registration.dart';
import 'package:timepunchtimesheet/screens/Admin/AdminHomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/Images/pexels-olya-kobruseva-5417661.jpg'),
                    fit: BoxFit.fill,
                  )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(

                  ),
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.3,0,0,0),
                          tileColor: Colors.orangeAccent,
                          leading: Icon(
                              Icons.person
                          ),
                          title: Text ("Login"),
                          onTap: () {
                            Route route = MaterialPageRoute(builder: (c) => Login());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(

                          contentPadding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width *0.3,0,0,0),

                          tileColor: Colors.deepOrangeAccent,
                          leading: Icon(
                              Icons.business
                          ),
                          title: Text ("Register"),

                          onTap: () {
                            Route route = MaterialPageRoute(builder: (c) => Registration());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
