import 'dart:convert';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:http/http.dart' as http;
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = false;
  //form key
  final _loginFormKey = GlobalKey<FormState>();
  late bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
  }

  //controller
  final _email = TextEditingController();
  final _pass = TextEditingController();
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
            Center(
                child:  Image.asset("assets/images/logo.png"),
            ),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 3.h,),
              child: Form(
                key: _loginFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: "User Name",
                          hintStyle: TextStyle(
                            fontSize: 12.sp,
                            color: appColors.mainColor,
                          ),
                          // labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.h),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(width: 1, color: appColors.white)
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value){
                          if( value != null && value.isEmpty){
                            return "Email must not be is empty";
                          }
                        },

                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _pass,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontSize: 12.sp,
                              color: appColors.mainColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ?  Icons.visibility : Icons.visibility_off,
                              color: appColors.mainColor,
                            ), onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                          },
                          ),
                          // labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(horizontal: 3.h, vertical: 2.h),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(width: 1, color: appColors.white)
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value){
                          if( value != null && value.isEmpty){
                            return "Password must not be is empty";
                          }
                        },

                      ),
                      SizedBox(height: 3.h,),
                      GestureDetector(
                        onTap: (){
                          login();
                        },
                        child: isLogin == false ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: appColors.secondColor
                          ),
                          child: Center(child: Text("Login",
                            style: TextStyle(
                              color: appColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp
                            ),
                          )),
                        ): loadingBtn(),
                      ),

                      SizedBox(height: 20,),
                    ],
                  )
              ),
            )

          ],
        ),
      ),
    );
  }
  //loading wdiget
  Widget loadingBtn(){
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: appColors.secondColor
      ),
      child: Center(child:
      CircularProgressIndicator(
        color: appColors.white,
        strokeWidth: 3,
      ), ),
    );
  }

  void login() async{
    if(_loginFormKey.currentState!.validate()){
      setState(() {
        isLogin = true;
      });
      try {
        var response = await http.post(Uri.parse(APIService.loginUrl),
          body: {
            "email": _email.text,
            "password": _pass.text,
          },
          headers: {
          "Accept":"application/json"
          }
        );
        var body = jsonDecode(response.body);
        if (response.statusCode == 201) {
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('token', body['api_token']);
          localStorage.setString('name', body['name']);
          localStorage.setString('email', body['email']);
           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

          print(body['email']);

          ShowToast("Login Success").successToast();
        } else {
          ShowToast('Unauthorized').errorToast();
        }
        setState(() {
          isLogin = false;
        });

      }catch(e){
        _serverError();

      }
      setState(() {
        isLogin = false;
      });
     }
    }//end login method


  Future<void> _serverError() async {
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
                  child: Image.asset("assets/images/server.png",width: 150,height: 150,),
                ),
                SizedBox(height: 5.h,),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text("Server Error. Please try after sometimes. ",
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
                    Navigator.pop(context);
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



}
