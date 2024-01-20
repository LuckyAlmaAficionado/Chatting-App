import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realtime_chatapp/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final ref = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;

  signInWithGoogle() async {
    try {
      if (firebaseAuth.currentUser != null) isLoginAlready();
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // membuat credential baru untuk user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // check apakah akun sudah pernah terdaftar sebelumnya
      if (!await fetchDataAccount()) createNewAccount();

      Get.toNamed(Routes.HOME);
    } catch (e) {
      throw (e);
    }
  }

  fetchDataAccount() async {
    final snapshot = await ref
        .child('account')
        .orderByChild('uid')
        .equalTo(auth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  createNewAccount() async {
    final databaseReference = FirebaseDatabase.instance.ref('account');
    try {
      DatabaseReference newRecordRef = databaseReference.push();
      String? newRecordKey = newRecordRef.key;
      await newRecordRef.set({
        'key': newRecordKey,
        'uid': auth.currentUser!.uid,
        'userName': auth.currentUser!.displayName,
        'userEmail': auth.currentUser!.email,
        'createdAt': DateTime.now().toString(),
      });
    } on FirebaseAuthException catch (error) {
      throw ('Error $error');
    }
  }

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  isLoginAlready() {
    if (firebaseAuth.currentUser != null) Get.toNamed(Routes.HOME);
  }

  @override
  void onInit() {
    super.onInit();
    isLoginAlready();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
