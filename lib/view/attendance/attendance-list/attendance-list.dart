import 'package:HRMS/utility/colors.dart';
import 'package:HRMS/view/global_widget/big_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final dateFormate = DateFormat.yMMMMd('en_US');
  final monthOfTheYear = DateFormat.yMMM().format(DateTime.now());
  dynamic toDay;
  dynamic month;
  dynamic year;
  bool selectDate = false;

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
                padding: EdgeInsets.only(left: 20, right: 20, top: 9.h, bottom: 10),
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
                            icon: Icon(
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
                margin: EdgeInsets.only(top: 15.h, left: 2.h, right: 2.h),
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
                      toDay = (dateFormate.format(_selectedDay!));
                      print(toDay);
                      print(toDay);
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
                    _focusedDay = focusedDay;
                  },
                ),

              ),

              Container(
                padding: EdgeInsets.only(top: 49.h),
                child: Container(
                  height: 40,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: appColors.gray200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //child: selectDate ? MediunText(text: toDay.toString()) : MediunText(text: monthOfTheYear.toString()),

                      child: Center(
                        child: selectDate ? MediunText(text: toDay.toString(), size: 10.sp, color: appColors.gray,) : MediunText(text: monthOfTheYear.toString(), size: 10.sp, color: appColors.gray,),
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: appColors.white,
                        border: const Border(
                          left: BorderSide(width: 10.0, color: appColors.successColor),
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
                              MediunText(text: "Dec 23, 2018", size: 9, color: appColors.gray,), 
                              BigText(text: "Present", size: 12, color: appColors.successColor,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock In", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock Out", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Late", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Early Leave", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                            ],
                          )
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: appColors.white,
                        border: const Border(
                          left: BorderSide(width: 10.0, color: appColors.successColor),
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
                              MediunText(text: "Dec 23, 2018", size: 9, color: appColors.gray,),
                              BigText(text: "Present", size: 12, color: appColors.successColor,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock In", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock Out", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Late", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Early Leave", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 2.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: appColors.white,
                        border: const Border(
                          left: BorderSide(width: 10.0, color: appColors.successColor),
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
                              MediunText(text: "Dec 23, 2018", size: 9, color: appColors.gray,),
                              BigText(text: "Present", size: 12, color: appColors.successColor,)
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock In", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Clock Out", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "5:50 PM	", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Late", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BigText(text: "Early Leave", color: appColors.gray, size: 10.sp,),
                                  MediunText(text: "06:50:50", color: appColors.black, size: 9.sp,)
                                ],
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                    const SizedBox(height: 55,),
                  ],
                ),
              ),
            ),
          )
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
}
