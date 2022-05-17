import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BigText extends StatelessWidget {
  String text;
  double? size;
   BigText({required this.text, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: size?.sp,
        color: appColors.white
      ),
    );
  }
}
