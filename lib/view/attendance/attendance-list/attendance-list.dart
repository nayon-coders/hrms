import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:HRMS/view/global_widget/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../service/api-service.dart';
import '../../global_widget/mediun_text.dart';
import '../../home_screen/home.dart';
import '../../profile/profile.dart';
import '../attendance.dart';

class AttendaceList extends StatefulWidget {
  const AttendaceList({Key? key}) : super(key: key);

  @override
  _AttendaceListState createState() => _AttendaceListState();
}

class _AttendaceListState extends State<AttendaceList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromMonthlyAttendance();
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final dateFormate = DateFormat.yMMMMd('en_US');
  late final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());
  late dynamic toMonth ;
  var monthFormat = DateFormat("yyyy-MM");
  dynamic toDay;
  dynamic month = DateFormat("yyyy-MM").format(DateTime.now());
  dynamic SearchDay;
  bool selectDate = false;
  bool selectMonth = false;
  var currentMonthYear = DateTime.now().month;

  dynamic monthlyAtteandanceList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bg,
      body: Column(
        children: [
            Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height/1.9,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color(0xff00315E),
                        Color(0xff580082),
                      ],
                    )),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 6.h, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: appColors.white,
                            )
                        ),
                        MediunText(text: "Attendance List", size: 11.sp, color: appColors.white,),
                      ],
                    ),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            selectDate = false;
                          });
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          color: appColors.white,
                        )
                    ),

                  ],
                ),
              ),

              //calendar
              Container(
                margin: EdgeInsets.only(top: 13.h, left: 2.h, right: 2.h),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010),
                  lastDay:  DateTime.utc(2500),
                  focusedDay: _focusedDay,
                  rowHeight: 35,
                  calendarFormat: _calendarFormat,
                    calendarStyle:  CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: appColors.secondColor,
                          shape: BoxShape.rectangle
                      ),
                      weekendTextStyle:TextStyle(
                        color: appColors.secondColor
                      ),
                      defaultTextStyle: TextStyle(
                          color: appColors.white,
                        fontSize: 11.sp,
                      ),

                      selectedTextStyle: TextStyle(
                        fontSize: 11.sp,
                        color: appColors.white,
                      ),
                      selectedDecoration: BoxDecoration(
                          color: appColors.successColor,
                        shape: BoxShape.rectangle
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: appColors.gray,

                      ),
                      weekendStyle: TextStyle(
                        color: appColors.secondColor,
                      ),
                    ),
                    weekendDays: [DateTime.friday],
                    headerStyle: HeaderStyle(
                      headerMargin: const EdgeInsets.only(top: 10, bottom: 15),
                        headerPadding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: appColors.white), 
                          borderRadius: BorderRadius.circular(100),
                        ),
                      titleTextStyle: const TextStyle(
                        color: appColors.white,
                      ),
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        Icons.arrow_back_ios,
                        color: appColors.white,
                        size: 11.sp,
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: appColors.white,
                        size: 11.sp,
                      )
                    ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        selectDate = true;
                      });
                      SearchDay = (DateFormat("yyyy-MM-dd").format(_selectedDay!));
                      toDay = (dateFormate.format(_selectedDay!));
                      print(SearchDay);
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    setState(() {
                      selectMonth = true;
                    });
                    _focusedDay = focusedDay;
                    month = monthFormat.format(_focusedDay);
                    toMonth = (dateFormate.format(_focusedDay!));
                  },
                ),

              ),

              Container(
                padding: EdgeInsets.only(top: 50.h),
                child: Container(
                  height: 22,
                  decoration:  BoxDecoration(
                      color: appColors.bg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )
                  ),
                ),
              ),
            ],
          ),

          Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: appColors.gray200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: selectDate ? MediunText(text: toDay.toString(), size: 10.sp, color: appColors.gray,)
                            : selectMonth ? MediunText(text: toMonth.toString(), size: 10.sp, color: appColors.gray,):
                        MediunText(text: monthOfTheYear.toString(), size: 10.sp, color: appColors.gray,),
                      ),
                    ),
                    const SizedBox(height: 10,),

                    FutureBuilder(
                        future: fromMonthlyAttendance(),
                        builder: (context, AsyncSnapshot<dynamic> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Expanded(
                              child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index){
                                    return _loading();
                                  }
                              ),
                            );
                            return _loading();
                          }else if(snapshot.hasData){
                            return Expanded(
                              child: ListView.builder(
                                itemCount: monthlyAtteandanceList['attendanceEmployee'].length,
                                  itemBuilder: (context, index){
                                  var data = monthlyAtteandanceList['attendanceEmployee'][index];
                                    var status = data['status'];
                                    var atteDate =  dateFormate.format(DateTime.parse(data['date']));
                                    if(status == 'Late'){
                                      return ListAttendace(
                                          color: appColors.secondColor,
                                          date:  atteDate.toString(),
                                          status: status.toString(),
                                          clockin: data["clock_in"].toString(),
                                          clockout: data["clock_out"].toString(),
                                          late: data["late"].toString(),
                                          earlyLeave: data["early_leaving"].toString(),
                                      );
                                    }else if(status == 'Present'){
                                      return ListAttendace(
                                        color: appColors.successColor,
                                        date: atteDate.toString(),
                                        status: status.toString(),
                                        clockin: data["clock_in"].toString(),
                                        clockout: data["clock_out"].toString(),
                                        late: data["late"].toString(),
                                        earlyLeave: data["early_leaving"].toString(),
                                      );
                                    }else{
                                      return ListAttendace(
                                        color: appColors.dangerColor,
                                        date:atteDate.toString(),
                                        status: status.toString(),
                                        clockin: data["clock_in"].toString(),
                                        clockout: data["clock_out"].toString(),
                                        late: data["late"].toString(),
                                        earlyLeave: data["early_leaving"].toString(),
                                      );
                                    }

                                  }
                              ),
                            );
                          }else{
                             return Expanded(
                               child: Center(
                                 child: MediunText(text: "No Data Found"),
                               ),
                             );
                          }
                        }
                    ),

                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
        ],
      ),





      //navigation bar
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 80,
          height: 80,
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient:
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xffFE5709),
                  Color(0xffFE5709),
                ],
              )
          ),
          child: const Icon(Icons.add),
        ),
        onPressed: () {
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Attendance()));
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.dashboard,
                          color:  appColors.mainColor,
                        ),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: appColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.supervised_user_circle,
                          color: appColors.mainColor,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: appColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  ///loding
  Widget _loading(){
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: appColors.white,
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerLoading(width: 70, height: 10,),
              ShimmerLoading(width: 70, height: 10,),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLoading(width: 50, height: 10,),
                  SizedBox(height: 3,),
                  ShimmerLoading(width: 50, height: 10,),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLoading(width: 50, height: 10,),
                  SizedBox(height: 3,),
                  ShimmerLoading(width: 50, height: 10,),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLoading(width: 50, height: 10,),
                  SizedBox(height: 3,),
                  ShimmerLoading(width: 50, height: 10,),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerLoading(width: 50, height: 10,),
                  SizedBox(height: 3,),
                  ShimmerLoading(width: 50, height: 10,),
                ],
              ),
            ],
          )

        ],
      ),
    );
  }


  Future<void> fromMonthlyAttendance() async{

        SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');

    var dailyAtten = {
      "date" : SearchDay,
      "type" : "daily",
    };
    var monthlyAtten = {
      "month" : month,
      "type" : "monthly",
    };


    final response = await http.post(Uri.parse(APIService.attendanceListURL),
        body: selectDate ? dailyAtten : monthlyAtten,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    var body = jsonDecode(response.body.toString());
    if(response.statusCode == 201){
      var data = jsonDecode(response.body.toString());
      print(response.statusCode);
      return monthlyAtteandanceList = data;

    }else{
      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }

  }


}

class ListAttendace extends StatelessWidget {
  final Color color;
  final String date;
  final String status;
  final String clockin;
  final String clockout;
  final String late;
  final String earlyLeave;

  ListAttendace({
    required this.color,
    required this.date,
    required this.status,
    required this.clockin,
    required this.clockout,
    required this.late,
    required this.earlyLeave
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediunText(text: "${date}", size: 9, color: appColors.gray,),
              BigText(text: status, size: 12, color: color,)
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Clock In", color: appColors.gray, size: 8.sp,),
                  MediunText(text: clockin, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Clock Out", color: appColors.gray, size: 8.sp,),
                  MediunText(text: clockout, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Late", color: appColors.gray, size: 8.sp,),
                  MediunText(text: late, color: appColors.black, size: 8.sp,)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BigText(text: "Early Leave", color: appColors.gray, size: 8.sp,),
                  MediunText(text: earlyLeave, color: appColors.black, size: 8.sp,)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

