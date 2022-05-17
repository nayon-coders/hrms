import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MediunText extends StatelessWidget {
  String text;
  double? size;
  MediunText({required this.text, this.size = 10});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: size?.sp,
          color: appColors.white
      ),
    );
  }
}
