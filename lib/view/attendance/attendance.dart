import 'package:HRMS/model/attendance-list-model.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance-list/attendance-list.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../controller/attendance-list/attenandce-list-controller.dart';
import '../global_widget/tob-bar.dart';
import '../home_screen/home.dart';
import '../profile/profile.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    AttedanceListController _attendancList = AttedanceListController();
  }
  bool isClock = true;


  @override
  Widget build(BuildContext context) {
    AttedanceListController attendancList = AttedanceListController();
    return Scaffold(
      backgroundColor: appColors.bg,
        body: Column(
          children: [
            TopBar(
                text: "Employee Attendance",
                goToBack: (){
                  Navigator.pop(context);
                },

              iconNavigate: (){
                Navigator.pop(context);
              },
              icon:Icons.info_outline,
                bottomRoundedColor: appColors.bg,

            ),
            const SizedBox(height: 30,),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //body part
                      BigText(text: "Good Morning", size: 20.sp, color: appColors.secondColor,),
                      MediunText(text: "Nayon Talukder",size: 12.sp, color: appColors.mainColor),

                      const SizedBox(height: 30,),
                      MediunText(text: "Friday , May 14 2022", color: appColors.gray, size: 9.sp,),
                      BigText(text: "9:00 AM", size: 25.sp, color: appColors.black,),


                      const SizedBox(height: 70,),

                      FutureBuilder(
                        future: attendancList.fromAttendance(),
                          builder: (context, AsyncSnapshot<AttendanceEmployeeModel> snapshot){
                          if(snapshot.hasData){
                            return Text("yes");
                          }else{
                            return Text("not");
                          }

    }

                      ),

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
                )
            )
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
                          color:  appColors.mainColor,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: appColors.mainColor,
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
                  MaterialButton(
                    onPressed: (){
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
                              Color(0xffFE5709),
                              Color(0xffFE5709),
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

