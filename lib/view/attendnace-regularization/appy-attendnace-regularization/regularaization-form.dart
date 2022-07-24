import 'dart:convert';
import 'dart:math';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/attendnace-regularization/appy-attendnace-regularization/apply-attendnace-regularization.dart';
import 'package:HRMS/view/global_widget/mediun_text.dart';
import 'package:HRMS/view/global_widget/notify.dart';
import 'package:HRMS/view/global_widget/show-toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:HRMS/utility/colors.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class RegularaizationForm extends StatefulWidget {
  const RegularaizationForm({Key? key}) : super(key: key);

  @override
  _RegularaizationFormState createState() => _RegularaizationFormState();
}

class _RegularaizationFormState extends State<RegularaizationForm> {
  final List<String> items = [
    'Forget Clock IN',
    'Forget Clock OUT',
    'Late Arrival',
    'Early Leaving',
    'Business Visit',
  ];

  bool _isDataMatching = false;
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
  final timeFormate = DateFormat("h:m");
  final _LeaveFormKey = GlobalKey<FormState>();

  bool _isLeaveApply = false;

  bool _isClockIN = false;
  bool _isClockOut = false;
  bool _isCurrectDate = true;

  @override
  void initState() {
    super.initState();
  }

  TimeOfDay _time = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: _isLeaveApply
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: MediunText(text: "Applying..."),
                ),
              ],
            )
          : Form(
              key: _LeaveFormKey,
              child: ListView(
                children: [
                  MediunText(
                    text: "Apply for Attendance Regularization",
                    size: 10.sp,
                    color: appColors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CustomDropdownButton2(
                    hint: 'Select Type',
                    buttonHeight: 55,
                    buttonWidth: MediaQuery.of(context).size.width,
                    buttonPadding: EdgeInsets.all(10),
                    dropdownWidth: MediaQuery.of(context).size.width / 1.1,
                    buttonDecoration: BoxDecoration(
                      border: Border.all(width: 1, color: appColors.gray),
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
                      labelText: "Date",
                      labelStyle: TextStyle(
                        fontSize: 10.sp,
                      ),
                      hintText: "Date",
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
                          _checkClockTimeWithSelectedDate(value!);
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
                        return " Date field must not be empty";
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
                  _isDataMatching
                      ? Shimmer.fromColors(
                          highlightColor: appColors.gray200,
                          baseColor: appColors.white,
                          child: Row(
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
                                    hintText: "Clock IN",
                                    filled: true,
                                    fillColor: _isClockIN
                                        ? appColors.gray200
                                        : appColors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: appColors.gray200)),
                                    suffixIcon: Icon(
                                      Icons.calendar_today_rounded,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Clock In field must not be empty";
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
                                    hintText: "Clock Out",
                                    filled: true,
                                    fillColor: _isClockOut
                                        ? appColors.gray200
                                        : appColors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: appColors.gray200)),
                                    suffixIcon: Icon(
                                      Icons.calendar_today_rounded,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Clock Out field must not be empty.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            //clockin time
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                onTap: () async {
                                  final TimeOfDay? newTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: _time,
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      _time = newTime;
                                      _clockinTimeController.text =
                                          _time.format(context);
                                    });
                                  }
                                },
                                readOnly: true,
                                controller: _clockinTimeController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10, right: 10),
                                  hintText: "Clock IN",
                                  filled: true,
                                  fillColor: _isClockIN
                                      ? appColors.gray200
                                      : appColors.white,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: appColors.gray200)),
                                  suffixIcon: Icon(
                                     Icons.watch_later,
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
                                onTap: () async {
                                  final TimeOfDay? newTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: _time,
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      _time = newTime;
                                      _clockOutTimeController.text =
                                          _time.format(context);
                                    });
                                  }
                                },
                                readOnly: true,
                                controller: _clockOutTimeController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10, right: 10),
                                  hintText: "Clock Out",
                                  filled: true,
                                  fillColor: _isClockOut
                                      ? appColors.gray200
                                      : appColors.white,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: appColors.gray200)),
                                  suffixIcon: Icon(
                                    Icons.watch_later,
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
                      labelText: "Clarification For Regularization",
                      labelStyle: TextStyle(
                        fontSize: 10.sp,
                      ),
                      hintText: "Clarification For Regularization",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: appColors.gray200)),
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
            ),
    );
  }

  _checkClockTimeWithSelectedDate(DateTime selectedDate) async {
    setState(() {
      _isDataMatching = true;
    });
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
      setState(() {
        _isDataMatching = false;
        _clockinTimeController..text = data['clock_in'].toString();
        _clockOutTimeController..text = data['clock_out'].toString();
      });
      return checkClockTimeValues = data;
    } else {
      setState(() {
        _isDataMatching = false;
        _clockinTimeController..text = "Clock IN";
        _clockOutTimeController..text = "Clock Out";
        _isCurrectDate = false;
        _dataMissing();
      });
      print(response.statusCode);
      print(_isCurrectDate);
      //throw Exception("Error");
    }
  }

  _applyLeaveMethod() async {
    if (_LeaveFormKey.currentState!.validate()) {
      setState(() {
        _isLeaveApply = true;
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      //Store Data
      var token = localStorage.getString('token');

      var response =
          await http.post(Uri.parse(APIService.addRegularaigetion), body: {
        "date": _fromDateController.text,
        "reason": selectedLeaveTypeValue,
        "in_time": _clockinTimeController.text,
        "out_time": _clockOutTimeController.text,
        "description": _ReasonController.text,
      }, headers: {
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 201) {
        ShowToast("Regularization submitted successfully.").successToast();
      } else {
        ShowToast(
                "😒 Oops! Server is down presently. Please try after some time.")
            .errorToast();
      }

      setState(() {
        _isLeaveApply = false;
      });
    }
  }

//show error
  Future<void> _dataMissing() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            height: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/error.png",
                    width: 90,
                    height: 90,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      "Sorry...! Attendance date is Missing. Try again with correct date.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12.sp),
                    )),
                SizedBox(
                  height: 5.h,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AttendanceRegularization(index: 0)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: appColors.secondColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 20,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                        child: MediunText(
                      text: "Try again",
                      size: 12.sp,
                      color: appColors.white,
                    )),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
