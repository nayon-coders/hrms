import 'package:HRMS/utility/colors.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeReports extends StatelessWidget {
  const HomeReports({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 3.h),
            decoration: BoxDecoration(
              color: appColors.white,
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
      child: Expanded(
        child: Column(
          children: [
            DChartGauge(
              data: [
                {'domain': 'Off', 'measure': 30},
                {'domain': 'Warm', 'measure': 30},
                {'domain': 'Hot', 'measure': 30},
              ],
              fillColor: (pieData, index) {
                switch (pieData['domain']) {
                  case 'Off':
                    return Colors.green;
                  case 'Warm':
                    return Colors.orange;
                  default:
                    return Colors.red;
                }
              },
              showLabelLine: false,
              pieLabel: (pieData, index) {
                return "${pieData['domain']}";
              },
              labelPosition: PieLabelPosition.inside,
              labelPadding: 0,
              labelColor: Colors.white,
            ),

          ],
        ),
      ),
    );
  }
}
