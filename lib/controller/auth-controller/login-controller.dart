import 'dart:convert';

import 'package:HRMS/service/api-service.dart';
import 'package:http/http.dart' as http;

class LoginController{
  Future<http.Response> login(loginInfo) async{
    var fullUrl = APIService.loginUrl;
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(loginInfo),
    );
  }
}