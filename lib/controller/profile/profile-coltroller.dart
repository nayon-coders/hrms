import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user-info-model.dart';
class UserProfileController {
  Future<UserInfoModel> getUserProfile() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    //Store Data
    var token = localStorage.getString('token');
    final response = await http.post(
      Uri.parse(APIService.profileUrl),
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
      return UserInfoModel.fromJson(jsonDecode(response.body));
    } else {

      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}