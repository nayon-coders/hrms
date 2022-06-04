// To parse this JSON data, do
//
//     final leaveListModel = leaveListModelFromJson(jsonString);

import 'dart:convert';

LeaveListModel leaveListModelFromJson(String str) => LeaveListModel.fromJson(json.decode(str));

String leaveListModelToJson(LeaveListModel data) => json.encode(data.toJson());

class LeaveListModel {
  LeaveListModel({
    required this.leaves,
  });

  List<Leaf> leaves;

  factory LeaveListModel.fromJson(Map<String, dynamic> json) => LeaveListModel(
    leaves: List<Leaf>.from(json["leaves"].map((x) => Leaf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "leaves": List<dynamic>.from(leaves.map((x) => x.toJson())),
  };
}

class Leaf {
  Leaf({
    required this.id,
    required this.employeeId,
    required this.leaveTypeId,
    required this.appliedOn,
    required this.startDate,
    required this.endDate,
    required this.totalLeaveDays,
    required this.totalLeaveDaysCurrentYear,
    required this.leaveReason,
    required this.remark,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String employeeId;
  String leaveTypeId;
  DateTime appliedOn;
  String startDate;
  String endDate;
  String totalLeaveDays;
  String totalLeaveDaysCurrentYear;
  String leaveReason;
  String remark;
  String status;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
    id: json["id"],
    employeeId: json["employee_id"],
    leaveTypeId: json["leave_type_id"],
    appliedOn: DateTime.parse(json["applied_on"]),
    startDate: json["start_date"],
    endDate: json["end_date"],
    totalLeaveDays: json["total_leave_days"],
    totalLeaveDaysCurrentYear: json["total_leave_days_current_year"],
    leaveReason: json["leave_reason"],
    remark: json["remark"],
    status: json["status"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "leave_type_id": leaveTypeId,
    "applied_on": "${appliedOn.year.toString().padLeft(4, '0')}-${appliedOn.month.toString().padLeft(2, '0')}-${appliedOn.day.toString().padLeft(2, '0')}",
    "start_date": startDate,
    "end_date": endDate,
    "total_leave_days": totalLeaveDays,
    "total_leave_days_current_year": totalLeaveDaysCurrentYear,
    "leave_reason": leaveReason,
    "remark": remark,
    "status": status,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
