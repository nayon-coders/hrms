import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class ListOfMenu extends StatelessWidget {
  String text;
  String image;
  double? TextSize;
  Color? bgColor;
  ListOfMenu({Key? key,
    required this.text,
    required this.image,
    this.TextSize = 10,
    this.bgColor = appColors.bg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(image,
            width: 5.h,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10,),
          MediunText(text: text, color: appColors.black, size: TextSize,),
          
        ],
      ),
    );
  }
}
