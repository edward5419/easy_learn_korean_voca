// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:balibali/controller/current_study_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/voca_list_cont.dart';
import '../voca_list_page.dart';

class RecentStudyRecord extends StatelessWidget {
  RecentStudyRecord({Key? key}) : super(key: key);

  final VocaListCont vocaListCont = Get.put(VocaListCont());
  final CurrentStudyCont currentStudyCont = Get.put(CurrentStudyCont());

  Future<void> moveToVocaList() async {
    EasyLoading.show(status: 'loading...');
    final chapter = await currentStudyCont.getChapterFromLocal();
    currentStudyCont.selectChapter(chapter);
    await currentStudyCont.getProgressData();

    final chapterId = chapter.chapterId;
    print(chapterId);
    await vocaListCont.fetchData(chapterId);
    Get.to(() => const VocaList());
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(245, 245, 220, 1),
      elevation: 2,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () async {
          await moveToVocaList();
        },
        onLongPress: () {},
        child: GetX<CurrentStudyCont>(
          builder: (controller) {
            final progressData = controller.progressData;
            if (progressData['isLearning'] == null) {
              return const CircularProgressIndicator();
            } else if (progressData['isLearning'] == false) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('现在没有学习的章节！',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              );
            } else {
              final int vocaListMemoLen = progressData['vocaListMemoLen'];
              final int vocaListLen = progressData['vocaListLen'];
              final double percentage =
                  vocaListMemoLen.toDouble() / vocaListLen.toDouble();
              return LayoutBuilder(builder: (context, constraints) {
                return GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '在学习的章节 : ' + progressData['chapterTopic'],
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$vocaListMemoLen/$vocaListLen',
                              style: GoogleFonts.lato(
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: LinearPercentIndicator(
                            width: constraints.maxWidth - 50,
                            animation: true,
                            lineHeight: 10.0,
                            animationDuration: 2500,
                            percent: percentage,
                            barRadius: const Radius.circular(16),
                            progressColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text('点击学习→',
                                    style: GoogleFonts.lato(
                                      textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
            }
          },
        ),
      ),
    );
  }
}
