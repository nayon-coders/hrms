import 'package:HRMS/controller/Leave/leave-list.dart';
import 'package:HRMS/controller/Leave/leaveType-controller.dart';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/view/leave/leave-apply/widget/leave-form.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../attendance/attendance.dart';
import '../../profile/profile.dart';

class LeaveApply extends StatefulWidget {
  int index;
  LeaveApply({Key? key, required this.index}) : super(key: key);

  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {
  @override
  Widget build(BuildContext context) {

   return DefaultTabController(
      initialIndex: widget.index,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //
          title: MediunText(text: "Leave", color:  appColors.white, size: 10.sp,),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff00315E),
                    Color(0xff580082),
                  ],
                )
            ),
          ),
          bottom: TabBar(
            tabs: [

              Tab(
                text: "Leave Apply",
              ),
              Tab(
                text: "Leave List",
              ),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: LeaveForm(),

            ),
            Center(
              child: LeaveList(),

            ),

          ],
        ),
      ),
    );
  }



}


