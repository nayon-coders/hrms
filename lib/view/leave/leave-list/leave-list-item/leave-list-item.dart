
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/analysis_options.yaml';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../global_widget/big_text.dart';
import '../../../global_widget/mediun_text.dart';
class LeaveListItem extends StatelessWidget {
  final String date;
  final String status;
  final VoidCallback editFunction;
  final String startDate;
  final String endDate;
  final String totalDays;
  final String reason;
  final String leaveReason;
  final Color color;

  LeaveListItem({Key? key,
    required this.color,
    required this.date,
    required this.status,
    required this.editFunction,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.leaveReason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: appColors.white,
        border: Border(
          left: BorderSide(width: 10.0, color: appColors.successColor),
        ),
        //borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediunText(text: "Dec 23, 2018", size: 9, color: appColors.gray,),

              Row(
                children: [
                  BigText(text: "Present", size: 12, color: appColors.successColor,),
                  const SizedBox(width: 10,),
                  Icon(
                    Icons.edit,
                    color: appColors.mainColor,
                    size: 20,
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Start Date", color: appColors.gray, size: 8.sp,),
                  MediunText(text: "5:50 PM	", color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "End Date", color: appColors.gray, size: 8.sp,),
                  MediunText(text: "5:50 PM	", color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Total", color: appColors.gray, size: 8.sp,),
                  MediunText(text: "06:50:50", color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Reason", color: appColors.gray, size: 8.sp,),
                  MediunText(text: "06:50:50", color: appColors.black, size: 8.sp,)
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediunText(text: "Leave Reason: ", size: 10.sp,),
              Text("Clarification For Regularization Clarification For RegularizationClarification For Regularization",
                style: TextStyle(
                    color: appColors.gray,
                    fontSize: 9.sp
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
