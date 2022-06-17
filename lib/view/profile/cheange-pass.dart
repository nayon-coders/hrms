import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../service/api-service.dart';
import 'package:http/http.dart' as http;
class ChangePass extends StatefulWidget {

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final changePassForm = GlobalKey<FormState>();

  TextEditingController _newPass = TextEditingController();

  TextEditingController _reTypePass = TextEditingController();

  void showAlertDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
          title: Text("Wifi"),
          content: Text("Wifi not detected. Please activate it."),
         )
        );
    }

    bool _isChange = false;
  final _changePassKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 25, left: 10, right: 10),
      child: Form(
        key: _changePassKey,
          child: Column(
            children: [
              
              BigText(text: "Change Password", size: 12,),
              Container(
                width: 80,
                height: 3,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: appColors.secondColor
                ),
              ),
              Container(
                width: 60,
                height: 3,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: appColors.secondColor
                ),
              ),
              const SizedBox(height: 20,),

              _isChange ? Center(
                child: CircularProgressIndicator(strokeWidth: 5, color: appColors.secondColor,),
              ) : Column(
                children: [
                  TextFormField(
                    controller: _newPass,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              width: 3,
                              color: appColors.bg,
                            )
                        ),
                        hintText: "Enter New Password",
                        labelText: "New Password"
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please enter New Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _reTypePass,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                                width: 3,
                                color: appColors.bg
                            )
                        ),
                        hintText: "Retype Password",
                        labelText: "Retype Password"
                    ),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return 'Please Retype Password';
                      }
                      return null;
                    },
                  ),

                  GestureDetector(
                    onTap: (){
                      _changePass();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      width: MediaQuery.of(context).size.width/3,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appColors.secondColor
                      ),
                      child: Center(
                          child: Text("Save Changes",
                            style: TextStyle(
                                color: appColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 9.sp
                            ),
                          )
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

  void _changePass() async{
    setState(() {
      _isChange = true;
    });
    if(_changePassKey.currentState!.validate()){

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var data = {
        "current_password" : _newPass.text,
        "new_password": _newPass.text,
        "confirm_password": _reTypePass.text,
      };
      var token = localStorage.getString('token');
      var url = Uri.parse(APIService.updateChangePassUrl);
      final response = await http.post(url,
        body: data,
        headers: {
          "Authorization" : "Bearer $token",

        },
      );
      print(jsonEncode(data));
      if (response.statusCode == 201) {
        setState(() {
          _isChange = false;
          _newPass.clear();
          _reTypePass.clear();
          ShowToast("Password Changed").successToast();
        });

      } else {
        ShowToast("Password Changing failed").errorToast();
        setState(() {
          _isChange = false;
        });

      }

    }else{
      setState(() {
        _isChange = false;
      });
    }

  }
}
