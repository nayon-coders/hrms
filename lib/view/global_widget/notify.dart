import 'package:HRMS/utility/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class Notify{
  String title;
  String body;
  Color color;
  Notify({required this.title, required this.body, required this.color});

 Flushbar notify(BuildContext context){
    return Flushbar(
      title: title,
      titleColor: appColors.white,
      message: body,
      icon:  Icon(
        Icons.done,
        size: 28.0,
        color: color,
      ),
      messageSize: 12.sp,
      messageColor: color,
      borderWidth: 1,
      borderColor: Colors.grey,
      margin: EdgeInsets.all(6.0),
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      textDirection: Directionality.of(context),
      borderRadius: BorderRadius.circular(12),
      duration: Duration(seconds: 4),
      leftBarIndicatorColor: color,
    )..show(context);
  }
}
