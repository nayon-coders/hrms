import 'dart:convert';

import 'package:HRMS/model/TodayAttendanceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../service/api-service.dart';

class TodayAttendanceController{
  //show all world status
  Future<TodaysAttendanceModel>fromTodayAttendance()async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');


    final response = await http.get(Uri.parse(APIService.todayAttendanceListURL),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    if(response.statusCode == 201){
      var data = jsonDecode(response.body);
      return TodaysAttendanceModel.fromJson(data);

    }else{

      print("error");
      print(response.statusCode);
      throw Exception("Error");
    }
  }
}