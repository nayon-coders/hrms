import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../global_widget/mediun_text.dart';
class ProfileDetails extends StatefulWidget {
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final changeInfoForm = GlobalKey<FormState>();

var Name;
var Email;

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();


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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: const OutlineInputBorder(
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
                  margin: const EdgeInsets.only(top: 15),
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
    print(_email.text);
    print(_name.text);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var data = {
      "name" : "_name.text",
      "email": "_email.text",
    };
    var token = localStorage.getString('token');
    var url = Uri.parse(APIService.updateProfileUrl);
    final response = await http.post(url,
        body: data,
        headers: {
          "Authorization" : "Bearer $token",

        },
    );
    print(jsonEncode(data));
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print("profile is update");
      print(response.statusCode);

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body.toString());
      throw Exception('Failed to create album.');
      print(response.statusCode);
    }
  }
}
