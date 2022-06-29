import 'dart:ui';
import 'package:flutter/material.dart';
class appColors{
  static const Color white = Color(0xffffffff);
  static const Color mainColor = Color(0xff0C3887);
  static const Color secondColor = Color(0xffFE5709);
  static const Color lightSecondColor = Color(0xffffebe1);
  static const Color listOfMenuColor = Color(0xffEDF6FF);
  static const Color black = Color(0xff333333);
  static const Color successColor = Color(0xff0CAE91);
  static const Color dangerColor = Color(0xffBE0000);
  static const Color bg = Color(0xffF1F8FF);
  static const Color gray = Color(0xff7E7E7E);
  static const Color gray200 = Color(0xffdddddd);
  static  Color grdent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[
      Color(0xff00315E),
      Color(0xff580082),
    ],
  ) as Color;
}