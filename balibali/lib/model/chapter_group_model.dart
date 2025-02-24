// To parse this JSON data, do
//
//     final chapterGroup = chapterGroupFromJson(jsonString);

import 'dart:convert';

List<ChapterGroup> chapterGroupFromJson(String str) => List<ChapterGroup>.from(
    json.decode(str).map((x) => ChapterGroup.fromJson(x)));

String chapterGroupToJson(List<ChapterGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChapterGroup {
  String chapterGroupName;
  bool isLearning;

  ChapterGroup({
    required this.chapterGroupName,
    required this.isLearning,
  });

  factory ChapterGroup.fromJson(Map<String, dynamic> json) => ChapterGroup(
        chapterGroupName: json["chapterGroupName"],
        isLearning: json["isLearning"],
      );

  Map<String, dynamic> toJson() => {
        "chapterGroupName": chapterGroupName,
        "isLearning": isLearning,
      };
}
