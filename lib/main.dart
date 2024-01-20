import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:realtime_chatapp/app/controller/theme.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(
    Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Get.put(ThemeController()).themeData.value,
          title: "Realtime Chat App",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        )),
  );
}
