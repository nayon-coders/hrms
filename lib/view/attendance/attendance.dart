import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/model/TodayAttendanceModel.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controller/attendance-list/today-attendance-list-controller.dart';
import '../../controller/employee-attendance/clocking-controller.dart';
import '../../service/api-service.dart';
import '../global_widget/tob-bar.dart';
import '../home_screen/home.dart';
import '../profile/profile.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {

  var Name;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _UserInfo();

    Timer.periodic(Duration(seconds: 1), (timer){
      if(_timeOfDay.minute != TimeOfDay.now().minute){
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  //###### User information #########
  void _UserInfo() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString("name");
    setState(() {
      Name = name!;
    });
  }
  ///////////////// User information end = ///////////////


  //////////// timer ////////////
  TimeOfDay _timeOfDay = TimeOfDay.now();
  //////////// timer ////////////


  //////////// Date Format ////////////
  String formattedDate = DateFormat('yMMMMEEEEd').format(DateTime.now());
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //////////// Date Format ////////////

  //////////// Dynamic greeting ////////////
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour <= 12) {
      return 'Good Morning';
    }
    if (hour <= 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  bool isClock = true;


  @override
  Widget build(BuildContext context) {
    TodayAttendanceController _todayAttendance = TodayAttendanceController();
      String _priod = _timeOfDay.period == DayPeriod.am ? "AM" : "PM";
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
                      BigText(text: greeting(), size: 20.sp, color: appColors.secondColor,),
                      MediunText(text: Name!,size: 12.sp, color: appColors.mainColor),

                      const SizedBox(height: 30,),
                      MediunText(text: formattedDate, color: appColors.gray, size: 9.sp,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BigText(text: "${_timeOfDay.hour}:${_timeOfDay.minute}", size: 25.sp, color: appColors.black,),
                          const SizedBox(width: 5,),
                          BigText(text: _priod, size: 25.sp, color: appColors.black,),
                        ],
                      ),


                      const SizedBox(height: 70,),

                      FutureBuilder(
                        future: _todayAttendance.fromTodayAttendance(),
                          builder: (context, AsyncSnapshot<TodaysAttendanceModel> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Container(
                                height: 17.h,
                                width: 17.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: appColors.mainColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColors.mainColor.withOpacity(0.3),
                                      spreadRadius: 18,
                                      blurRadius: 0,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: appColors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                            );
                          }else if(snapshot.hasData){
                            //var APIDate = snapshot.data!.todaysAttendance!.date;
                            var clock_in = snapshot.data!.todaysAttendance!.clockIn;
                            var clock_out = snapshot.data!.todaysAttendance!.clockOut;
                            //String APIdateFormet = DateFormat('yyyy-MM-dd').format(APIDate);

                              if(clock_in == "00:00:00"){
                                return attendanceButton(
                                    "Clock In",
                                    appColors.successColor,
                                    ()=>_clockIn(),
                                );
                              }else if(clock_out == "00:00:00"){
                                return attendanceButton(
                                  "Clock Out",
                                  appColors.secondColor,
                                      ()=> _clockOut(),
                                );
                              }else{
                                return Column(
                                  children: [
                                    Container(
                                        height: 17.h,
                                        width: 17.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: appColors.gray,
                                          boxShadow: [
                                            BoxShadow(
                                              color: appColors.gray.withOpacity(0.3),
                                              spreadRadius: 18,
                                              blurRadius: 0,
                                              offset: Offset(0, 0), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: MediunText(
                                            size: 13.sp,
                                            text: "Done",
                                            color: appColors.black,
                                          ),
                                        ),
                                    ),
                                    const SizedBox(height: 45,),
                                    Center(
                                      child: BigText(
                                        size: 11.sp,
                                        text: "Today attendance is complete.",
                                        color: appColors.black,
                                      ),
                                    ),
                                  ],
                                );
                               }


                          }else{
                            //today no data
                            // return clock in
                            return  attendanceButton("Clock In", appColors.successColor, ()=>_clockIn(),);
                          }
                          return Center();

                        }

                      ),


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


  Widget attendanceButton(String text, Color color, VoidCallback? onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 17.h,
          width: 17.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                spreadRadius: 18,
                blurRadius: 0,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Center(
            child: MediunText(text: text, size: 10.sp, color: appColors.white,),
          )
      ),
    );
  }



  void _clockIn() async{

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');
      var url = Uri.parse(APIService.clockInUrl);
      final response =  await http.post(url,
          headers: {
            "Authorization" : "Bearer $token"
          }
      );
      if(response.statusCode == 201){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
        Flushbar(
          title: "Clock In Success",
          titleColor: appColors.white,
          message: "You're Present. Your Attendance successfully Clock In",
          icon:  Icon(
            Icons.done,
            size: 28.0,
            color: appColors.successColor,
          ),
          messageSize: 12.sp,
          messageColor: appColors.successColor,
          borderWidth: 1,
          borderColor: Colors.grey,
          margin: EdgeInsets.all(6.0),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.TOP,
          textDirection: Directionality.of(context),
          borderRadius: BorderRadius.circular(12),
          duration: Duration(seconds: 4),
          leftBarIndicatorColor: appColors.successColor,
        ).show(context);
      }else{
        _waring();
      }


  }
  void _clockOut() async{
    setState(() {
      print(isClock);
      isClock = true;
    });


    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    var url = Uri.parse(APIService.clockOutUrl);
    final response =  await http.post(url,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => super.widget));
      Flushbar(
        title: "Clock Out Success",
        titleColor: appColors.white,
        message: "You're Leave. Your Attendance successfully Clock Out",
        icon:  Icon(
          Icons.done,
          size: 28.0,
          color: appColors.secondColor,
        ),
        messageSize: 12.sp,
        messageColor: appColors.secondColor,
        borderWidth: 1,
        borderColor: Colors.grey,
        margin: EdgeInsets.all(6.0),
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        textDirection: Directionality.of(context),
        borderRadius: BorderRadius.circular(12),
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: appColors.secondColor,
      ).show(context);
    }else{
      _waring();
    }
  }


  void _waring(){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: appColors.dangerColor,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          content: MediunText(text: "Access to this resource on the server is denied!", color: appColors.white, size: 9.sp,)));
  }

}

