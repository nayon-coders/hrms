import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/widget/home-reports.dart';
import 'package:HRMS/view/home_screen/widget/list-of-menu.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  height: 220,
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
                   padding: EdgeInsets.only(left: 20, right: 20, top: 90, bottom: 10),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Row(
                       children: [
                         ClipRRect(
                             borderRadius: BorderRadius.circular(100),
                             child: Image.asset("assets/images/user.jpg",
                               fit: BoxFit.cover,
                               height: 60,
                               width: 60,
                             )

                         ),
                         const SizedBox(width: 10,),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             BigText(text: "Hi, Good Morning", ),
                             SizedBox(height: 5,),
                             MediunText(text: "Nayon Talukder", size: 15,),
                           ],
                         ),
                       ],
                     ),
                     Icon(
                       Icons.menu,
                       color: appColors.white,
                       size: 40,
                     )

                   ],
                 ),
               ),

               Padding(
                 padding: const EdgeInsets.only(top: 180),
                 child: Container(
                      height: 50,
                      decoration: BoxDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 1.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListOfMenu(
                            text: 'Employee \n Attendance',
                            image: 'assets/images/attendance.png',
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:ListOfMenu(
                            text: 'Attendance \nList',
                            image: 'assets/images/calander.png',
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
                          child:ListOfMenu(
                            text: 'Attendance \nRegulizetion',
                            TextSize: 12,
                            image: 'assets/images/listattendance.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: ListOfMenu(
                            text: 'Apply For \nLeave',
                            image: 'assets/images/applyforleav.png',
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child:ListOfMenu(
                            text: 'Leave List',
                            image: 'assets/images/leavelist.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
HomeReports()

                  ],
                ),
              )
            ),
          ),


        ],
      ),
    );
  }
}

