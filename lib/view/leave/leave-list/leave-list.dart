import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:HRMS/model/leave-list-model.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import '../../global_widget/big_text.dart';
import '../../global_widget/mediun_text.dart';
class LeaveList extends StatefulWidget {
  const LeaveList({Key? key}) : super(key: key);

  @override
  _LeaveListState createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  late Color color;
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());


var leaveList;
  Future<void> getLiveList() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(Uri.parse(APIService.leaveListUrl),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      return leaveList = data;

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
      body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),

          child:Expanded(
            child: FutureBuilder(
              future: getLiveList(),
                builder: (context, AsyncSnapshot<dynamic> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                }if(snapshot.hasData){
                  var data = leaveList['leaves'];
                  return ListView.builder(
                      itemCount: leaveList['leaves'].length,

                      itemBuilder: (context, index){
                        if(leaveList['leaves'][index]["status"] == "Pending"){
                          color = appColors.mainColor;
                        }else{
                          color = appColors.successColor;
                        }
                        var date = DateFormat.yMMMMd().format(DateTime.parse(leaveList['leaves'][index]["applied_on"]));
                        return leaveListItem(
                            date: date.toString(),
                            status: "${leaveList['leaves'][index]["status"]}",
                            editFunction: (){},
                            startDate: "${leaveList['leaves'][index]["start_date"]}",
                            endDate: "${leaveList['leaves'][index]["end_date"]}",
                            totalDays: "${leaveList['leaves'][index]["total_leave_days"]}",
                            reason: "${leaveList['leaves'][index]["leave_reason"]}",
                            leaveReason: "${leaveList['leaves'][index]["remark"]}",
                            color: color
                        );
                      }
                  );
                }else{
                  return Text("some think is warng");
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
  final String startDate;
  final String endDate;
  final String totalDays;
  final String reason;
  final String leaveReason;
  final Color color;
   leaveListItem({
     required this.date,
     required this.status,
     required this.editFunction,
     required this.startDate,
     required this.endDate,
     required this.totalDays,
     required this.reason,
     required this.leaveReason,
     required this.color,
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      margin: EdgeInsets.only(bottom: 30),
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
                  BigText(text: "Start Date", color: appColors.gray, size: 8.sp,),
                  MediunText(text: startDate, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "End Date", color: appColors.gray, size: 8.sp,),
                  MediunText(text: endDate, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Total", color: appColors.gray, size: 8.sp,),
                  MediunText(text: totalDays, color: appColors.black, size: 8.sp,)
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediunText(text: "Leave Reason: ", size: 10.sp,),
              Text(reason,
                style: TextStyle(
                    color: appColors.gray,
                    fontSize: 9.sp
                ),
              ),
              const SizedBox(height: 10,),
              MediunText(text: "Leave Remark: ", size: 10.sp,),
              Text(leaveReason,
                style: TextStyle(
                    color: appColors.gray,
                    fontSize: 9.sp
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}

