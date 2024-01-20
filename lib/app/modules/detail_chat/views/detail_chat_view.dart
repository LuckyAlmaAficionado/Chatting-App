import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:realtime_chatapp/app/controller/theme.dart';

import '../controllers/detail_chat_controller.dart';

class DetailChatView extends GetView<DetailChatController> {
  const DetailChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(DetailChatController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -10,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lucky Alma Aficionado Rigel',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'online',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            )
          ],
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.phone),
          const Gap(10),
          Icon(Icons.more_vert),
          const Gap(10),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Obx(() => SizedBox(
                    width: Get.width,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: controller.chatList
                            .asMap()
                            .entries
                            .map((e) => Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.all(10),
                                  alignment: (e.value.sentBy ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    width: Get.width * 0.8,
                                    alignment: (e.value.sentBy ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid)
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: HexColor('#dcf8c6'),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${e.value.text}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Gap(3),
                                          Text(
                                            '${e.value.time}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  )),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                children: [
                  new Flexible(
                    child: Obx(() => TextField(
                          controller: controller.chatController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            filled: true,
                            fillColor: (Get.put(ThemeController()).isDark.value)
                                ? Colors.grey.shade900
                                : Colors.grey.shade300,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        )),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () => controller.inputDatabase(
                      FirebaseAuth.instance.currentUser!.uid,
                      controller.chatController.text,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: HexColor('#25d366'),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
