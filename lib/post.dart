import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Post extends StatelessWidget {
  final Map data;
  Post({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, width: 2, style: BorderStyle.solid)),
        width: 100.w,
        child: Column(
          children: [
            Image(
                height: 25.h,
                width: 25.w,
                image: NetworkImage(
                  data["url"],
                )),
            Text(data["Title"]),
            Text(data["Description"]),
          ],
        ),
      ),
    );
  }
}
