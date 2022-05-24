// To parse this JSON data, do
//
//     final todaysAttendance = todaysAttendanceFromJson(jsonString);

import 'dart:convert';

TodaysAttendanceModel todaysAttendanceFromJson(String str) => TodaysAttendanceModel.fromJson(json.decode(str));

String todaysAttendanceToJson(TodaysAttendanceModel data) => json.encode(data.toJson());

class TodaysAttendanceModel {
  TodaysAttendanceModel({
    required this.todaysAttendance,
  });

  TodaysAttendanceClass todaysAttendance;

  factory TodaysAttendanceModel.fromJson(Map<String, dynamic> json) => TodaysAttendanceModel(
    todaysAttendance: TodaysAttendanceClass.fromJson(json["todaysAttendance"]),
  );

  Map<String, dynamic> toJson() => {
    "todaysAttendance": todaysAttendance.toJson(),
  };
}

class TodaysAttendanceClass {
  TodaysAttendanceClass({
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

  factory TodaysAttendanceClass.fromJson(Map<String, dynamic> json) => TodaysAttendanceClass(
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
