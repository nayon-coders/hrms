import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/bottom-navigation-button.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/tob-bar.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:HRMS/view/leave/leave-apply/widget/leave-form.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import 'package:http/http.dart' as http;
import '../../attendance/attendance.dart';
import '../../global_widget/big_text.dart';
import '../../profile/profile.dart';
import '../appy-attendnace-regularization/apply-attendnace-regularization.dart';

class ApplyAttendanceRegularizationList extends StatefulWidget {
  const ApplyAttendanceRegularizationList({Key? key}) : super(key: key);

  @override
  _ApplyAttendanceRegularizationListState createState() => _ApplyAttendanceRegularizationListState();
}

class _ApplyAttendanceRegularizationListState extends State<ApplyAttendanceRegularizationList> {
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());
  late Color color;

  var regularaizationList;
  Future<void> getRegularaization() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(Uri.parse(APIService.regularizationList),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      print(regularaizationList);
      return regularaizationList = data;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: appColors.white,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),

          child:Expanded(
            child: FutureBuilder(
                future: getRegularaization(),
                builder: (context, AsyncSnapshot<dynamic> snapshot){

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if(snapshot.hasData){
                    var data = regularaizationList['regularize_attendance'];
                    return ListView.builder(
                        itemCount: data.length,

                        itemBuilder: (context, index){
                          if(data[index]["status"] == "Pending"){
                            color = appColors.mainColor;
                          }else{
                            color = appColors.successColor;
                          }
                          var date = DateFormat.yMMMMd().format(DateTime.parse(data[index]["date"]));
                          return leaveListItem(
                              date: date,
                              status: data[index]["status"].toString(),
                              editFunction: (){},
                              in_time: data[index]['regularized_in_time'].toString(),
                              out_time: data[index]['regularized_out_time'].toString(),
                              reason: data[index]['reason'].toString(),
                              description: data[index]['description'],
                              color: color
                          );
                        }
                    );
                  }else{
                    return const Text("some think is warng");
                  }

                }
            ),

          )
      ),


    );
  }
}



class leaveListItem extends StatelessWidget {
  final String date;
  final String status;
  final VoidCallback editFunction;
  final String in_time;
  final String out_time;
  final String reason;
  final String description;
  final Color color;
  leaveListItem({
    required this.date,
    required this.status,
    required this.editFunction,
    required this.in_time,
    required this.out_time,
    required this.reason,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: appColors.white,
        border: Border(
          left: BorderSide(width: 10.0, color: color),
        ),
        //borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediunText(text: date, size: 9, color: appColors.gray,),

              Row(
                children: [
                  BigText(text: status, size: 12, color: color,),
                  const SizedBox(width: 10,),
                  Icon(
                    Icons.edit,
                    color: color,
                    size: 20,
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "In Time", color: appColors.gray, size: 8.sp,),
                  MediunText(text: in_time, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Out Time", color: appColors.gray, size: 8.sp,),
                  MediunText(text: out_time, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Reason", color: appColors.gray, size: 8.sp,),
                  MediunText(text: reason, color: appColors.black, size: 8.sp,)
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediunText(text: "Leave Reason: ", size: 10.sp,),
              Text(description,
                style: TextStyle(
                    color: appColors.gray,
                    fontSize: 9.sp
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}

