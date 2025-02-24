import 'package:balibali/controller/account_info_cont.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomepageDrawer extends StatelessWidget {
  HomepageDrawer({super.key});
  final _selectedIndex = 0;
  final AccountInfoCont accountInfoCont = Get.put(AccountInfoCont());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(245, 245, 220, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(accountInfoCont.accountInfo[0].userId,
                        style: Theme.of(context).textTheme.labelLarge),
                    Expanded(child: Container()),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 30,
                      ),
                      color: Colors.brown,
                      onPressed: () {
                        Navigator.pop(context);
                        // 버튼 클릭 시 수행할 동작
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(accountInfoCont.accountInfo[0].email,
                      style: Theme.of(context).textTheme.labelMedium),
                ),
                ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: '正在保存记录...');
                    await accountInfoCont.clearAutoLogin();
                    Get.offAllNamed('/login');

                    EasyLoading.dismiss();
                  },
                  child: const Text('注销'),
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              '开发者:浙江大学金铉洙',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              '和高艳丹老师',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            selected: _selectedIndex == 1,
            onTap: () {
              // Update the state of the app

              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              '请等待更新',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            selected: _selectedIndex == 2,
            onTap: () {
              // Update the state of the app

              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
