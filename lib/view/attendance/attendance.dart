import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../home_screen/home.dart';
import '../profile/profile.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {


  bool isClock = true;
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
                  height: MediaQuery.of(context).size.height/6,
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
                  padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>IndexScreen(pageNumber: 0,)));
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: appColors.white,
                              )
                          ),
                          MediunText(text: "Employee Attendance", size: 10.sp, color: appColors.white,),
                        ],
                      ),
                      IconButton(
                          onPressed: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>IndexScreen(pageNumber: 0,)));
                          },
                          icon: Icon(
                            Icons.info_outline,
                            color: appColors.white,
                          )
                      ),

                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 100),
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

            //body part
            BigText(text: "Good Morning", size: 20.sp, color: appColors.secondColor,),
            MediunText(text: "Nayon Talukder",size: 12.sp, color: appColors.mainColor),
            
            const SizedBox(height: 30,),
            MediunText(text: "Friday , May 14 2022", color: appColors.gray, size: 9.sp,),
            BigText(text: "9:00 AM", size: 25.sp, color: appColors.black,),


            const SizedBox(height: 70,),
            GestureDetector(
              onTap: (){
                setState(() {
                  isClock = false;
                });
              },
              child: isClock ? Container(
                height: 17.h,
                width: 17.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: appColors.successColor,
                  boxShadow: [
                    BoxShadow(
                      color: appColors.successColor.withOpacity(0.3),
                      spreadRadius: 18,
                      blurRadius: 0,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: MediunText(text: "Clock In", size: 10.sp, color: appColors.white,),
                )
              )
              : Container(
                  height: 17.h,
                  width: 17.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: appColors.secondColor,
                    boxShadow: [
                      BoxShadow(
                        color: appColors.secondColor.withOpacity(0.3),
                        spreadRadius: 18,
                        blurRadius: 0,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: MediunText(text: "Clock out", size: 10.sp, color: appColors.white,),
                  )
              ),
            )
          ],
        ),




      //navigation bar
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 80,
          height: 80,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient:
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xffFE5709),
                  Color(0xffFE5709),
                ],
              )
          ),
          child: const Icon(Icons.add),
        ),
        onPressed: () {
          setState(() {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
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
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color:  appColors.mainColor,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: appColors.mainColor,
                          ),
                        ),
                      ],
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