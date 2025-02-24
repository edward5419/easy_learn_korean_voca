import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../model/chapter_model.dart';
import 'package:http/http.dart' as http;
import '../model/url.dart';
import './account_info_cont.dart';

class ChapterListCont extends GetxController {
  final chapterList = <Chapter>[].obs;
  static final url = Uri.parse("${UrlmetaData.url}/balibaliapp/chapter");

  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    final List<Chapter> chapter;
    try {
      final sessionKey = accountinfoCont.accountInfo[0].sessionKey;
      final response =
          await http.post(url, headers: {'sessionKey': sessionKey});
      if (response.statusCode == 200) {
        chapter = chapterFromJson(response.body);
        chapterList.assignAll(chapter);
      }

      if (kDebugMode) {
        print(chapterList[3].chapterMemoNum);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("데이터 불러오기실패");
      }
    }
  }

  Future<void> recallData() async {
    if (kDebugMode) print('리콜');
    final List<Chapter> chapter;

    final sessionKey = accountinfoCont.accountInfo[0].sessionKey;
    final response = await http.post(url, headers: {'sessionKey': sessionKey});
    if (response.statusCode == 200) {
      chapter = chapterFromJson(response.body);
      chapterList.assignAll(chapter);
    }

    if (kDebugMode) {
      print(chapterList[3].chapterMemoNum);
    }
  }
}
