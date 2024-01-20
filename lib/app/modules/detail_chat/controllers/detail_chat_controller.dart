import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realtime_chatapp/app/model/message.dart';

class DetailChatController extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref('messages');
  final auth = FirebaseAuth.instance.currentUser!;
  createNewChat() async {
    try {
      final databaseChat = FirebaseDatabase.instance.ref('UserChats');
      final chatMessage = FirebaseDatabase.instance.ref('chatMessages');

      final chatMessageKey = await chatMessage.push();

      await chatMessage.child(chatMessageKey.key!).push().set({
        "message": "Hi there!",
        "messageDate": "10/10/2019",
        "messageTime": "10:16pm",
        "sentBy": FirebaseAuth.instance.currentUser!.uid,
        "timeStamp": DateTime.now().toString(),
      });
      // create new chat
      await databaseChat.push().set({
        '0': Get.arguments,
        '1': FirebaseAuth.instance.currentUser!.uid,
        'chatUid': chatMessageKey.key,
      });
      // test
    } catch (e) {
      throw (e);
    }
  }

  inputDatabase(String uid, String message) async {
    try {
      final refMessage =
          FirebaseDatabase.instance.ref('chatMessages').child(keyChat.value);
      await refMessage.push().set({
        "message": message,
        "messageDate":
            DateFormat('dd/MMMM/YYYY').format(DateTime.now()).toString(),
        "messageTime": DateFormat('HH:MM').format(DateTime.now()).toString(),
        "sentBy": FirebaseAuth.instance.currentUser!.uid,
        "timeStamp": DateTime.now().toString(),
      });

      // await newRecordRef.set({});
      fetchChat();
      chatController.text = '';
    } on FirebaseException catch (e) {
      throw ('error $e');
    }
  }

  var chatList = <Message>[].obs;

  // DATA
  var keyChat = ''.obs;
  late TextEditingController chatController;

  findUserChats() async {
    final ref = FirebaseDatabase.instance.ref('UserChats');
    try {
      for (int i = 0; i <= 1; i++) {
        final snapshot = await ref
            .orderByChild(i.toString())
            .equalTo(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (snapshot.exists) {
          var data = snapshot.value as Map<dynamic, dynamic>;
          data.forEach((key, value) {
            if (value['0'] == Get.arguments && value['1'] == auth.uid)
              keyChat.value = value['chatUid'];
            if (value['1'] == Get.arguments && value['0'] == auth.uid)
              keyChat.value = value['chatUid'];
          });
        } else {}
        fetchChat();
      }
      if (keyChat.value == '') createNewChat();
    } catch (e) {
      throw e;
    }
  }

  fetchChat() async {
    chatList.clear();
    final ref =
        FirebaseDatabase.instance.ref('chatMessages').child(keyChat.value);
    try {
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        chatList.addAll(data.values.map<Message>((value) {
          return Message(
            sentBy: value['sentBy'],
            text: value['message'],
            time: value['messageTime'],
            timestamp: value['timeStamp'],
          );
        }));
      } else {
        print('no data');
      }

      sortingChatList();
    } catch (e) {}
  }

  sortingChatList() {
    chatList.sort((a, b) =>
        DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    chatController = TextEditingController();
    // createNewChat();
    findUserChats();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    chatController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
