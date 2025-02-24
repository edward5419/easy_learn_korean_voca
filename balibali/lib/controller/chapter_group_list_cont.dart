import 'package:balibali/controller/account_info_cont.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import '../model/url.dart';
import '../model/chapter_group_model.dart';

class ChapterGroupListCont extends GetxController {
  final chapterGroupList = <ChapterGroup>[].obs;
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());

  static final urlGet =
      Uri.parse("${UrlmetaData.url}/balibaliapp/chapterGroup");
  static final urlPost =
      Uri.parse("${UrlmetaData.url}/balibaliapp/chapterGroupUpload");
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    final List<ChapterGroup> chapterGroups;
    if (kDebugMode) {
      print("${UrlmetaData.url}/balibaliapp/chapterGroup");
    }
    try {
      final sessionKey = accountinfoCont.accountInfo[0].sessionKey;
      final response = await http.post(urlGet,
          headers: {'sessionKey': sessionKey},
          body: chapterGroupToJson(chapterGroupList));
      if (kDebugMode) print(response.body);
      if (response.statusCode == 200) {
        chapterGroups = chapterGroupFromJson(response.body);

        chapterGroupList.assignAll(chapterGroups);
      }
    } catch (e) {
      if (kDebugMode) {
        print("데이터 불러오기실패");
        print(e);
      }
    }
  }

  void updateChapterGroupMemo(List<ChapterGroup> value) async {
    try {
      chapterGroupList.assignAll(value);
      final sessionKey = accountinfoCont.accountInfo[0].sessionKey;

      final response = await http.post(urlPost,
          headers: {'sessionKey': sessionKey},
          body: chapterGroupToJson(chapterGroupList)); // JSON 문자열로 직렬화
      if (kDebugMode) print(response);
      if (response.statusCode == 200) {}
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
