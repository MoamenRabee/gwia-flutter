import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwia/shared/themes/colors.dart';

import '../local/cache_helper.dart';

class MyThemes {
  static bool isDarkTheme = CacheHelper.getBool(key: "isDarkMode");

  static ThemeData get lightTheme {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.grey,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 1,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
      fontFamily: "Cairo",
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: MyColors.darkColor,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: "Cairo",
        ),
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      scaffoldBackgroundColor: MyColors.darkColor,
      primarySwatch: Colors.grey,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      fontFamily: "Cairo",
    );
  }
}
