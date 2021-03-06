import 'dart:convert';
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/no-data.dart';
import 'package:HRMS/view/global_widget/server-error.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../service/api-service.dart';
import 'package:http/http.dart' as http;
import '../../global_widget/big_text.dart';
import '../../global_widget/notify.dart';
import '../../profile/profile.dart';
import '../appy-attendnace-regularization/apply-attendnace-regularization.dart';

class ApplyAttendanceRegularizationList extends StatefulWidget {
  const ApplyAttendanceRegularizationList({Key? key}) : super(key: key);

  @override
  _ApplyAttendanceRegularizationListState createState() =>
      _ApplyAttendanceRegularizationListState();
}

class _ApplyAttendanceRegularizationListState
    extends State<ApplyAttendanceRegularizationList> {
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());
  late Color color;

  @override
  void initState() {
    super.initState();
    regularaizationList = getRegularaization();
  }

  final List<String> items = [
    'Forget Clock IN',
    'Forget Clock OUT',
    'Late Arrival',
    'Early Leaving',
    'Business Visit',
  ];
  var checkClockTimeValues;
  var clockInTime;
  var clockOutTime;

  String? selectedLeaveTypeValue;

  late DateTime date;
  late dynamic formatingDate = DateFormat("yyyy-MM");
  final _fromDateController = TextEditingController();
  final _clockinTimeController = TextEditingController();
  final _clockOutTimeController = TextEditingController();
  final _ReasonController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final _LeaveFormKey = GlobalKey<FormState>();

  bool _isClockIN = false;
  bool _isClockOut = false;
  bool _isCurrectDate = true;
  bool _isLeaveApply = false;
  bool _isEdatingDataLoaded = false;
  String? regularaizID;

  Future? regularaizationList;
  Future? editRegularaizationList;

  Future<void> getRegularaization() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(Uri.parse(APIService.regularizationList),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());

      var reguList = data;
      return reguList;
    } else {
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }
  }

  Future<void> getEditRegularaization() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.get(
        Uri.parse("${APIService.baseUrl}/regularization/edit/${regularaizID}"),
        headers: {
          "Accept": "application/json",
          'content-Type': 'application/json',
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 201) {
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      var reguList = data;
      return reguList;
    } else {
      print(token);
      print(response.statusCode);
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appColors.white,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
          child: Container(
            width: width,
            height: height,
            child: FutureBuilder(
                future: regularaizationList,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    bool isPending;
                    var data = snapshot.data['regularize_attendance'];
                    if (snapshot.data['regularize_attendance'].length > 0) {
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            if (data[index]["status"] == "Pending") {
                              color = appColors.mainColor;
                              isPending = true;
                            } else {
                              color = appColors.successColor;
                              isPending = false;
                            }
                            var date = DateFormat.yMMMMd()
                                .format(DateTime.parse(data[index]["date"]));
                            return leaveListItem(
                                date: date,
                                status: data[index]["status"].toString(),
                                editStatus: data[index]["status"] == "Pending"
                                    ? true
                                    : false,
                                editFunction: () {
                                  setState(() {
                                    _fromDateController.text = date;
                                    _clockinTimeController.text =
                                        data[index]['regularized_in_time'];
                                    _clockOutTimeController.text =
                                        data[index]['regularized_out_time'];
                                    _ReasonController.text =
                                        data[index]['description'];
                                    selectedLeaveTypeValue =
                                        data[index]['reason'];

                                    regularaizID = data[index]['id'].toString();
                                    editRegularaizationList =
                                        getEditRegularaization();
                                  });
                                  _editeRegularaization();
                                },
                                in_time: data[index]['regularized_in_time']
                                    .toString(),
                                out_time: data[index]['regularized_out_time']
                                    .toString(),
                                reason: data[index]['reason'].toString(),
                                description: data[index]['description'],
                                color: color);
                          });
                    } else {
                      return NoDataFound();
                    }
                  } else {
                    return ServerError();
                  }
                }),
          )),
    );
  }

  void _editeRegularaization() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              child: FutureBuilder(
                  future: editRegularaizationList,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      var data = snapshot.data["regularize_attendance"];
                      return Form(
                        key: _LeaveFormKey,
                        child: ListView(
                          children: [
                            MediunText(
                              text: "Update Regularization",
                              size: 10.sp,
                              color: appColors.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            CustomDropdownButton2(
                              hint: "${data["reason"]}",
                              buttonHeight: 55,
                              buttonWidth: MediaQuery.of(context).size.width,
                              buttonPadding: EdgeInsets.all(10),
                              dropdownWidth:
                                  MediaQuery.of(context).size.width / 1.1,
                              buttonDecoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: appColors.gray),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              dropdownItems: items,
                              value: selectedLeaveTypeValue,
                              onChanged: (value) {
                                setState(() {
                                  if (value == items[0]) {
                                    selectedLeaveTypeValue = value;
                                    _isClockIN = false;
                                    _isClockOut = true;
                                  }
                                  if (value == items[1]) {
                                    selectedLeaveTypeValue = value;
                                    _isClockOut = false;
                                    _isClockIN = true;
                                  }
                                  if (value == items[2]) {
                                    selectedLeaveTypeValue = value;
                                    _isClockOut = true;
                                    _isClockIN = false;
                                  }
                                  if (value == items[3]) {
                                    selectedLeaveTypeValue = value;
                                    _isClockIN = true;
                                    _isClockOut = false;
                                  }
                                  if (value == items[4]) {
                                    selectedLeaveTypeValue = value;
                                    _isClockOut = false;
                                    _isClockIN = false;
                                  }
                                });
                              },
                            ),

                            //date field
                            const SizedBox(
                              height: 20,
                            ),
                            DateTimeField(
                              format: format,
                              controller: _fromDateController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10, right: 10),
                                labelStyle: TextStyle(
                                  fontSize: 10.sp,
                                ),
                                hintText: data["date"],
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: _isCurrectDate
                                            ? appColors.gray200
                                            : appColors.secondColor)),
                                suffixIcon: Icon(
                                  Icons.date_range,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (selectedLeaveTypeValue != items[4]) {
                                    if (value != null) {
                                      _checkClockTimeWithSelectedDate(value);
                                    }
                                  }
                                });
                              },
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2022),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime.now());
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Field must not be empty...";
                                } else if (_isCurrectDate != true) {
                                  return "This date is not available";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //time field
                            Row(
                              children: [
                                //clockin time
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    readOnly: _isClockIN,
                                    controller: _clockinTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 10,
                                          right: 10),
                                      hintText: data["regularized_in_time"],
                                      filled: true,
                                      fillColor: _isClockIN
                                          ? appColors.gray200
                                          : appColors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: appColors.gray200)),
                                      suffixIcon: Icon(
                                        Icons.date_range,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Field must not be empty...";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    readOnly: _isClockOut,
                                    controller: _clockOutTimeController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 15,
                                          bottom: 15,
                                          left: 10,
                                          right: 10),
                                      hintText: data["regularized_out_time"],
                                      filled: true,
                                      fillColor: _isClockOut
                                          ? appColors.gray200
                                          : appColors.white,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: appColors.gray200)),
                                      suffixIcon: Icon(
                                        Icons.date_range,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Field must not be empty...";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 2,
                              maxLines: 10,
                              controller: _ReasonController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10, right: 10),
                                labelStyle: TextStyle(
                                  fontSize: 10.sp,
                                ),
                                hintText: data["description"],
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: appColors.gray200)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Field must not be empty... ";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                _isCurrectDate ? _applyLeaveMethod() : null;
                                //_
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: _isCurrectDate
                                        ? appColors.secondColor
                                        : appColors.gray),
                                child: Center(
                                    child: Text(
                                  _isCurrectDate ? "Apply" : "Date is missing",
                                  style: TextStyle(
                                      color: appColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                )),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ServerError();
                    }
                  }),
            ),
          );
        });
      },
    );
  }

  _checkClockTimeWithSelectedDate(DateTime selectedDate) async {
    print(DateFormat('yyyy-MM-dd').format(selectedDate));
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    var response =
        await http.post(Uri.parse(APIService.getInOutClockTime), body: {
      "date": DateFormat('yyyy-MM-dd').format(selectedDate),
    }, headers: {
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      setState(() {
        _isCurrectDate = true;
      });
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      print(checkClockTimeValues);
      setState(() {
        ShowToast("Selected date is Match").successToast();
        print("date is match");
        _clockinTimeController..text = data['clock_in'].toString();
        _clockOutTimeController..text = data['clock_out'].toString();
      });
      return checkClockTimeValues = data;
    } else {
      setState(() {
        _clockinTimeController..text = "Clock IN";
        _clockOutTimeController..text = "Clock Out";
        _isCurrectDate = false;
      });
      ShowToast("Selected date is missing").errorToast();
      print(response.statusCode);
      print(_isCurrectDate);
    }
  }

  //update
  Future<void> _applyLeaveMethod() async {
    if (_LeaveFormKey.currentState!.validate()) {
      setState(() {
        _isLeaveApply = true;
        print(regularaizID);
      });

      if (selectedLeaveTypeValue != null) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        //Store Data
        var token = localStorage.getString('token');

        var response = await http.post(
            Uri.parse(
                "https://asia.net.in/api/regularization/update/$regularaizID"),
            body: {
              "date": _fromDateController.text,
              "reason": selectedLeaveTypeValue,
              "in_time": _clockinTimeController.text,
              "out_time": _clockOutTimeController.text,
              "description": _ReasonController.text,
            },
            headers: {
              "Authorization": "Bearer $token",
            });

        if (response.statusCode == 201) {
          Navigator.pop(context);
          ShowToast("Update Sucess").successToast();
        } else {
          print(response.statusCode);
          ShowToast("Update failed").errorToast();
        }
      } else {
        ShowToast("Field much not be empty").errorToast();
      }

      setState(() {
        _isLeaveApply = false;
      });
    }
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
  final bool editStatus;
  leaveListItem({
    required this.date,
    required this.status,
    required this.editFunction,
    required this.in_time,
    required this.out_time,
    required this.reason,
    required this.description,
    required this.color,
    required this.editStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
              MediunText(
                text: date,
                size: 9,
                color: appColors.gray,
              ),
              Row(
                children: [
                  BigText(
                    text: status,
                    size: 12,
                    color: color,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  editStatus
                      ? IconButton(
                          onPressed: editFunction,
                          icon: Icon(
                            Icons.edit,
                            color: color,
                            size: 20,
                          ),
                        )
                      : Center(),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(
                    text: "In Time",
                    color: appColors.gray,
                    size: 8.sp,
                  ),
                  MediunText(
                    text: in_time,
                    color: appColors.black,
                    size: 8.sp,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(
                    text: "Out Time",
                    color: appColors.gray,
                    size: 8.sp,
                  ),
                  MediunText(
                    text: out_time,
                    color: appColors.black,
                    size: 8.sp,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(
                    text: "Reason",
                    color: appColors.gray,
                    size: 8.sp,
                  ),
                  MediunText(
                    text: reason,
                    color: appColors.black,
                    size: 8.sp,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediunText(
                text: "Regularization Reason: ",
                size: 10.sp,
              ),
              Text(
                description,
                style: TextStyle(color: appColors.gray, fontSize: 9.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}
