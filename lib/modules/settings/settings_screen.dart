import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/functions/functions.dart';
import 'package:gwia/modules/auth/choice_avatar_screen.dart';
import 'package:gwia/modules/layout/cubit/cubit.dart';
import 'package:gwia/modules/layout/cubit/states.dart';
import 'package:gwia/services/services.dart';
import 'package:gwia/shared/local/cache_helper.dart';

import '../../shared/themes/colors.dart';
import '../../shared/themes/themes.dart';
import '../../shared/widgets/widgets.dart';
import '../auth/cubit/cubit.dart';
import '../auth/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.get(context);

    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                        "assets/images/${CacheHelper.getString(key: "avatarName")}.png"),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          customText(
                              text: "${CacheHelper.getString(key: "code")}",
                              size: 30),
                          SizedBox(
                            width: 10.0,
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: CacheHelper.getString(key: "code"),
                                ),
                              );
                              showToast(
                                msg: "تم نسخ الكود",
                                color: Colors.blue,
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: MyThemes.isDarkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      customText(
                        text: "${CacheHelper.getString(key: "username")}",
                        color: Colors.grey,
                        size: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: DioHelper.url +
                        "message/" +
                        CacheHelper.getString(key: "username"),
                  ),
                );
                showToast(
                  msg: "تم نسخ الرابط",
                  color: Colors.blue,
                );
              },
              title: Text(
                "نسخ رابط الويب",
                style: TextStyle(
                  color: MyThemes.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            SwitchListTile(
              value: MyThemes.isDarkTheme,
              onChanged: (val) {
                cubit.toggleIsDarkMode(val);
              },
              title: customText(text: "الوضع المظلم"),
              activeColor: Colors.white,
              activeTrackColor: Colors.grey.withOpacity(0.3),
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              inactiveThumbColor: Colors.grey,
            ),
            ListTile(
              onTap: () {
                NavigatorTo(context, ChoiceAvatarScreen());
              },
              title: Text(
                "تغير الصورة الشخصية",
                style: TextStyle(
                  color: MyThemes.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Spacer(),
            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {},
              builder: (context, state) {
                AuthCubit authCubit = AuthCubit.get(context);
                return authCubit.isLoadingSignOut
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomTextButton(
                        onPressed: () {
                          authCubit.logOut(context);
                        },
                        text: "تسجيل الخروج",
                        textColor: MyColors.mainColor,
                      );
              },
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        );
      },
    );
  }
}
