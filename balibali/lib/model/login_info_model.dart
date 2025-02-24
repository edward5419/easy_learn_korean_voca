// To parse this JSON data, do
//
//     final loginInfoModel = loginInfoModelFromJson(jsonString);

import 'dart:convert';

LoginInfoModel loginInfoModelFromJson(String str) =>
    LoginInfoModel.fromJson(json.decode(str));

String loginInfoModelToJson(LoginInfoModel data) => json.encode(data.toJson());

class LoginInfoModel {
  String username;
  String password;

  LoginInfoModel({
    required this.username,
    required this.password,
  });

  factory LoginInfoModel.fromJson(Map<String, dynamic> json) => LoginInfoModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
