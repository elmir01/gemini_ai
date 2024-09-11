import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 15.sp).copyWith(
          left: isUser ? 100.sp : 10.sp,
          right: isUser ? 10.sp : 100.sp,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.green : Colors.pink.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.sp),
            bottomLeft: isUser ? Radius.circular(5.sp) : Radius.zero,
            topRight: Radius.circular(5.sp),
            bottomRight: isUser ? Radius.zero : Radius.circular(5.sp),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.sp),
              child: Text(
                '$message',
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0.sp),
              child: Text(
                date,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
