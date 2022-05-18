import 'package:HRMS/index.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>IndexScreen())
                          );
                        },
                        child: Container(
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
                        ),
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
}
