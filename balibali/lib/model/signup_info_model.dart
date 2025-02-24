// To parse this JSON data, do
//
//     final signUpInfoModel = signUpInfoModelFromJson(jsonString);

import 'dart:convert';

SignUpInfoModel signUpInfoModelFromJson(String str) =>
    SignUpInfoModel.fromJson(json.decode(str));

String signUpInfoModelToJson(SignUpInfoModel data) =>
    json.encode(data.toJson());

class SignUpInfoModel {
  String username;
  String email;
  String password;

  SignUpInfoModel({
    required this.username,
    required this.email,
    required this.password,
  });

  factory SignUpInfoModel.fromJson(Map<String, dynamic> json) =>
      SignUpInfoModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
      };
}
