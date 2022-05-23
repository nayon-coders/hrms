import 'dart:convert';

import 'package:HRMS/model/attendance-list-model.dart';
import 'package:HRMS/service/api-service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttedanceListController{
  Future<AttendanceEmployeeModel>fromAttendance()async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');

    var url = Uri.parse(APIService.attendanceListURL);
    final response = await http.get(url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if(response.statusCode == 200){
      return AttendanceEmployeeModel.fromJson(jsonDecode(response.body));
    }else{
      print(response.statusCode);
      throw Exception("Error");
    }
  }


}