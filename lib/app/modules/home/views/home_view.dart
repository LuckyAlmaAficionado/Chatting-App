import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chatapp/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
        centerTitle: true,
        actions: [
          Obx(
            () => CupertinoSwitch(
              activeColor: Colors.grey,
              value: controller.themeController.value.isDark.value,
              onChanged: (value) {
                controller.themeController.value.changeThemeData();
              },
            ),
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Obx(() => ListView.builder(
              itemCount: controller.accountList.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => Get.toNamed(
                  Routes.DETAIL_CHAT,
                  arguments: controller.accountList[index].uid,
                ),
                title: Text(
                  controller.accountList[index].userName,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'tidak ada pesan',
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(DateFormat('HH:MM').format(DateTime.now())),
                leading: CircleAvatar(),
              ),
            )),
      ),
    );
  }
}
