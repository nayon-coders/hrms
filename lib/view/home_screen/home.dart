import 'package:HRMS/controller/profile/profile-coltroller.dart';
import 'package:HRMS/view/pay-slip.dart';
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
  bool _isProfilePic = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _UserInfo();
  }

  void _UserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString("name");
    var email = localStorage.getString("email");

    setState(() {
      Name = name;
    });
  }
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
  bool _isLogout = false;

  @override
  Widget build(BuildContext context) {
    UserProfileController _userProfileControllor = UserProfileController();

    return Scaffold(
      backgroundColor: appColors.white,
      body: _isLogout ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: appColors.secondColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 10,),
             MediunText(text: "Logout processing..."),
          ],
        ),
      ): Column(
        children: [
          //TODO:Stack topbar
          Container(
            width: double.infinity,
            height: 165,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff00315E),
                    Color(0xff580082),
                  ],
                )),
            child:  Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 20, right: 20, top: 70, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Profile()));
                          },
                          child: FutureBuilder(
                            future: _userProfileControllor.getUserProfile(),
                            builder: (context, AsyncSnapshot snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: appColors.secondColor,
                                );
                              }else if(snapshot.hasData) {
                                var avatar = snapshot.data?.userDetail.avatar;
                                if (avatar != null) {
                                  _isProfilePic = true;
                                }
                                return ClipOval(
                                  child:  _isProfilePic ? Image.network("https://asiasolutions.xyz/storage/uploads/avatar/$avatar",
                                    height: 60,
                                    width: 60,

                                  ): Image.asset("assets/images/user.jpg",
                                    height: 60,
                                    width: 60,
                                  ),
                                );
                              }
                              return ClipOval(
                                child: Image.asset("assets/images/user.jpg",
                                  height: 60,
                                  width: 60,
                                ),
                              );
                            },

                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(text: "${greeting()}", color: appColors
                              .white, size: 13,),
                          SizedBox(height: 5,),
                          MediunText(
                            text: "${Name}", size: 10, color: appColors
                              .white,),
                        ],
                      ),

                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  child:Container(
                    height: 3.h,
                    width: MediaQuery.of(context).size.width,
                    decoration:  BoxDecoration(
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
          ),


          //TODO: Body part
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => Attendance()));
                              },
                              child: ListOfMenu(
                                text: 'Employee \nAttendance',
                                image: 'assets/images/attendance.png',
                                bgColor: appColors.listOfMenuColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AttendaceList())),
                              child: ListOfMenu(
                                text: 'Attendance \nList',
                                image: 'assets/images/calander.png',
                                bgColor: appColors.listOfMenuColor,
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
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      PaySlip()));
                            },
                            child: ListOfMenu(
                              text: 'Pay Slip',
                              image: 'assets/images/payslip.png',
                            ),
                          ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) =>
                                        AttendanceRegularization(index: 0,)));
                              },
                              child: ListOfMenu(
                                text: 'Attendance \nRegularization',
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
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => LeaveApply(index: 0,)));
                              },
                              child: ListOfMenu(
                                text: 'Apply For \nLeave',
                                image: 'assets/images/applyforleav.png',
                                bgColor: appColors.listOfMenuColor,
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                              Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => LeaveApply(index: 1)));
                              },
                              child: ListOfMenu(
                                text: 'Leave List',
                                image: 'assets/images/leavelist.png',
                                bgColor: appColors.listOfMenuColor,
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.dashboard,
                          color: appColors.secondColor,
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
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Attendance()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(
                                  0, 0), // changes position of shadow
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
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Profile()));
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
