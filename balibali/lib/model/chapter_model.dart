// To parse this JSON data, do
//
//     final chapter = chapterFromJson(jsonString);

import 'dart:convert';

List<Chapter> chapterFromJson(String str) =>
    List<Chapter>.from(json.decode(str).map((x) => Chapter.fromJson(x)));

String chapterToJson(List<Chapter> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chapter {
  int chapterId;
  String chapterTopic;
  String chapterGroup;
  String memoDate1;
  String memoDate2;
  String memoDate3;
  String memoDate4;
  int chapterMemoNum;

  Chapter({
    required this.chapterId,
    required this.chapterTopic,
    required this.chapterGroup,
    required this.memoDate1,
    required this.memoDate2,
    required this.memoDate3,
    required this.memoDate4,
    required this.chapterMemoNum,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapterId: json["chapterId"],
        chapterTopic: json["chapterTopic"],
        chapterGroup: json["chapterGroup"],
        memoDate1: json["memoDate1"],
        memoDate2: json["memoDate2"],
        memoDate3: json["memoDate3"],
        memoDate4: json["memoDate4"],
        chapterMemoNum: json["chapterMemoNum"],
      );

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "chapterTopic": chapterTopic,
        "chapterGroup": chapterGroup,
        "memoDate1": memoDate1,
        "memoDate2": memoDate2,
        "memoDate3": memoDate3,
        "memoDate4": memoDate4,
        "chapterMemoNum": chapterMemoNum,
      };
}
