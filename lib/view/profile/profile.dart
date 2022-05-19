import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/profile/widget/cheange-pass.dart';
import 'package:HRMS/view/profile/widget/profile/profile-details.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../global_widget/tob-bar.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: appColors.bg,
        body: Column(
          children: [
            TopBar(
                text: "Employee Profile",
                goToBack: (){
                  Navigator.pop(context);
                },

                iconNavigate: (){
                  Navigator.pop(context);
                },
                icon:Icons.logout,
              bottomRoundedColor: appColors.bg,

            ),

            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: appColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: appColors.mainColor.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                child: Image.asset("assets/images/user.jpg",
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              MediunText(text: "Nayon Talukder",
                                color: appColors.mainColor,
                                size: 11.sp,
                              ),
                              const SizedBox(height: 5,),
                              Container(
                                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: appColors.secondColor
                                ),
                                child: MediunText(
                                  text: "Employee",
                                  color: appColors.white,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              MediunText(
                                text: "nayon.coder@gmail.com",
                                color: appColors.gray,
                              ),
                            ],
                          ),

                        ),

                        const SizedBox(height: 50,),

                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 2. h),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(width: 1, color: appColors.secondColor)
                                ),
                                child: TabBar(
                                  indicator:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: appColors.secondColor
                                  ),
                                  unselectedLabelColor: appColors.secondColor,
                                  tabs: [
                                    Tab(text: "Profile"),
                                    Tab(text: "change Passeword"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),

                              Container(
                                height: 220,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: appColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: appColors.mainColor.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TabBarView(
                                  children: [
                                    ProfileDetails(),
                                    ChangePass(),
                                  ],
                                ),

                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 60,),
                      ],
                    ),
                  ),
                )
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
                    Color(0xff00315E),
                    Color(0xff580082),
                  ],
                )
            ),
            child: const Icon(Icons.add),
          ),
          onPressed: () {
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.supervised_user_circle,
                            color: appColors.secondColor,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: appColors.secondColor,
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
      ),
    );
  }
}

