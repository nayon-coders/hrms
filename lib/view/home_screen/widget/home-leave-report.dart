import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../service/api-service.dart';

class HomeLeaveReports extends StatefulWidget {
  HomeLeaveReports({Key? key}) : super(key: key);

  @override
  State<HomeLeaveReports> createState() => _HomeLeaveReportsState();
}

class _HomeLeaveReportsState extends State<HomeLeaveReports> {
  final colorList = [
    appColors.successColor,
    appColors.dangerColor,
    appColors.secondColor,
  ];
  Future? leaveList;
  Future<void> getLiveList() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(Uri.parse(APIService.leaveCount),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      return data;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }

  @override
  void initState() {
    super.initState();
    ///whatever you want to run on page build
    leaveList = getLiveList();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 3.h),
      decoration: BoxDecoration(
        color: appColors.listOfMenuColor,

        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MediunText(text: "Leave", size: 11.sp,),
            const SizedBox(height: 10,),
            FutureBuilder(
                future: leaveList,
                builder: (context, AsyncSnapshot<dynamic> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: Text("Please Wait...."));
                  }else if(snapshot.hasData){
                    var remaining;
                    var total;
                    var taken;

                    if(snapshot.data['total'] != null){
                       total = snapshot.data['total'].toString();
                    }else{
                       total = "0";
                    }

                    if(snapshot.data['remaining'] != null){
                       remaining = snapshot.data['remaining'].toString();
                    }else{
                       remaining = "0";
                    }
                    if(snapshot.data['taken'] != null){
                      taken = snapshot.data['taken'].toString();
                    }else{
                      taken = "0";
                    }


                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70,
                          child: PieChart(
                            legendOptions: LegendOptions(
                                showLegends: false
                            ),
                            dataMap: {
                              "Remaining": double.parse(remaining),
                              "Taken": double.parse(taken),
                              "Total": double.parse(total),
                            },
                            colorList: colorList,
                            ringStrokeWidth: 15,
                            chartLegendSpacing: 500,
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[300]!,
                            chartValuesOptions: ChartValuesOptions(
                                showChartValues: false,
                                showChartValuesOutside: false
                            ),


                          ),
                        ),

                        Column(
                          children: [
                            BigText(text: "${remaining.toString()}", color: appColors.successColor, size: 12.sp,),
                            MediunText(text: "Remaining", color: appColors.black, size: 9.sp,)
                          ],
                        ),
                        Column(
                          children: [
                            BigText(text: "${taken.toString()}", color: appColors.dangerColor, size: 12.sp,),
                            MediunText(text: "Taken", color: appColors.black, size: 9.sp,)
                          ],
                        ),
                        Column(
                          children: [
                            BigText(text: "${total.toString()}", color: appColors.secondColor, size: 12.sp,),
                            MediunText(text: "Total", color: appColors.black, size: 9.sp,)
                          ],
                        )
                      ],
                    );
                  }
                  return Text("You have No Data at");
                }
            ),
          ],
        ),
      ),
    );
  }
}
