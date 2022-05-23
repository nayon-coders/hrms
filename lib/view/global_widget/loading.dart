import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingBtn extends StatelessWidget {
  Color? bgColor;
  LoadingBtn({Key? key, this.bgColor = appColors.secondColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: bgColor
      ),
      child: Center(child:
      CircularProgressIndicator(
        color: appColors.white,
        strokeWidth: 3,
      ), ),
    );
  }
}
