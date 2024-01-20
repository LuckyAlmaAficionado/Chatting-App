import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:realtime_chatapp/app/controller/theme.dart';
import 'package:realtime_chatapp/app/model/account.dart';

class HomeController extends GetxController {
  final themeController = Get.put(ThemeController()).obs;
  final ref = FirebaseDatabase.instance.ref();
  var accountList = <Account>[].obs;

  fetchAccountEnable() async {
    final snapshot = await ref.child('account').get();
    if (snapshot.exists) {
      var data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        if (value['uid'] != FirebaseAuth.instance.currentUser!.uid) {
          accountList.add(
            Account(
                key: value['key'],
                uid: value['uid'],
                userName: value['userName'],
                userEmail: value['userEmail'],
                createdAt: value['createdAt']),
          );
        }
      });

      accountList.refresh();
    } else {
      print('tidak ada data');
    }
    return 3;
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAccountEnable();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
