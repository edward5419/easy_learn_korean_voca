import 'package:balibali/controller/voca_list_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chapter_group_list_cont.dart';
import '../model/chapter_group_model.dart';

// ignore: must_be_immutable
class ChapterGroupList extends StatefulWidget {
  const ChapterGroupList({Key? key}) : super(key: key);

  @override
  State<ChapterGroupList> createState() => _ChapterGroupListState();
}

class _ChapterGroupListState extends State<ChapterGroupList> {
  ChapterGroupListCont chapterListCont = Get.put(ChapterGroupListCont());
  var chapterGroupListCopy = <ChapterGroup>[];
  VocaListCont vocaListCont = Get.put(VocaListCont());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '选择你要学习的目录',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                chapterListCont.updateChapterGroupMemo(chapterGroupListCopy);
                Get.back();
              },
              child: const Text('保存'),
            ),
          ]),
      body: Obx(() => isLoading()),
    );
  }

  Widget isLoading() {
    if (chapterListCont.chapterGroupList.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return chapterListBody();
    }
  }

  ListView chapterListBody() {
    chapterGroupListCopy = List.from(chapterListCont.chapterGroupList);

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: chapterGroupListCopy.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(thickness: 2),
      itemBuilder: (_, int index) {
        final chapterGroup = chapterGroupListCopy[index];
        final isLearing = chapterGroup.isLearning;

        return ListTile(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          onLongPress: () {},
          trailing: Checkbox(
            value: isLearing,
            onChanged: (value) {
              setState(() {
                chapterGroup.isLearning = value!;
              });
              chapterGroupListCopy[index].isLearning = chapterGroup.isLearning;
            },
          ),
          title: Text(
            chapterGroup.chapterGroupName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}
