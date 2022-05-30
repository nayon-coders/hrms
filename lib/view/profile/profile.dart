import 'dart:convert';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/controller/profile/profile-coltroller.dart';
import 'package:HRMS/model/user-info-model.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/attendance/attendance.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/profile/widget/cheange-pass.dart';
import 'package:HRMS/view/profile/widget/profile/profile-details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../global_widget/tob-bar.dart';
import '../login_screen/login.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isProfilePic = false;
  bool _isLogout = false;
  Future<UserInfoModel> _getUserProfile() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(
      Uri.parse(APIService.profileUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        "Authorization": "Bearer $token",
      }),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return UserInfoModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return _isLogout ? Center(
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
    ): DefaultTabController(
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
                  _logout();
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
                          child:Expanded(
                                  child: FutureBuilder(
                                    future: _getUserProfile(),
                                    builder: (context, AsyncSnapshot<UserInfoModel> snapshot){
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return Column(
                                          children: [
                                            Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                backgroundColor: appColors.secondColor,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            MediunText(text: "Checking Update...", color: appColors.gray, size: 7,),
                                          ],
                                        );
                                      }else if(snapshot.hasData){
                                        var avatar = snapshot.data?.userDetail.avatar;
                                        if(avatar != null){
                                          print(avatar);
                                           _isProfilePic = true;
                                        }
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: _isProfilePic ? Image.network("https://asia.net.in/storage/uploads/avatar/$avatar",
                                                height: 70,
                                                width: 70,

                                              ): Image.asset("assets/images/user.jpg",
                                                height: 70,
                                                width: 70,
                                              ),
                                            ),

                                            const SizedBox(height: 10,),
                                            Center(
                                              child: BigText(text: "${snapshot.data?.userDetail.name}",
                                                color: appColors.mainColor,
                                                size: 7.sp,
                                              ),
                                            ),
                                            const SizedBox(height: 5,),
                                            Container(
                                              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: appColors.secondColor
                                              ),
                                              child: MediunText(
                                                text: "${snapshot.data?.userDetail.type}",
                                                color: appColors.white,
                                                size: 7,
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Center(
                                              child: MediunText(
                                                text: "${snapshot.data?.userDetail.email}",
                                                color: appColors.gray,
                                                size: 7,
                                              ),
                                            ),

                                          ],
                                        );
                                      }else{
                                        return Center(child: Text("Server Error"));
                                      }
                                    }
                                  )
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
  void _logout() async{
    setState(() {
      _isLogout = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');

    final respons = await http.post(Uri.parse(APIService.logoutUrl),
        body: jsonEncode("object"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(respons.statusCode == 200){
      localStorage.remove('token');
      localStorage.remove('name');
      localStorage.remove('email');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

    }else{
      print("faild");
    }

    setState(() {
      _isLogout = false;
    });
  }
}

