import 'dart:async';

import 'package:balibali/controller/current_study_cont.dart';
import 'package:balibali/controller/voca_list_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chapter_list_cont.dart';
import 'voca_list_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class ChapterList extends StatefulWidget {
  const ChapterList({Key? key}) : super(key: key);

  @override
  State<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  bool showErrorMessage = false;
  @override
  void initState() {
    super.initState();
    // 5초 후에 setState를 호출하여 showErrorMessage를 true로 변경합니다.
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        // 위젯이 마운트된 상태인지 확인
        setState(() {
          showErrorMessage = true;
        });
      }
    });
  }

  final ChapterListCont chapterListCont = Get.put(ChapterListCont());

  final VocaListCont vocaListCont = Get.put(VocaListCont());

  final CurrentStudyCont currentStudyCont = Get.put(CurrentStudyCont());

  final List<bool> checkBoxValues = [true, true, true];

  bool isActivate(String date1, String date2, String date3, int num) {
    if (num == 0) {
      return true;
    } else if (num == 1) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(date1);
      DateTime now = DateTime.now();
      DateTime oneDayAgo = now.subtract(const Duration(days: 1));
      if (date.isBefore(oneDayAgo)) {
        return true;
      } else {
        return false;
      }
    } else if (num == 2) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(date2);
      DateTime now = DateTime.now();
      DateTime oneWeekAgo = now.subtract(const Duration(days: 7));
      if (date.isBefore(oneWeekAgo)) {
        return true;
      } else {
        return false;
      }
    } else if (num == 3) {
      DateTime date = DateFormat('yyyy-MM-dd').parse(date3);
      DateTime now = DateTime.now();
      DateTime oneMonthAgo = now.subtract(const Duration(days: 30));
      if (date.isBefore(oneMonthAgo)) {
        return true;
      } else {
        return false;
      }
    } else {
      //복습 완료시
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('章目录', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Obx(() => isLoading()),
    );
  }

  Widget isLoading() {
    if (chapterListCont.chapterList.isEmpty && !showErrorMessage) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (chapterListCont.chapterList.isEmpty && showErrorMessage) {
      return const Center(
        child: Text("没有关注的章目录活有网络问题"),
      );
    } else {
      return chapterListBody();
    }
  }

  ListView chapterListBody() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: chapterListCont.chapterList.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(thickness: 2),
      itemBuilder: (_, int index) {
        final chapter = chapterListCont.chapterList[index];

        bool needToReview = isActivate(chapter.memoDate1, chapter.memoDate2,
            chapter.memoDate3, chapter.chapterMemoNum);

        return ListTile(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          onTap: () async {
            needToReview ? await moveToVocaList(index) : () {};
          },
          onLongPress: () {},
          title: Row(
            children: [
              Column(children: [
                Text(chapter.chapterTopic,
                    style: TextStyle(
                        color: needToReview ? Colors.black : Colors.grey)),
                Text(
                  '(${chapter.chapterGroup})',
                  style: TextStyle(
                      color: needToReview ? Colors.black : Colors.grey,
                      fontSize: 10),
                )
              ]),

              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 30,
                child: Checkbox(
                  side: BorderSide(
                      color: needToReview ? Colors.black : Colors.grey,
                      width: 2),
                  activeColor: needToReview ? Colors.red : Colors.grey,
                  value: chapter.chapterMemoNum >= 1,
                  onChanged: (bool? value) {},
                ),
              ),
              // 체크박스 사이의 간격을 조절하는 Padding 추가
              SizedBox(
                width: 30,
                child: Checkbox(
                  side: BorderSide(
                      color: needToReview ? Colors.black : Colors.grey,
                      width: 2),
                  shape: const RoundedRectangleBorder(),
                  activeColor: needToReview ? Colors.orange : Colors.grey,
                  value: chapter.chapterMemoNum >= 2,
                  onChanged: (bool? value) {},
                ),
              ),

              SizedBox(
                height: 5,
                width: 30,
                child: Checkbox(
                  side: BorderSide(
                      color: needToReview ? Colors.black : Colors.grey,
                      width: 2),
                  activeColor: needToReview ? Colors.green : Colors.grey,
                  value: chapter.chapterMemoNum >= 3,
                  onChanged: (bool? value) {},
                ),
              ),
              SizedBox(
                height: 5,
                width: 30,
                child: Checkbox(
                  side: BorderSide(
                      color: needToReview ? Colors.black : Colors.grey,
                      width: 2),
                  activeColor: needToReview ? Colors.green : Colors.grey,
                  value: chapter.chapterMemoNum >= 4,
                  onChanged: (bool? value) {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> moveToVocaList(int index) async {
    EasyLoading.show(status: 'loading...');

    await vocaListCont.fetchData(chapterListCont.chapterList[index].chapterId);
    final vocaListLen = vocaListCont.vocaList.length;
    final vocaListMemoLen = vocaListCont.countVocaMemo();
    currentStudyCont.selectChapter(chapterListCont.chapterList[index]);
    currentStudyCont.saveChapterToLocal(
        chapterListCont.chapterList[index], vocaListLen, vocaListMemoLen);
    currentStudyCont.getProgressData();
    Get.to(() => const VocaList());
    EasyLoading.dismiss();
  }
}
