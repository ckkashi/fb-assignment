import 'package:assignment/Home.dart';
import 'package:assignment/login.dart';
import 'package:assignment/register.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initalization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initalization,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Container(
                child: Text('Something went wrong.'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Sizer(builder: (context, orientation, deviceType) {
              return MaterialApp(
                title: 'FB Authentication Assignment',
                theme: ThemeData(primarySwatch: Colors.blue),
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  appBar: callAppbar(),
                  body: Home(),
                ),
                routes: {
                  "/home": (context) => Home(),
                  "/login": (context) => Login(),
                  "/register": (context) => Register(),
                },
              );
            });
          }
          return CircularProgressIndicator();
        });
  }

  static AppBar callAppbar() {
    return AppBar(
      title: Text('FB Authentication Assignment'),
      centerTitle: true,
    );
  }
}
