// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) => UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    required this.userDetail,
  });

  UserDetail userDetail;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    userDetail: UserDetail.fromJson(json["userDetail"]),
  );

  Map<String, dynamic> toJson() => {
    "userDetail": userDetail.toJson(),
  };
}

class UserDetail {
  UserDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.apiToken,
    this.emailVerifiedAt,
    this.plan,
    this.planExpireDate,
    required this.requestedPlan,
    required this.type,
    this.avatar,
    required this.lang,
    required this.createdBy,
    this.defaultPipeline,
    required this.deleteStatus,
    required this.isActive,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.messengerColor,
    required this.darkMode,
    required this.activeStatus,
    required this.userId,
    required this.customField,
    required this.profile,
  });

  int id;
  String name;
  String email;
  String apiToken;
  dynamic emailVerifiedAt;
  dynamic plan;
  dynamic planExpireDate;
  String requestedPlan;
  String type;
  dynamic avatar;
  String lang;
  String createdBy;
  dynamic defaultPipeline;
  String deleteStatus;
  String isActive;
  DateTime lastLoginAt;
  DateTime createdAt;
  DateTime updatedAt;
  String messengerColor;
  String darkMode;
  String activeStatus;
  String userId;
  List<dynamic> customField;
  String profile;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    apiToken: json["api_token"],
    emailVerifiedAt: json["email_verified_at"],
    plan: json["plan"],
    planExpireDate: json["plan_expire_date"],
    requestedPlan: json["requested_plan"],
    type: json["type"],
    avatar: json["avatar"],
    lang: json["lang"],
    createdBy: json["created_by"],
    defaultPipeline: json["default_pipeline"],
    deleteStatus: json["delete_status"],
    isActive: json["is_active"],
    lastLoginAt: DateTime.parse(json["last_login_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    messengerColor: json["messenger_color"],
    darkMode: json["dark_mode"],
    activeStatus: json["active_status"],
    userId: json["user_id"],
    customField: List<dynamic>.from(json["customField"].map((x) => x)),
    profile: json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "api_token": apiToken,
    "email_verified_at": emailVerifiedAt,
    "plan": plan,
    "plan_expire_date": planExpireDate,
    "requested_plan": requestedPlan,
    "type": type,
    "avatar": avatar,
    "lang": lang,
    "created_by": createdBy,
    "default_pipeline": defaultPipeline,
    "delete_status": deleteStatus,
    "is_active": isActive,
    "last_login_at": lastLoginAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "messenger_color": messengerColor,
    "dark_mode": darkMode,
    "active_status": activeStatus,
    "user_id": userId,
    "customField": List<dynamic>.from(customField.map((x) => x)),
    "profile": profile,
  };
}
