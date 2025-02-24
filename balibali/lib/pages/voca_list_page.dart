import 'package:balibali/controller/chapter_list_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import '../controller/voca_list_cont.dart';
import '../controller/account_info_cont.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../controller/current_study_cont.dart';
import '../model/voca_model.dart';
import '../widgets/tilecard.dart';

class VocaList extends StatefulWidget {
  const VocaList({super.key});

  @override
  State<VocaList> createState() => _VocaListState();
}

class _VocaListState extends State<VocaList> {
  VocaListCont vocaListCont = Get.put(VocaListCont());
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());
  ChapterListCont chapterListCont = Get.put(ChapterListCont());
  CurrentStudyCont currentStudyCont = Get.put(CurrentStudyCont());
  bool isAllChecked = false;
  bool columnColor1 = true;
  bool columnColor2 = true;
  bool addHanzi = false;
  void toggleColor(color) {
    setState(() {
      color = !color;
    });
  }

  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();
    isExpandedList = List.generate(
      vocaListCont.vocaList.length,
      (index) => false,
    );
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpandedList[index] = !isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => body(context)),
      appBar: AppBar(
          elevation: 0,
          title: Text(
            currentStudyCont.currentStudyChapter[0].chapterTopic,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                EasyLoading.show(status: '正在保存记录...');
                await vocaListCont.sendVocaListToBackend();

                await currentStudyCont.saveChapterToLocal(
                    currentStudyCont.currentStudyChapter[0],
                    vocaListCont.vocaList.length,
                    vocaListCont.countVocaMemo());

                await currentStudyCont.getProgressData();
                Get.back();
                EasyLoading.dismiss();
              },
              child: const Text('保存'),
            ),
            const SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: isAllChecked
                  ? () async {
                      EasyLoading.show(status: 'saving record...');
                      await vocaListCont.everyMemoToZero();
                      await currentStudyCont.uploadChapterRecord();
                      await currentStudyCont.deleteChapterFromLocal();
                      await currentStudyCont.getProgressData();
                      await chapterListCont.recallData(); //제출하고, 챕터리스트 다시 부르기

                      Get.back();
                      EasyLoading.dismiss();
                    }
                  : null,
              style: ButtonStyle(
                backgroundColor: isAllChecked
                    ? MaterialStateProperty.all<Color>(Colors.brown)
                    : MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(
                '学完了!',
                style: TextStyle(
                    color: isAllChecked ? Colors.white : Colors.grey[600]),
              ),
            ),
          ]),
    );
  }

  Column body(BuildContext context) {
    return Column(
      children: [
        //topRow(),
        SizedBox(
          height: 100,
          child: topRow(),
        ),
        Expanded(
          child: vocaRows1(),
        ),
      ],
    );
  }

  ListView vocaRows1() {
    return ListView.separated(
      itemCount: vocaListCont.vocaList.length,
      separatorBuilder: (context, index) => const Divider(
        thickness: 0.5,
        height: 1.0,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: IntrinsicHeight(
          child: TileCard(
            vocaExp: vocaListCont.vocaList[index].vocaExp != null
                ? Text(
                    vocaListCont.vocaList[index].vocaExp!,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : null,
            vocaKr: Text(
              addHanzi == false
                  ? vocaListCont.vocaList[index].vocaKr
                  : vocaListCont.vocaList[index].vocaHanzi,
              style: chooseTextColor(columnColor1,
                  !vocaListCont.vocaList[index].vocaMemo, context),
            ),
            vocaCn: Text(vocaListCont.vocaList[index].vocaCn,
                style: chooseTextColor(columnColor2,
                    !vocaListCont.vocaList[index].vocaMemo, context)),
            isMemorized: vocaListCont.vocaList[index].vocaMemo,
            isExpanded: isExpandedList[index],
            inkWellOnPressed: () {
              setState(() {
                if (vocaListCont.vocaList[index].vocaExp != null) {
                  isExpandedList[index] = !isExpandedList[index];
                  print(isExpandedList[index]);
                }
              });
            },
            checkbox: Checkbox(
              onChanged: (value) {
                setState(() {
                  vocaListCont.editData(index, value);
                  isAllChecked = examAllCheckbox(vocaListCont.vocaList);
                });
              },
              value: vocaListCont.vocaList[index].vocaMemo,
            ),
          ),
        ),
      ),
    );
  }

  ListView vocaRows() {
    return ListView.separated(
      itemCount: vocaListCont.vocaList.length,
      separatorBuilder: (context, index) => const Divider(
        thickness: 1.0,
        height: 1.0,
      ),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              ExpansionTileCard(
                onExpansionChanged: (value) {
                  if (vocaListCont.vocaList[index].vocaExp != null) {
                    setState(() {
                      isExpandedList[index] = value;
                    });
                  }
                },
                trailing: Checkbox(
                  onChanged: (value) {
                    setState(() {
                      vocaListCont.editData(index, value);
                      isAllChecked = examAllCheckbox(vocaListCont.vocaList);
                    });
                  },
                  value: vocaListCont.vocaList[index].vocaMemo,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 10,
                      child: Text(
                        addHanzi
                            ? vocaListCont.vocaList[index].vocaHanzi
                            : vocaListCont.vocaList[index].vocaKr,
                        style: chooseTextColor(columnColor1,
                            !vocaListCont.vocaList[index].vocaMemo, context),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 10,
                      child: Text(
                        vocaListCont.vocaList[index].vocaCn,
                        style: chooseTextColor(columnColor2,
                            !vocaListCont.vocaList[index].vocaMemo, context),
                      ),
                    ),
                  ],
                ),
                children: vocaListCont.vocaList[index].vocaExp == null
                    ? []
                    : <Widget>[
                        const Divider(
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: vocaListCont.vocaList[index].vocaExp == null
                                ? const Text('')
                                : Text(vocaListCont.vocaList[index].vocaExp!),
                          ),
                        ),
                      ],
              ),
              if (vocaListCont.vocaList[index].vocaExp != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: isExpandedList[index]
                      ? const Icon(
                          Icons.expand_less,
                          size: 24,
                        )
                      : const Icon(
                          Icons.expand_more,
                          size: 24,
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Container topRow() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.brown, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 1,
            child: Container(),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 10,
            child: Row(
              children: [
                const Text("韩文"),
                IconButton(
                    onPressed: () {
                      setState(() {
                        columnColor1 = !columnColor1;
                        print(columnColor1);
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: columnColor1 ? Colors.black : Colors.grey,
                    )),
                IconButton(
                  onPressed: () {
                    setState(() {
                      addHanzi = !addHanzi;
                    });
                  },
                  icon: Icon(
                    Icons.type_specimen,
                    color: addHanzi ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 10,
            child: Row(
              children: [
                const Text("中文"),
                IconButton(
                    onPressed: () {
                      setState(() {
                        columnColor2 = !columnColor2;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: columnColor2 ? Colors.black : Colors.grey,
                    ))
              ],
            ),
          ),
          const Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Row(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}

bool examAllCheckbox(List<Voca> vocaList) {
  for (var item in vocaList) {
    if (item.vocaMemo != true) {
      return false;
    }
  }
  return true;
}

TextStyle chooseTextColor(
    bool condition1, bool condition2, BuildContext context) {
  if (condition1 == true && condition2 == true) {
    return Theme.of(context).textTheme.bodySmall!;
  } else {
    return const TextStyle(
      color: Colors.transparent,
    );
  }
}
