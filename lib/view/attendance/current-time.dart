import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class CurrentTime extends StatelessWidget {
  const CurrentTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      child: DigitalClock(
        is24HourTimeFormat: false,
        digitAnimationStyle: Curves.bounceIn,
        amPmDigitTextStyle:  TextStyle(
          color: Color(0xFFFF5630),
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        areaDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        hourMinuteDigitTextStyle:  TextStyle(
          color: Color(0xFF051C4B),
          fontSize: 25.sp,
          fontWeight: FontWeight.bold,

        ),
        showSecondsDigit : true,
        areaWidth : 180.0,
      ),
    );
  }
}