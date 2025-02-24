// To parse this JSON data, do
//
//     final reqVocaList = reqVocaListFromJson(jsonString);

import 'dart:convert';

ReqVocaList reqVocaListFromJson(String str) =>
    ReqVocaList.fromJson(json.decode(str));

String reqVocaListToJson(ReqVocaList data) => json.encode(data.toJson());

class ReqVocaList {
  String sessionKey;
  String chapterTitle;

  ReqVocaList({
    required this.sessionKey,
    required this.chapterTitle,
  });

  factory ReqVocaList.fromJson(Map<String, dynamic> json) => ReqVocaList(
        sessionKey: json["sessionKey"],
        chapterTitle: json["chapterTitle"],
      );

  Map<String, dynamic> toJson() => {
        "sessionKey": sessionKey,
        "chapterTitle": chapterTitle,
      };
}
