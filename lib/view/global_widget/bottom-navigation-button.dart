import 'package:HRMS/utility/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../attendance/attendance.dart';
import '../home_screen/home.dart';
import '../profile/profile.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.dashboard,
                        color:  appColors.mainColor,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: appColors.mainColor,
                          fontSize: 10.sp
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
                  minWidth: 40,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
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
                          fontSize: 10.sp
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
    );
  }
}
