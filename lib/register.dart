import 'package:assignment/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

// // ignore: import_of_legacy_library_into_null_safe
// import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();

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

  registerUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await db.collection("user-data").doc(user.user.uid).set({
        "username": username,
        "email": email,
      });
      usernameController.text = "";
      emailController.text = "";
      passwordController.text = "";
      showDialog(
          context: context,
          builder: (context) {
            return customDialog("Successfull", "Your account is created.");
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (context) {
              return customDialog("ERROR", "Your given password is weak.");
            });
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (context) {
              return customDialog("ERROR",
                  "Choose another email\nThis email is already in use.");
            });
      }
    }

    return CircularProgressIndicator();
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
                      'Register',
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
                      controller: usernameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          labelText: 'Enter Username',
                          labelStyle: TextStyle(fontSize: 12.sp)),
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
                      onPressed: registerUser,
                      child: Text('Register',
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
