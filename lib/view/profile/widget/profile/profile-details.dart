import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../../model/user-info-model.dart';
import '../../../global_widget/mediun_text.dart';
class ProfileDetails extends StatefulWidget {
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final changeInfoForm = GlobalKey<FormState>();

var Name;
var Email;

  final _name = TextEditingController();

  final _email = TextEditingController();

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

  void _UserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString("name");
    var email = localStorage.getString("email");

    setState(() {
      Name = name;
      Email = email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _UserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
      child: Form(
        child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      width: 3,
                      color: appColors.bg,
                    )
                  ),
                  hintText: "$Name",
                    label: MediunText(text: "$Name",),
                ),
              ),
              const SizedBox(height: 15,),
              TextFormField(

                controller: _email,
                decoration:  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                            width: 3,
                            color: appColors.bg
                        )
                    ),
                    hintText: "${Email}",
                  label: MediunText(text: "${Email}",),

                ),
              ),

              GestureDetector(
                onTap: (){
                  _userInfoUpdate();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width/3,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: appColors.secondColor
                  ),
                  child: Center(child: Text("Save Changes",
                    style: TextStyle(
                        color: appColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp
                    ),
                  )),
                ),
              ),
            ],
          )
      ),
    );
  }
  void _userInfoUpdate()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(
      Uri.parse(APIService.updateProfileUrl),
      headers: <String, String>{
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        "name" : _name.text,
        "email": _email.text,
        "fill" : "hjgjhggjhkg",
      }),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("profile is update");
      print(response.statusCode);

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      throw Exception('Failed to create album.');
      print(response.statusCode);
    }
  }
}
