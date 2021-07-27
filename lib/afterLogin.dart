import 'package:assignment/main.dart';
import 'package:assignment/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AfterLogin extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> _postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('After Login Page'),
        actions: [
          IconButton(
              onPressed: () async {
                auth.signOut();
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 100.w,
            height: 100.h,
            child: Column(
              children: [
                Container(
                    width: 100.w,
                    height: 20.h,
                    color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: TextField(
                                  decoration:
                                      InputDecoration(hintText: 'Enter Title'),
                                )),
                            Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Pick Image'),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Enter Decription'),
                                )),
                            Expanded(
                                flex: 1,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Save'),
                                ))
                          ],
                        ),
                      ],
                    )),
                Container(
                    width: 100.w,
                    height: 80.h,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _postStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Something went wrong'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: Text("Loading"));
                        }

                        return new ListView(
                          // physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map data = document.data();
                            return Post(
                              data: data,
                            );
                          }).toList(),
                        );
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
