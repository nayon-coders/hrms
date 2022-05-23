import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance-list/attendance-list.dart';
import 'package:HRMS/view/attendance/attendance.dart';
import 'package:HRMS/view/attendnace-regularization/appy-attendnace-regularization/apply-attendnace-regularization.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/widget/home-leave-report.dart';
import 'package:HRMS/view/home_screen/widget/home-attendance-reports.dart';
import 'package:HRMS/view/home_screen/widget/list-of-menu.dart';
import 'package:HRMS/view/leave/leave-apply/leave-apply.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:HRMS/view/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var Name;
  var Email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _UserInfo();
  }
  void _UserInfo() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString("name");
    var email = localStorage.getString("email");

    setState(() {
      Name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
               Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/4,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(0xff00315E),
                          Color(0xff580082),
                        ],
                      )),
                  ),

               Padding(
                   padding: EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Row(
                       children: [
                         GestureDetector(
                           onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                           },
                           child: ClipRRect(
                               borderRadius: BorderRadius.circular(100),
                               child: Image.asset("assets/images/user.jpg",
                                 fit: BoxFit.cover,
                                 height: 50,
                                 width: 50,
                               )

                           ),
                         ),
                         const SizedBox(width: 10,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             BigText(text: "Hi, Good Morning", color: appColors.white, size: 13, ),
                             SizedBox(height: 5,),
                             MediunText(text: "${Name}", size: 10, color: appColors.white, ),
                           ],
                         ),
                       ],
                     ),
                     Icon(
                       Icons.menu,
                       color: appColors.white,
                       size: 30,
                     )

                   ],
                 ),
               ),

               Container(
                 padding: const EdgeInsets.only(top: 162),
                 child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          color: appColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )
                      ),
                  ),
               ),
            ],
          ),


          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap:(){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>Attendance()));
                            },
                            child: ListOfMenu( 
                              text: 'Employee \nAttendance',
                              image: 'assets/images/attendance.png', 
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:GestureDetector(
                            onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (context)=>AttendaceList())),
                            child: ListOfMenu(
                              text: 'Attendance \nList',
                              image: 'assets/images/calander.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: ListOfMenu(
                            text: 'Pay Slip',
                            image: 'assets/images/payslip.png',
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ApplyAttendanceRegularization()));
                            },
                            child: ListOfMenu(
                              text: 'Attendance \nRegulizetion',
                              TextSize: 10,
                              image: 'assets/images/listattendance.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaveApply()));
                            },
                            child: ListOfMenu(
                              text: 'Apply For \nLeave',
                              image: 'assets/images/applyforleav.png',
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaveList()));
                            },
                            child: ListOfMenu(
                              text: 'Leave List',
                              image: 'assets/images/leavelist.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    HomeAttendanceReports(),
                    const SizedBox(height: 20,),
                    HomeLeaveReports(),
                    const SizedBox(height: 30,),
                  ],
                ),
              )
            ),
          ),


        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),

        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.dashboard,
                          color:  appColors.secondColor,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: appColors.secondColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      decoration:  BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],

                          borderRadius: BorderRadius.circular(100),
                          gradient:
                          LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0xff00315E),
                              Color(0xff580082),
                            ],
                          )
                      ),
                      child: const Icon(Icons.add, color: appColors.white,),
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.supervised_user_circle,
                          color: appColors.mainColor,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: appColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),

    );
  }
}

