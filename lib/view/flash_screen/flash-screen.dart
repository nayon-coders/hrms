import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/login_screen/login.dart';
import 'package:HRMS/view/server-error.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/TodayAttendanceModel.dart';
import '../../service/api-service.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> with TickerProviderStateMixin {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _UserInfo();



  }
  void _UserInfo() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString("token");


    final response = await http.get(Uri.parse(APIService.todayAttendanceListURL),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode != 201){
      setState(() {
        print(token);
        Future.delayed(
            const Duration(seconds: 3),() =>
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ServerError(SatusCode: '${response.statusCode.toString()}',)))
        );
      });
    }else{
      setState(() {
        print(token);
        Future.delayed(
            const Duration(seconds: 3),() =>
        token == null ?
        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())):
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()))
        );
      });
    }
  }


  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
    )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );



  @override
  void dispose() {
  _controller.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
          decoration: const BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment(0.8, 1),
        colors: <Color>[
        Color(0xff00315E),
        Color(0xff580082),
        ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
             Container(
                child: Center(
                  child: SizeTransition(
                      sizeFactor: _animation,
                      axis: Axis.horizontal,
                      axisAlignment: -1,
                  child: Image.asset("assets/images/logo.png")),
                ),
              ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(bottom: 3.h),
              child: (
                  Text("Version 1.0.0",
                    style: TextStyle(
                      color: appColors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600
                    ),
                  )
              ),
            )


          ],
        ),
        ),
    );
  }
}

