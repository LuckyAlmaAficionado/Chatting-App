import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController extends GetxController {
  var themeData = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.outfitTextTheme(),
  ).obs;
  var isDark = false.obs;

  changeThemeData() {
    if (themeData.value.brightness == Brightness.light) {
      themeData.value = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        textTheme: GoogleFonts.outfitTextTheme(TextTheme()),
      );
    } else {
      themeData.value = ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.outfitTextTheme(),
      );
    }
    isDark.value = !isDark.value;
  }
}
