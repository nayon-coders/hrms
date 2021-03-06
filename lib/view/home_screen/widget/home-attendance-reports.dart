import 'dart:convert';

import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../service/api-service.dart';

class HomeAttendanceReports extends StatefulWidget {
   HomeAttendanceReports({Key? key}) : super(key: key);

  @override
  State<HomeAttendanceReports> createState() => _HomeAttendanceReportsState();
}

class _HomeAttendanceReportsState extends State<HomeAttendanceReports> {
  final colorList = [
    appColors.successColor,
    appColors.dangerColor,
    appColors.secondColor,
  ];
  dynamic monthlyAttendanceRepo;
  DateTime? _selected;
  final dateFormate = DateFormat.yMMMMd('en_US');
  DateTime date = DateTime.now();
  dynamic currentMonth = DateFormat("yyyy-MM").format(DateTime.now());
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
              Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  MediunText(text: "Attendance", size: 11.sp,),
                  TextButton(
                    onPressed: (){
                      _showMonth(context );
                      print(currentMonth);
                    },
                      child: _selected != null ? MediunText(text: dateFormate.format(_selected!).toString(), size: 9.sp, color: appColors.gray,)
                          : MediunText(text: dateFormate.format(DateTime.now()).toString(), size: 9.sp, color: appColors.gray,))
                ],
              ),
              const SizedBox(height: 10,),
              FutureBuilder(
                  future: fromMonthlyAttendance(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: Text("Please Wait...."));
                    }else if(snapshot.hasData){
                      var data = snapshot.data['attendanceEmployee'];
                      double lateLength = 0;
                      double presentLength = 0;
                      double absentLength = 0;
                      for(var i=0; i<data.length; i++){
                        if(data[i]['status'] == 'Late'){
                          lateLength += 1;
                        }
                        if(data[i]['status'] == 'Present'){
                          presentLength += 1;
                        }
                        if(data[i]['status'] == 'Absent'){
                          absentLength += 1;
                        }
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
                                "Present": presentLength,
                                "Absent": absentLength,
                                "Late": lateLength,
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
                              BigText(text: "${presentLength.toInt()}", color: appColors.successColor, size: 12.sp,),
                              MediunText(text: "Present", color: appColors.black, size: 9.sp,)
                            ],
                          ),
                          Column(
                            children: [
                              BigText(text: "${absentLength.toInt()}", color: appColors.dangerColor, size: 12.sp,),
                              MediunText(text: "Absent", color: appColors.black, size: 9.sp,)
                            ],
                          ),
                          Column(
                            children: [
                              BigText(text: "${lateLength.toInt()}", color: appColors.secondColor, size: 12.sp,),
                              MediunText(text: "Late", color: appColors.black, size: 9.sp,)
                            ],
                          )
                        ],
                      );
                    }
                    return Text("You have No Data at: ${_selected.toString()}");
                  }
              ),

            ],
          ),
        ),
    );
  }

  Future<DateTime?> _showMonth(BuildContext context,)async{
    String? locale;
    final localOBJ = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2500),
      locale: localOBJ,
    );
    if (selected != null) {
      setState(() {
        _selected = selected;
      });
    }
  }

  Future<void> fromMonthlyAttendance() async{
    var monthFormat = DateFormat("yyyy-MM");
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    var monthlyAttenRepo = {
      "month" : _selected != null ? monthFormat.format(_selected!) : currentMonth,
      "type" : "monthly",
    };


    final response = await http.post(Uri.parse(APIService.attendanceListURL),
        body: monthlyAttenRepo,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    var body = jsonDecode(response.body.toString());
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      return monthlyAttendanceRepo = data;

    }else{
       showDialog<void>(
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
                    child: Image.asset("assets/images/server.png",width: 100,height: 100,),
                  ),
                  SizedBox(height: 5.h,),
                  Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Text("Server Error.",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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
      print(response.statusCode);
      throw Exception("Error");
    }

  }

  Future<void> ErrorShowing() async {
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
                  child: Image.asset("assets/images/server.png",width: 100,height: 100,),
                ),
                SizedBox(height: 5.h,),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text("Server Error.",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
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

