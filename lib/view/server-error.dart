import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ServerError extends StatefulWidget {
  final String SatusCode;
  ServerError({Key? key, required this.SatusCode}) : super(key: key);

  @override
  _ServerErrorState createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.gray200,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: BigText(text: widget.SatusCode, size: 30, color: appColors.secondColor,),
          ), 
          MediunText(text: "Server Error", size: 15,),
          const SizedBox(height: 30,),
          Center(
            child: TextButton(
                onPressed: (){
                  _whyError();
                },
                child: MediunText(text: "Why this problem?", color: Colors.blue,)),
          ),
        ],
      ),

    );
  }
  void _whyError(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: appColors.dangerColor,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        content: MediunText(text: "Some things wrong with our web server. \n\n Access to this resource on the server is denied!", color: appColors.white, size: 9.sp,)));
  }
}
