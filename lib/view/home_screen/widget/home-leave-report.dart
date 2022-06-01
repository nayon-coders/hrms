import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';

class HomeLeaveReports extends StatelessWidget {
  HomeLeaveReports({Key? key}) : super(key: key);

  final colorList = [
    appColors.successColor,
    appColors.dangerColor,
    appColors.secondColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 3.h),
      decoration: BoxDecoration(
        color: appColors.gray200,
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
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediunText(text: "Leave", size: 11.sp,),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  child: PieChart(
                    legendOptions: LegendOptions(
                        showLegends: false
                    ),
                    dataMap: {
                      "Remaining": 15,
                      "Taken": 5,
                      "Total": 20,
                    },
                    colorList: colorList,
                    ringStrokeWidth: 15,
                    chartLegendSpacing: 500,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey[300]!,
                    chartValuesOptions: ChartValuesOptions(
                        showChartValues: false,
                        showChartValuesOutside: false
                    ),


                  ),
                ),

                Column(
                  children: [
                    BigText(text: "15", color: appColors.successColor, size: 12.sp,),
                    MediunText(text: "Remaining", color: appColors.black, size: 9.sp,)
                  ],
                ),
                Column(
                  children: [
                    BigText(text: "05", color: appColors.dangerColor, size: 12.sp,),
                    MediunText(text: "Taken", color: appColors.black, size: 9.sp,)
                  ],
                ),
                Column(
                  children: [
                    BigText(text: "20", color: appColors.secondColor, size: 12.sp,),
                    MediunText(text: "Total", color: appColors.black, size: 9.sp,)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
