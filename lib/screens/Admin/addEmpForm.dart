import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timepunchtimesheet/Widgets/customTextField.dart';
import 'package:timepunchtimesheet/screens/Admin/AdminHomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';




class addEmpForm extends StatefulWidget {
  const addEmpForm({Key key}) : super(key: key);


  @override
  _addEmpFormState createState() => _addEmpFormState();
}

class _addEmpFormState extends State<addEmpForm> {

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Text('Please Enter the credentials for your new employee'),
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
            SizedBox(height: height * 0.1,),
            ElevatedButton(onPressed: add(),
                child: Text(
                  "Add Employee"
                ),
            )
          ],
        ),
      ),
    );
  }


  add() async {
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
          Route route = MaterialPageRoute(builder: (c) => AdminHomeScreen());
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

