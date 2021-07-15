import 'package:assignment/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Widget customDialog(String title, String message) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'))
      ],
    );
  }

  loginUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String email = emailController.text;
    String password = passwordController.text;
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot snap =
          await db.collection("user-data").doc(user.user.uid).get();
      final data = snap.data();
      emailController.text = "";
      passwordController.text = "";
      showDialog(
          context: context,
          builder: (context) {
            return customDialog(
                "Successfully Logged in",
                "username : " +
                    data["username"] +
                    "\nEmail : " +
                    data["email"]);
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return customDialog(
                  "Error", "Please enter correct email and password.");
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return customDialog("Error", "You entered wrong password.");
            });
      }
    }

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyApp.callAppbar(),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 100.w,
              height: 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90.w,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(
                                width: 2.sp,
                                color: Colors.blue,
                                style: BorderStyle.solid))),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 8.5.h,
                    width: 90.w,
                    child: TextFormField(
                      style: TextStyle(fontSize: 20.sp),
                      controller: emailController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          labelText: 'Enter Email',
                          labelStyle: TextStyle(fontSize: 12.sp)),
                    ),
                  ),
                  Container(
                    height: 8.5.h,
                    width: 90.w,
                    child: TextFormField(
                      style: TextStyle(fontSize: 20.sp),
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          labelText: 'Enter Password',
                          labelStyle: TextStyle(fontSize: 12.sp)),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: loginUser,
                      child: Text('Login',
                          style: TextStyle(
                            fontSize: 14.sp,
                          )))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
