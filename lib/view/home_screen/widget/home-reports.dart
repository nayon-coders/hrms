import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';

class HomeReports extends StatelessWidget {
   HomeReports({Key? key}) : super(key: key);

  final colorList = [
    [appColors.successColor],
    [appColors.dangerColor],
    [appColors.secondColor],
  ];

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
        child: Column(
          children: [
            PieChart(
              centerText: "Attendance",
              dataMap: {
                "Present": 5,
                "Absent": 3,
                "Late": 2,
              },
                ringStrokeWidth: 15,
                chartLegendSpacing: 180,
              chartType: ChartType.ring,
              baseChartColor: Colors.grey[300]!,
              chartValuesOptions: ChartValuesOptions(
                  showChartValues: false,
                showChartValuesOutside: false
              ),


            ),
          ],
        ),
    );
  }
}
