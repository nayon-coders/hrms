import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AttendanceClockingController{
    employeeAttendance()async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    var url = Uri.parse(APIService.clockInUrl);
    return await http.post(url,
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

  }
}