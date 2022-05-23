import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:HRMS/controller/login/login-controller.dart';
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
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
                      SizedBox(height: 2.h,),
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
                        child: isLogin ? Container(
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
                      )
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
        isLogin = false;
      });
      var loginInfo = {
        "email":_email.text,
        "password": _pass.text,
      };

      try {
        var response = await http.post(Uri.parse("https://asia.net.in/api/login"),
          body: {
            "email": _email.text,
            "password": _pass.text,
          },
        );
        var body = jsonDecode(response.body);
        if (response.statusCode == 201) {
          SharedPreferences localStorage = await SharedPreferences.getInstance();
          localStorage.setString('token', body['api_token']);
          localStorage.setString('name', body['name']);
          localStorage.setString('email', body['email']);
           Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

          print(body['email']);

          Notify(
            title: 'Login Success',
            body: 'Your are login successfully',
            color: appColors.successColor,
          ).notify(context);
        } else {
          Notify(
            title: 'Login Faild',
            body: 'Sorry, Something was wrong',
            color: appColors.secondColor,
          ).notify(context);
          print(response.statusCode);
        }
        setState(() {
          isLogin = true;
        });

      }catch(e){

      }
     }
    }//end login method



}
