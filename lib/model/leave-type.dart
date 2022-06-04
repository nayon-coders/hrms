// To parse this JSON data, do
//
//     final leaveType = leaveTypeFromJson(jsonString);

import 'dart:convert';

LeaveType leaveTypeFromJson(String str) => LeaveType.fromJson(json.decode(str));

String leaveTypeToJson(LeaveType data) => json.encode(data.toJson());

class LeaveType {
  LeaveType({
    required this.leavetypes,
  });

  List<Leavetype> leavetypes;

  factory LeaveType.fromJson(Map<String, dynamic> json) => LeaveType(
    leavetypes: List<Leavetype>.from(json["leavetypes"].map((x) => Leavetype.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "leavetypes": List<dynamic>.from(leavetypes.map((x) => x.toJson())),
  };
}

class Leavetype {
  Leavetype({
    required this.id,
    required this.title,
    required this.days,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String title;
  String days;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Leavetype.fromJson(Map<String, dynamic> json) => Leavetype(
    id: json["id"],
    title: json["title"],
    days: json["days"],
    createdBy: json["created_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "days": days,
    "created_by": createdBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
