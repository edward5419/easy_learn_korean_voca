// ignore_for_file: must_be_immutable

import 'package:balibali/controller/account_info_cont.dart';
import 'package:balibali/pages/homepage_material/homepage_recent_study_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:balibali/widgets/task_group.dart';
import './homepage_material/homepage_drawer.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  AccountInfoCont accountInfoCont = Get.put(AccountInfoCont());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomepageDrawer(),
      body: _buildBody(),
      appBar: AppBar(
          elevation: 2,
          title: Obx(() => Text('你好!  ${accountInfoCont.accountInfo[0].userId}',
              style: Theme.of(context).textTheme.titleLarge)),
          actions: const []),
    );
  }

  Stack _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [buildGrid()],
              )),
        )
      ],
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1.2,
            child: RecentStudyRecord()),
        const StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.2,
          child: GridContainer(
            color: Colors.white,
            icon: Icons.menu_book_rounded,
            taskCount: ' ',
            taskGroup: "去学习",
            page: "/chapterList",
          ),
        ),
        const StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.2,
          child: GridContainer(
            color: Colors.white,
            icon: Icons.mobile_friendly,
            taskCount: ' ',
            taskGroup: "词汇表",
            page: "/chapterGroupList",
          ),
        ),
      ],
    );
  }
}
