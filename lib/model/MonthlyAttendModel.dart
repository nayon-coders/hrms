// To parse this JSON data, do
//
//     final monthlyAttendanceModel = monthlyAttendanceModelFromJson(jsonString);

import 'dart:convert';

MonthlyAttendanceModel monthlyAttendanceModelFromJson(String str) => MonthlyAttendanceModel.fromJson(json.decode(str));

String monthlyAttendanceModelToJson(MonthlyAttendanceModel data) => json.encode(data.toJson());

class MonthlyAttendanceModel {
  MonthlyAttendanceModel({
    required this.attendanceEmployee,
  });

  List<AttendanceEmployee> attendanceEmployee;

  factory MonthlyAttendanceModel.fromJson(Map<String, dynamic> json) => MonthlyAttendanceModel(
    attendanceEmployee: List<AttendanceEmployee>.from(json["attendanceEmployee"].map((x) => AttendanceEmployee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attendanceEmployee": List<dynamic>.from(attendanceEmployee.map((x) => x.toJson())),
  };
}

class AttendanceEmployee {
  AttendanceEmployee({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
    required this.clockIn,
    required this.clockOut,
    required this.late,
    required this.earlyLeaving,
    required this.overtime,
    required this.totalRest,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String employeeId;
  DateTime date;
  String status;
  String clockIn;
  String clockOut;
  String late;
  String earlyLeaving;
  String overtime;
  String totalRest;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory AttendanceEmployee.fromJson(Map<String, dynamic> json) => AttendanceEmployee(
    id: json["id"],
    employeeId: json["employee_id"],
    date: DateTime.parse(json["date"]),
    status: json["status"],
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    late: json["late"],
    earlyLeaving: json["early_leaving"],
    overtime: json["overtime"],
    totalRest: json["total_rest"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "status": status,
    "clock_in": clockIn,
    "clock_out": clockOut,
    "late": late,
    "early_leaving": earlyLeaving,
    "overtime": overtime,
    "total_rest": totalRest,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
