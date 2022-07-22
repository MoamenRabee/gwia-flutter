import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/modules/home/cubit/cubit.dart';
import 'package:gwia/modules/layout/cubit/cubit.dart';
import 'package:gwia/modules/layout/cubit/states.dart';
import 'package:gwia/modules/layout/layout_screen.dart';
import 'package:gwia/services/endpoints.dart';
import 'package:gwia/services/services.dart';
import 'package:gwia/shared/local/cache_helper.dart';
import 'modules/auth/cubit/cubit.dart';
import 'modules/auth/sign_up_screen.dart';
import 'shared/themes/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheHelper.init();
  DioHelper.init();

  if (CacheHelper.getString(key: "username") != "") {
    FirebaseMessaging.instance.getToken().then((value) {
      DioHelper.dio.put(
        EndPoints.getUser + CacheHelper.getString(key: "username"),
        data: {
          "token_fcm": value,
          "username": CacheHelper.getString(key: "username"),
          "code": CacheHelper.getString(key: "code"),
        },
      );
    }).catchError((err) {
      log(err.toString());
    });
  }

  Widget startScreen;

  if (CacheHelper.getString(key: "uId") != "") {
    startScreen = LayoutScreen();
  } else {
    startScreen = SignUpScreen();
  }

  runApp(MyApp(
    startScreen: startScreen,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.startScreen}) : super(key: key);

  Widget startScreen;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LayoutCubit>(
            create: (BuildContext context) => LayoutCubit()),
        BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit()),
      ],
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Guess Who I Am',
            debugShowCheckedModeBanner: false,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            themeMode: MyThemes.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: startScreen,
          );
        },
      ),
    );
  }
}
