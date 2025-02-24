import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../model/chapter_model.dart';
import 'package:http/http.dart' as http;
import '../model/url.dart';
import './account_info_cont.dart';
import 'package:intl/intl.dart';

class CurrentStudyCont extends GetxController {
  final currentStudyChapter = <Chapter>[].obs;
  final RxMap progressData = {}.obs;
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static final uploadUrl =
      Uri.parse("${UrlmetaData.url}/balibaliapp/updateChapterMemo");

  @override
  void onInit() {
    super.onInit();
    getProgressData();
  }

  void fetchData() async {}

  void selectChapter(Chapter chapter) {
    currentStudyChapter.assign(chapter);
  }

  Future<void> uploadChapterRecord() async {
    final sessionKey = accountinfoCont.accountInfo[0].sessionKey;
    final chapterMemoNum = currentStudyChapter[0].chapterMemoNum;
    final chapterId = currentStudyChapter[0].chapterId;
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _secureStorage.write(key: 'chapterId', value: chapterId.toString());
    final chapter = {
      "chapterMemoNum": (chapterMemoNum + 1).toString(),
      "chapterId": (chapterId).toString(),
      "nowDate": date
    };

    try {
      final response = await http.post(uploadUrl,
          headers: {'sessionKey': sessionKey}, body: chapter);
      if (kDebugMode) print(response.body);
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print("데이터 보내기 실패");
      }
    }
  }

  int getCrtChapterIndex(List<Chapter> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].chapterId == currentStudyChapter[0].chapterId) {
        return i;
      }
    }
    return -1; // 데이터가 없을 경우 -1 반환
  }

  Future<void> saveChapterToLocal(
      //progressdata 실행 전
      Chapter chapter,
      int vocaListLen,
      int vocaListMemoLen) async {
    _secureStorage.write(key: 'chapterId', value: chapter.chapterId.toString());
    _secureStorage.write(
        key: 'chapterTopic', value: chapter.chapterTopic.toString());
    _secureStorage.write(
        key: 'chapterGroup', value: chapter.chapterGroup.toString());
    _secureStorage.write(key: 'memoDate1', value: chapter.memoDate1.toString());
    _secureStorage.write(key: 'memoDate2', value: chapter.memoDate2.toString());
    _secureStorage.write(key: 'memoDate3', value: chapter.memoDate3.toString());
    _secureStorage.write(key: 'memoDate4', value: chapter.memoDate4.toString());
    _secureStorage.write(
        key: 'chapterMemoNum', value: chapter.chapterMemoNum.toString());
    _secureStorage.write(key: 'vocaListLen', value: vocaListLen.toString());
    _secureStorage.write(
        key: 'vocaListMemoLen', value: vocaListMemoLen.toString());
  }

  Future<void> deleteChapterFromLocal() async {
    _secureStorage.delete(key: 'chapterId');
    _secureStorage.delete(key: 'chapterTopic');
    _secureStorage.delete(key: 'chapterGroup');
    _secureStorage.delete(key: 'memoDate1');
    _secureStorage.delete(key: 'memoData2');
    _secureStorage.delete(key: 'memoDate3');
    _secureStorage.delete(key: 'memoDate4');
    _secureStorage.delete(key: 'chapterMemoNum');
    _secureStorage.delete(key: 'vocaListLen');
    _secureStorage.delete(key: 'vocaListMemoLen');
  }

  Future<Chapter> getChapterFromLocal() async {
    final chapterId = await _secureStorage.read(key: 'chapterId');
    final chapterTopic = await _secureStorage.read(key: 'chapterTopic');
    final chapterGroup = await _secureStorage.read(key: 'chapterGroup');
    final memoDate1 = await _secureStorage.read(key: 'memoDate1');
    final memoDate2 = await _secureStorage.read(key: 'memoDate2');
    final memoDate3 = await _secureStorage.read(key: 'memoDate3');
    final memoDate4 = await _secureStorage.read(key: 'memoDate4');
    final chapterMemoNum = await _secureStorage.read(key: 'chapterMemoNum');

    if (chapterId == null) {
      final chapter = Chapter(
        chapterId: 0,
        chapterTopic: 'none',
        chapterGroup: 'none',
        memoDate1: 'none',
        memoDate2: 'none',
        memoDate3: 'none',
        memoDate4: 'none',
        chapterMemoNum: 0,
      );

      return chapter;
    } else {
      final chapter = Chapter(
        chapterId: int.parse(chapterId),
        chapterTopic: chapterTopic!,
        chapterGroup: chapterGroup!,
        memoDate1: memoDate1!,
        memoDate2: memoDate2!,
        memoDate3: memoDate3!,
        memoDate4: memoDate4!,
        chapterMemoNum: int.parse(chapterMemoNum!),
      );

      return chapter;
    }
  }

  Future<void> getProgressData() async {
    try {
      final stringChapterId = await _secureStorage.read(key: 'chapterId');
      if (stringChapterId == null) {
        progressData.value = {'isLearning': false};
      } else {
        final chapterTopic = await _secureStorage.read(key: 'chapterTopic');
        final chapterGroup = await _secureStorage.read(key: 'chapterGroup');
        final vocaListLen = await _secureStorage.read(key: 'vocaListLen');
        final vocaListMemoLen =
            await _secureStorage.read(key: 'vocaListMemoLen');
        if (chapterTopic != null &&
            chapterGroup != null &&
            vocaListLen != null &&
            vocaListMemoLen != null) {
          progressData.value = {
            'isLearning': true,
            'chapterTopic': chapterTopic,
            'chapterGroup': chapterGroup,
            'vocaListLen': int.parse(vocaListLen),
            'vocaListMemoLen': int.parse(vocaListMemoLen)
          };
        } else {
          progressData.value = {'isLearning': false};
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('에러 발생: $e');
      }
    }
  }
}
