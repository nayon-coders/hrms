import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/bottom-navigation-button.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/tob-bar.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/leave/leave-apply/widget/leave-form.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../attendance/attendance.dart';
import '../../global_widget/big_text.dart';
import '../../profile/profile.dart';
import '../appy-attendnace-regularization/apply-attendnace-regularization.dart';

class ApplyAttendanceRegularizationList extends StatefulWidget {
  const ApplyAttendanceRegularizationList({Key? key}) : super(key: key);

  @override
  _ApplyAttendanceRegularizationListState createState() => _ApplyAttendanceRegularizationListState();
}

class _ApplyAttendanceRegularizationListState extends State<ApplyAttendanceRegularizationList> {

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: appColors.white,
      body: Column(
        children: [
          TopBar(
            icon: Icons.info_outline,
            text: "Create Regularization ",
            goToBack: ()=>Navigator.pop(context),

          ),

          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ApplyAttendanceRegularization()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 3, color: appColors.gray)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Center(child: MediunText (text: "Create Regularization", size: 9.sp, color: appColors.gray,)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>const LeaveList()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: const EdgeInsets.only(bottom: 15),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 3, color: appColors.secondColor)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Center(child: MediunText (text: "Regularization List", size: 9.sp, color: appColors.secondColor,)),
                      ),
                    ),
                  )
                ],
              )
          ),

          //Apply From.....
          Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),

                child: ListView(
                  children:  [
                    leaveListItem(
                        date: "May 20, 2022",
                        status: "Aspect",
                        editFunction: (){},
                        startDate: "May 20, 2022",
                        endDate: "may 25, 2022",
                        totalDays: "5",
                        reason: "Casual Leave",
                        leaveReason: "Clarification For Regularization Clarification For RegularizationClarification For Regularization",
                        color: appColors.successColor
                    ),
                    const SizedBox(height: 10,),
                    leaveListItem(
                        date: "May 20, 2022",
                        status: "Pending",
                        editFunction: (){},
                        startDate: "May 20, 2022",
                        endDate: "may 25, 2022",
                        totalDays: "5",
                        reason: "Casual Leave",
                        leaveReason: "Clarification For Regularization Clarification For RegularizationClarification For Regularization",
                        color: appColors.mainColor
                    ),
                    const SizedBox(height: 20,),
                    leaveListItem(
                        date: "May 20, 2022",
                        status: "Cancel",
                        editFunction: (){},
                        startDate: "May 20, 2022",
                        endDate: "may 25, 2022",
                        totalDays: "5",
                        reason: "Casual Leave",
                        leaveReason: "Clarification For Regularization Clarification For RegularizationClarification For Regularization",
                        color: appColors.secondColor
                    ),

                    const SizedBox(height: 20,),
                    leaveListItem(
                        date: "May 20, 2022",
                        status: "Aspect",
                        editFunction: (){},
                        startDate: "May 20, 2022",
                        endDate: "may 25, 2022",
                        totalDays: "5",
                        reason: "Casual Leave",
                        leaveReason: "Clarification For Regularization Clarification For RegularizationClarification For Regularization",
                        color: appColors.successColor
                    ),
                  ],
                )
            ),
          )




        ],
      ),



      bottomNavigationBar: const BottomNavigation(),

    );
  }
}
class leaveListItem extends StatelessWidget {
  final String date;
  final String status;
  final VoidCallback editFunction;
  final String startDate;
  final String endDate;
  final String totalDays;
  final String reason;
  final String leaveReason;
  final Color color;
  leaveListItem({
    required this.date,
    required this.status,
    required this.editFunction,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.leaveReason,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: appColors.white,
        border: Border(
          left: BorderSide(width: 10.0, color: color),
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
              MediunText(text: date, size: 9, color: appColors.gray,),

              Row(
                children: [
                  BigText(text: status, size: 12, color: color,),
                  const SizedBox(width: 10,),
                  Icon(
                    Icons.edit,
                    color: color,
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
                  MediunText(text: startDate, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "End Date", color: appColors.gray, size: 8.sp,),
                  MediunText(text: endDate, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Total", color: appColors.gray, size: 8.sp,),
                  MediunText(text: totalDays, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Reason", color: appColors.gray, size: 8.sp,),
                  MediunText(text: reason, color: appColors.black, size: 8.sp,)
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediunText(text: "Leave Reason: ", size: 10.sp,),
              Text(leaveReason,
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

