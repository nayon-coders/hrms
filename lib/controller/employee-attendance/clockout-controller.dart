import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AttendanceClockOutController{
  Future<dynamic>employeeAttendanceClockOut()async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');


    var url = Uri.parse(APIService.clockOutUrl);
    return await http.post(url,
        body: jsonEncode("data"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );

  }
}