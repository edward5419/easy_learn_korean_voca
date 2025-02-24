// To parse this JSON data, do
//
//     final accountInfoModel = accountInfoModelFromJson(jsonString);

import 'dart:convert';

AccountInfoModel accountInfoModelFromJson(String str) =>
    AccountInfoModel.fromJson(json.decode(str));

String accountInfoModelToJson(AccountInfoModel data) =>
    json.encode(data.toJson());

class AccountInfoModel {
  String sessionKey;
  String userId;
  String email;
  bool isValid;

  AccountInfoModel({
    required this.sessionKey,
    required this.userId,
    required this.email,
    required this.isValid,
  });

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) =>
      AccountInfoModel(
        sessionKey: json["sessionKey"],
        userId: json["userId"],
        email: json["email"],
        isValid: json["isValid"],
      );

  Map<String, dynamic> toJson() => {
        "sessionKey": sessionKey,
        "userId": userId,
        "email": email,
        "isValid": isValid,
      };
}
