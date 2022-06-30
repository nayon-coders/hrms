import 'dart:async';
import 'dart:convert';
import 'package:HRMS/view/attendance/attendance-list/attendance-list.dart';
import 'package:HRMS/view/global_widget/server-error.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/model/TodayAttendanceModel.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../controller/attendance-list/today-attendance-list-controller.dart';
import '../../service/api-service.dart';
import '../global_widget/tob-bar.dart';
import '../home_screen/home.dart';
import '../profile/profile.dart';
import 'current-time.dart';

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
    _isOfficeOrNot();
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
  var checkIPData;


  @override
  Widget build(BuildContext context) {
    TodayAttendanceController _todayAttendance = TodayAttendanceController();

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
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AttendaceList()));
            },
            icon:Icons.arrow_back_ios_rounded,
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
                    CurrentTime(),


                    const SizedBox(height: 70,),

                    FutureBuilder(
                        future: _todayAttendance.fromTodayAttendance(),
                        builder: (context, AsyncSnapshot<dynamic> snapshot){
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
                            var clock_in = snapshot.data?.todaysAttendance?.clockIn;
                            var clock_out = snapshot.data?.todaysAttendance?.clockOut;
                            //String APIdateFormet = DateFormat('yyyy-MM-dd').format(APIDate);
                            //TODO: check office or not office
                            if(checkIPData?['login_preference'][0] == "ewl") {
                              if((checkIPData?['ip'] == "27.147.205.236") || (checkIPData?['ip'] == "118.179.117.129")){

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
                                _youcantAttend();
                              }

                            }else if(checkIPData?['login_preference'][0] == "otgl"){

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
                            }
                            //END: Clocking
                            //TODO: check in data
                          }else{
                            return attendanceButton(
                              "Clock In",
                              appColors.successColor,
                                  ()=>_clockIn(),
                            );
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
      ShowToast("Clock In Success").successToast();
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
      ShowToast("Clock Out Success",).secounderyToast();
    }else{
      _waring();
    }
  }

  Future _isOfficeOrNot() async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    var url = Uri.parse(APIService.checkIP);
    final response =  await http.get(url,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var checkIP = jsonDecode(response.body);

      return checkIPData = checkIP;
    }else{
      //_youcantAttend();
      print(response.statusCode);
    }
  }

  Future<void> _youcantAttend() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 30.0),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

            ),
            height: 330,
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset("assets/images/notoffice.png",width: 100,height: 100,),
                ),
                SizedBox(height: 5.h,),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text("You are not in the office now. Come and trying again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp
                      ),
                    )
                ),
                SizedBox(height: 5.h,),
                MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColors.mainColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ]
                    ),
                    child: Center(child: MediunText(text: "Try again", size: 12.sp, color: appColors.white,)),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  void _waring(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: appColors.dangerColor,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        content: MediunText(text: "Access to this resource on the server is denied!", color: appColors.white, size: 9.sp,)));
  }

}