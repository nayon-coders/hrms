import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController{
  Future<http.Response> logout() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var fullUrl = APIService.logoutUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode('logout'),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
  }
}