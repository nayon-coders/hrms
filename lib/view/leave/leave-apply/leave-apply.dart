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
import '../../profile/profile.dart';

class LeaveApply extends StatefulWidget {
  const LeaveApply({Key? key}) : super(key: key);

  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: appColors.white,
        body: Column(
          children: [
            TopBar(
                icon: Icons.info_outline,
                text: "Apply For Leave",
                goToBack: ()=>Navigator.pop(context),

                ),

              Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaveApply()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 3, color: appColors.secondColor)
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Center(child: MediunText (text: "Leave Apply", size: 10.sp, color: appColors.secondColor,)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaveList()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/2,
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 3, color: appColors.gray)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Center(child: MediunText (text: "Leave Apply", size: 10.sp, color: appColors.gray,)),
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
                    children: [
                      LeaveForm(),
                    ],
                  )
                ),
              )




          ],
        ),



        bottomNavigationBar: BottomNavigation(),

    );
  }
}