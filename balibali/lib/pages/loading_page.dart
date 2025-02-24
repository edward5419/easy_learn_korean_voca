// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../controller/account_info_cont.dart';
import 'package:get/get.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});
  AccountInfoCont accountinfoCont = Get.put(AccountInfoCont());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (accountinfoCont.accountInfo.isEmpty) {
        return Scaffold(
          body: Container(),
        );
      } else if (accountinfoCont.accountInfo[0].isValid) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offNamed('/homepage');
        });

        return Scaffold(
          body: Container(),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offNamed('/login');
        });

        return Scaffold(
          body: Container(),
        );
      }
    });
  }
}
