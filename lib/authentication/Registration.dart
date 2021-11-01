import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timepunchtimesheet/Widgets/customTextField.dart';
import 'package:timepunchtimesheet/models/EmployeeModel.dart';
import 'package:timepunchtimesheet/screens/Employee/EmployeeHomeScreen.dart';

import 'Login.dart';
import 'package:fluttertoast/fluttertoast.dart';



class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();



List <EmployeeModel> Emp= [];


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/Images/pexels-ann-nekr-5799379.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.2,
                    ),
                    Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    CustomTextField(
                      controller: _nameTextController,
                      data: Icons.person,
                      hintText: "Name",
                      textInputType: TextInputType.text,
                      isObscure: false,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    CustomTextField(
                      controller: _emailTextController,
                      data: Icons.email,
                      hintText: "Email",
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
                      height: 20.0,
                    ),
                    CustomTextField(
                      controller: _confirmTextController,
                      data: Icons.lock,
                      hintText: "Confirm Password",
                      textInputType: TextInputType.text,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: ElevatedButton(
                        onPressed: () => registerUser(),
                        style: ButtonStyle(),
                        child: Text("Register"),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text.rich(
                        TextSpan(text: 'Already have an account', children: [
                          TextSpan(
                            text: ' Login',
                            style: TextStyle(color: Color(0xffEE7B23)),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  registerUser() {
    if (_confirmTextController.text == _passwordTextController.text) {
      if
      (_nameTextController.text.isNotEmpty &&
          _emailTextController.text.isNotEmpty &&
          _passwordTextController.text.isNotEmpty &&
          _confirmTextController.text.isNotEmpty) {
        createAndSaveUser();
       // doUserRegistration();
      }else {
        Fluttertoast.showToast(msg: "Please completely fill out the form");
      }
    } else {
        Fluttertoast.showToast(msg: "Passwords do not match");
    }
  }
  // void doUserRegistration() async {
  //   final username = _nameTextController.text.trim();
  //   final email = _emailTextController.text.trim();
  //   final password = _passwordTextController.text.trim();
  //
  //   final user = ParseUser.createUser(username, password, email);
  //
  //   var response = await user.signUp();
  //
  //   if (response.success) {
  //     Fluttertoast.showToast(msg: "User successfully created");
  //     Route route = MaterialPageRoute(builder: (c) => EmployeeHomeScreen());
  //     Navigator.pushReplacement(context, route);
  //   } else {
  //     Fluttertoast.showToast(msg: response.error.message);
  //   }
  // }
  //
  //
  createAndSaveUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );
      if (userCredential != null ){
        saveUserInfoToFirestore(userCredential.user).then((value) {
          userCredential.user.updateDisplayName( _nameTextController.text.trim());
          Fluttertoast.showToast(msg: "Welcome");
          Route route = MaterialPageRoute(builder: (c) => EmployeeHomeScreen());
          Navigator.pushReplacement(context, route);

        });
      }
    }on FirebaseAuthException catch (e){
      if (e.code == 'email-already-in-use'){
        Fluttertoast.showToast(msg: "An account already exists for this email");
      }
    }
    }


  Future<void> saveUserInfoToFirestore(User firebaseUser) async {

     await FirebaseFirestore.instance.collection("Users").doc(firebaseUser.uid).set({
      "uid": firebaseUser.uid,
      "email": _emailTextController.text.trim(),
      "name": _nameTextController.text.trim(),
       "role": "employee",
    });

  }



}
