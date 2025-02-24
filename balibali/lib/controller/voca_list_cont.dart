import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/url.dart';
import '../model/voca_model.dart';
import 'account_info_cont.dart';
import './current_study_cont.dart';

class VocaListCont extends GetxController {
  final vocaList = <Voca>[].obs;
  final CurrentStudyCont currentStudyCont = Get.put(CurrentStudyCont());
  static final url = Uri.parse("${UrlmetaData.url}/balibaliapp/studylist");
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> fetchData(int chapterId) async {
    final List<Voca> voca;
    final sessionKey = accountinfoCont.accountInfo[0].sessionKey;

    try {
      final response = await http.post(url,
          headers: {'sessionKey': sessionKey},
          body: {'chapterId': chapterId.toString()});
      if (response.statusCode == 200) {
        // print(response.body);
        voca = vocaFromJson(response.body);
        vocaList.assignAll(voca);
        //fetchRecentChapterData();
      }
    } catch (e) {
      if (kDebugMode) print(e);
      if (kDebugMode) {
        print("데이터 불러오기실패");
      }
    }
  }

  void editData(index, vocaMemo) {
    vocaList[index].vocaMemo = vocaMemo;
  }

  Future<void> sendVocaListToBackend() async {
    final url = Uri.parse("${UrlmetaData.url}/balibaliapp/updateVocaMemo");
    final sessionKey = accountinfoCont.accountInfo[0].sessionKey;

    try {
      final response = await http.post(
        url,
        headers: {'sessionKey': sessionKey},
        body: vocaToJson(vocaList),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print('Data sent to backend successfully');
      } else {
        if (kDebugMode) {
          print(
              'Failed to send data to backend. Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error sending data to backend: $e');
    }
  }

  Future<void> everyMemoToZero() async {
    final url = Uri.parse("${UrlmetaData.url}/balibaliapp/updateVocaMemo");
    final sessionKey = accountinfoCont.accountInfo[0].sessionKey;
    for (var voca in vocaList) {
      voca.vocaMemo = false;
    }
    try {
      final response = await http.post(
        url,
        headers: {'sessionKey': sessionKey},
        body: vocaToJson(vocaList),
      );
      //공부 완료시 현재 공부중인 챕터 없음
      _secureStorage.delete(key: 'recentChapterId');
      _secureStorage.delete(key: 'recentChapterTopic');
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Data sent to backend successfully');
        }
      } else {
        if (kDebugMode) {
          print(
              'Failed to send data to backend. Error: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error sending data to backend: $e');
    }
  }

  int countVocaMemo() {
    int count = 0;
    for (var item in vocaList) {
      if (item.vocaMemo == true) {
        count++;
      }
    }
    return count;
  }
}
