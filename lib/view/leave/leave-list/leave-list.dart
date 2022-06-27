import 'dart:convert';
import 'package:HRMS/view/global_widget/no-data.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import '../../global_widget/big_text.dart';
import '../../global_widget/mediun_text.dart';
import '../../global_widget/server-error.dart';
class LeaveList extends StatefulWidget {
  const LeaveList({Key? key}) : super(key: key);

  @override
  _LeaveListState createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  final List<String> items = [
    'CASUAL LEAVE (10)',
  ];
  String? selectedLeaveTypeValue;
  late DateTime date;
  late dynamic formatingDate =  DateFormat("yyyy-MM");
  final _selectTypeControler = TextEditingController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _leaveReasionController = TextEditingController();
  final _RemarkController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final _LeaveFormKey = GlobalKey<FormState>();

  bool _isLeaveApply = false;


  late Color color;
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());

bool isPending = false;

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
      var leaveList = data;
      return leaveList;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }
  Future? LeaveListItem;
  @override
  void initState(){
    LeaveListItem = getLiveList();
  }


  String? leaveID;
  Future? editLeaveData;
  getEditLiveList() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(Uri.parse("${APIService.baseUrl}/leave/edit/${leaveID}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      var EditleaveList = data;
      return EditleaveList;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }


  @override
  Widget build(BuildContext context) {
var width = MediaQuery.of(context).size.width;
var height = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: appColors.white,
      body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),

          child:Container(
            width: width,
            height: height,
            child: FutureBuilder(
              future: LeaveListItem,
                builder: (context, AsyncSnapshot<dynamic> snapshot){

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                }if(snapshot.hasData){
                  var data = snapshot.data['leaves'];
                  if(snapshot.data['leaves'].length > 0) {
                    return ListView.builder(
                        itemCount: snapshot.data['leaves'].length,

                        itemBuilder: (context, index) {
                          if (snapshot.data['leaves'][index]["status"] ==
                              "Pending") {
                            isPending = true;
                            color = appColors.mainColor;
                          } else {
                            color = appColors.successColor;
                            isPending = false;
                          }
                          var date = DateFormat.yMMMMd().format(DateTime.parse(
                              snapshot.data['leaves'][index]["applied_on"]));
                          return leaveListItem(
                              date: date.toString(),
                              status: "${snapshot
                                  .data['leaves'][index]["status"]}",
                              editFunction: () {
                                setState((){
                                  leaveID = snapshot.data['leaves'][index]["id"].toString();
                                  editLeaveData = getEditLiveList();
                                });
                                _editList();
                              },
                              startDate: "${snapshot
                                  .data['leaves'][index]["start_date"]}",
                              endDate: "${snapshot
                                  .data['leaves'][index]["end_date"]}",
                              totalDays: "${snapshot
                                  .data['leaves'][index]["total_leave_days"]}",
                              reason: "${snapshot
                                  .data['leaves'][index]["leave_reason"]}",
                              leaveReason: "${snapshot
                                  .data['leaves'][index]["remark"]}",
                              color: color,
                            icon: isPending,
                          );
                        }
                    );
                  }else{
                    return NoDataFound();
                  }
                }else{
                  return ServerError();
                }

                }
            ),

          )
      ),

    );
  }


  _editList() async {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content:  _isLeaveApply ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        color: appColors.secondColor,
                      ),
                    ) : FutureBuilder(
                        future: editLeaveData,
                        builder: (context, AsyncSnapshot<dynamic> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 5,
                                color: appColors.secondColor,
                              ),
                            );
                          }else if(snapshot.hasData){
                            if(snapshot.data["leave"].length > 0){
                              return Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 500,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: _LeaveFormKey,
                                  child: ListView(
                                    children: [
                                      MediunText(text: "Apply for leave",
                                        size: 10.sp,
                                        color: appColors.black,),
                                      const SizedBox(height: 20,),
                                      CustomDropdownButton2(
                                        hint: "${snapshot.data["leavetypes"]["6"]}",
                                        buttonHeight: 55,
                                        buttonWidth: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        buttonPadding: EdgeInsets.all(10),
                                        dropdownWidth: MediaQuery
                                            .of(context)
                                            .size
                                            .width / 2,
                                        buttonDecoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: appColors.gray),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        dropdownItems: items,
                                        value: selectedLeaveTypeValue,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedLeaveTypeValue = value;
                                          });
                                        },
                                      ),

                                      const SizedBox(height: 20,),
                                      DateTimeField(
                                        format: format,
                                        controller: _fromDateController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 15, bottom: 15, left: 10, right: 10),
                                          labelText: "${snapshot.data["leave"]["start_date"]}",
                                          labelStyle: TextStyle(
                                            fontSize: 10.sp,
                                          ),
                                          hintText: "${snapshot.data["leave"]["start_date"]}",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: appColors.gray200)
                                          ),
                                          suffixIcon: Icon(
                                            Icons.date_range,
                                          ),
                                        ),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ?? DateTime.now(),
                                              lastDate: DateTime(2100)
                                          );
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return "Field must not be empty...";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20,),
                                      DateTimeField(
                                        format: format,
                                        controller: _toDateController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 15, bottom: 15, left: 10, right: 10),
                                          labelText: "${snapshot.data["leave"]["end_date"]}",
                                          labelStyle: TextStyle(
                                            fontSize: 10.sp,
                                          ),
                                          hintText: "${snapshot.data["leave"]["end_date"]}",
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: appColors.gray200)
                                          ),
                                          suffixIcon: Icon(
                                            Icons.date_range,
                                          ),
                                        ),

                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ?? DateTime.now(),
                                              lastDate: DateTime(2100)
                                          );
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return "Field must not be empty...";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20,),
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.newline,
                                        minLines: 2,
                                        maxLines: 10,
                                        controller: _leaveReasionController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 15, bottom: 15, left: 10, right: 10),
                                          labelText: "${snapshot.data["leave"]["leave_reason"]}",
                                          labelStyle: TextStyle(
                                            fontSize: 10.sp,
                                          ),
                                          hintText:  "${snapshot.data["leave"]["leave_reason"]}",

                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: appColors.gray200)
                                          ),

                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Field must not be empty... ";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 20,),
                                      TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        textInputAction: TextInputAction.newline,
                                        minLines: 2,
                                        maxLines: 10,
                                        controller: _RemarkController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              top: 15, bottom: 15, left: 10, right: 10),
                                          labelText:  "${snapshot.data["leave"]["remark"]}",
                                          labelStyle: TextStyle(
                                            fontSize: 10.sp,
                                          ),
                                          hintText: "${snapshot.data["leave"]["remark"]}",

                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1, color: appColors.gray200)
                                          ),

                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Field must not be empty... ";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 30,),
                                      GestureDetector(
                                        onTap: () {
                                          getLiveList();
                                          _editLeaveList(leaveID);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(top: 15, bottom: 15),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: appColors.secondColor
                                          ),
                                          child: Center(child: Text("Apply",
                                            style: TextStyle(
                                                color: appColors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp
                                            ),
                                          )),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                              );
                            }else{
                              return NoDataFound();
                            }

                          }else{
                            return MediunText(text: "Something with wearing");
                          }
                        }
                    ),


              );
            },
          );
        }
    );
  }

  //apply menthod
  _editLeaveList(id)async{

    if(_LeaveFormKey.currentState!.validate()){
      setState((){
        _isLeaveApply = true;

      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');

      var response = await http.post(Uri.parse("${APIService.baseUrl}/leave/update/${id.toString()}"),
          body: {
            "leave_type_id" : "2",
            "start_date" : _fromDateController.text,
            "end_date" : _toDateController.text,
            "leave_reason" : _leaveReasionController.text,
            "remark" : _RemarkController.text,
          },
          headers: {
            "Authorization" : "Bearer $token",

          }
      );

      if(response.statusCode == 201){
       Navigator.pop(context);

       LeaveListItem = getLiveList();
       _fromDateController.clear();
       _RemarkController.clear();
       _leaveReasionController.clear();
       _toDateController.clear();
       _selectTypeControler.clear();

       ShowToast("Leave Report is Updated").successToast();

      }else{
        ShowToast("Something went wearing").errorToast();
      }

      setState((){
        _isLeaveApply = false;
      });

    }
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
  final bool icon;
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
     required this.icon,
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
                  icon? IconButton(
                    onPressed: editFunction,
                    icon: Icon(
                      Icons.edit,
                      color: color,
                      size: 20,
                    ),
                  ): Center(),
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

