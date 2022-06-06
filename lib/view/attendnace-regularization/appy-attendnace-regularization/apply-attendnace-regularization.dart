import 'package:HRMS/controller/Leave/leave-list.dart';
import 'package:HRMS/controller/Leave/leaveType-controller.dart';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendnace-regularization/appy-attendnace-regularization/regularaization-form.dart';
import 'package:HRMS/view/attendnace-regularization/regularization-list/regularization-list.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/view/leave/leave-apply/widget/leave-form.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../attendance/attendance.dart';
import '../../profile/profile.dart';

class AttendanceRegularization extends StatefulWidget {
  int index;
  AttendanceRegularization({Key? key, required this.index}) : super(key: key);

  @override
  _AttendanceRegularizationState createState() => _AttendanceRegularizationState();
}

class _AttendanceRegularizationState extends State<AttendanceRegularization> {





  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: widget.index,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          //
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
                text: "List",
              ),
              Tab(
                text: "Apply",
              ),

            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(
              child: ApplyAttendanceRegularizationList(),
            ),
            Center(
              child: RegularaizationForm(),

            ),

          ],
        ),
      ),
    );
  }



}


