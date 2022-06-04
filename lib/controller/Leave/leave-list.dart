import 'dart:convert';

import 'package:HRMS/model/leave-list-model.dart';
import 'package:HRMS/service/api-service.dart';
import 'package:HRMS/view/leave/leave-list/leave-list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/leave-type.dart';
import '../../model/user-info-model.dart';
class LeaveListController {
  Future<LeaveListModel> getLiveList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(
      Uri.parse(APIService.leaveListUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        "Authorization": "Bearer $token",
      }),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return LeaveListModel.fromJson(jsonDecode(response.body.toString()));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}