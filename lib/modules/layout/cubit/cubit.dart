import 'package:gwia/modules/favorate/favorate_screen.dart';
import 'package:gwia/modules/home/home_screen.dart';
import 'package:gwia/modules/layout/cubit/states.dart';
import 'package:gwia/modules/send_messages/send_messages_screen.dart';
import 'package:gwia/modules/settings/settings_screen.dart';
import 'package:gwia/shared/local/cache_helper.dart';
import 'package:gwia/shared/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int bottomNavigationBarIndex = 0;

  List<Map<String, IconData>> bottomNavigationBarItems = [
    {"الرسائل": Icons.markunread},
    {"المفضلة": Icons.favorite_border},
    {"المرسلة": Icons.reply_all},
    {"الاعدادات": Icons.settings},
  ];

  List<Widget> screens = [
    HomeScreen(),
    FavoriteScreen(),
    SendMessagesScreen(),
    SettingsScreen(),
  ];

  void changeBottomNavigationBarIndex(int index) {
    bottomNavigationBarIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }

  void toggleIsDarkMode(bool val) {
    CacheHelper.setBool(key: "isDarkMode", value: val);
    MyThemes.isDarkTheme = val;
    emit(LayoutChangeIsDarkModeState());
  }
}
