// To parse this JSON data, do
//
//     final voca = vocaFromJson(jsonString);

import 'dart:convert';

List<Voca> vocaFromJson(String str) =>
    List<Voca>.from(json.decode(str).map((x) => Voca.fromJson(x)));

String vocaToJson(List<Voca> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Voca {
  int vocaId;
  String vocaKr;
  String vocaCn;
  String? vocaExp;
  bool vocaMemo;
  int chapterId;
  String vocaHanzi;

  Voca({
    required this.vocaId,
    required this.vocaKr,
    required this.vocaCn,
    this.vocaExp,
    required this.vocaMemo,
    required this.chapterId,
    required this.vocaHanzi,
  });

  factory Voca.fromJson(Map<String, dynamic> json) => Voca(
        vocaId: json["vocaId"],
        vocaKr: json["vocaKr"],
        vocaCn: json["vocaCn"],
        vocaExp: json["vocaExp"],
        vocaMemo: json["vocaMemo"],
        chapterId: json["chapterId"],
        vocaHanzi: json["vocaHanzi"],
      );

  Map<String, dynamic> toJson() => {
        "vocaId": vocaId,
        "vocaKr": vocaKr,
        "vocaCn": vocaCn,
        "vocaExp": vocaExp,
        "vocaMemo": vocaMemo,
        "chapterId": chapterId,
        "vocaHanzi": vocaHanzi,
      };
}
