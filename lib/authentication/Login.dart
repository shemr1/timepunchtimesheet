import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timepunchtimesheet/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timepunchtimesheet/models/EmployeeModel.dart';
import 'package:timepunchtimesheet/screens/Admin/AdminHomeScreen.dart';
import 'package:timepunchtimesheet/screens/Employee/EmployeeHomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'Registration.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  AssetImage('lib/Images/pexels-olenka-sergienko-3794377.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.85,
                  height: height * 0.45,
                ),
                Text(
                  'Login',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30.0,
                ),
                CustomTextField(
                  controller: _emailTextController,
                  data: Icons.email,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  isObscure: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomTextField(
                  controller: _passwordTextController,
                  data: Icons.lock,
                  hintText: "Password",
                  textInputType: TextInputType.text,
                  isObscure: true,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forget password?',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      ElevatedButton(
                        child: Text('Login'),
                        style: ButtonStyle(),
                        onPressed: () {
                          loginUser();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Registration()));
                  },
                  child: Text.rich(
                    TextSpan(text: 'Don\'t have an account', children: [
                      TextSpan(
                        text: ' Signup',
                        style: TextStyle(color: Color(0xffEE7B23)),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (_passwordTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty) {
      final email = _emailTextController.text.trim();
      final password = _passwordTextController.text.trim();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        getRoleChoice(currentUser.uid, context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(msg: 'No user found for that email.');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(msg: "Wrong password provided for that user");
        }
      }
    }
  }
}

void getRoleChoice(uid, BuildContext context) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  DocumentSnapshot snapshot = await users.doc(uid).get();
  var data = snapshot.data() as Map;
  String role = data['role'];
  print (role);
  if (role == "employee") {
    Route route = MaterialPageRoute(builder: (c) => EmployeeHomeScreen());
    Navigator.pushReplacement(context, route);
  } else {
    Route route = MaterialPageRoute(builder: (c) => AdminHomeScreen());
    Navigator.pushReplacement(context, route);
  }
}
