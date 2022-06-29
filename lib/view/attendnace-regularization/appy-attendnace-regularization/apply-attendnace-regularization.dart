import 'package:HRMS/controller/Leave/leave-list.dart';
import 'package:HRMS/controller/Leave/leaveType-controller.dart';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendnace-regularization/appy-attendnace-regularization/regularaization-form.dart';
import 'package:HRMS/view/attendnace-regularization/regularization-list/regularization-list.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../global_widget/mediun_text.dart';

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen())),
          ),
          title: MediunText(text: "Attendance Regularization", color:  appColors.white, size: 10.sp,),
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
                text: "Apply",
              ),
              Tab(
                text: "List",
              ),

            ],
          ),
        ),
        body: const TabBarView(
          children: [

            Center(
              child: RegularaizationForm(),

            ),
            Center(
              child: ApplyAttendanceRegularizationList(),
            ),

          ],
        ),
      ),
    );
  }



}


