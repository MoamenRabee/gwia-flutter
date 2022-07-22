import 'dart:developer' as dev;
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/models/user_model.dart';
import 'package:gwia/modules/auth/choice_avatar_screen.dart';
import 'package:gwia/modules/auth/cubit/states.dart';
import 'package:gwia/modules/auth/sign_up_screen.dart';
import 'package:gwia/modules/layout/layout_screen.dart';
import 'package:gwia/services/endpoints.dart';
import 'package:gwia/services/services.dart';
import 'package:gwia/shared/local/cache_helper.dart';
import 'package:gwia/shared/themes/colors.dart';

import '../../../functions/functions.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  late String chooseAvatar = CacheHelper.getString(key: "avatarName") != ""
      ? CacheHelper.getString(key: "avatarName")
      : "1";
  late bool isLoading = false;
  late bool isLoadingSignOut = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void selectAvatar({required String avatarName}) {
    chooseAvatar = avatarName;
    emit(AuthChooseAvatarState());
  }

  void registerWithEmailAndPassword({
    required String username,
    required String password,
    required BuildContext context,
  }) {
    isLoading = true;
    emit(RegisterLoadingState());

    // Create Email Account
    firebaseAuth
        .createUserWithEmailAndPassword(
      email: username.trim() + "@gwia.com",
      password: password,
    )
        .then((value) async {
      // Create Random code
      int code = Random().nextInt(99999999);
      User? user = value.user!;

      String? fcmId = await FirebaseMessaging.instance.getToken();

      try {
        // Create User
        await DioHelper.dio.post(EndPoints.createUser, data: {
          "username": username,
          "code": code,
          "u_id": user.uid,
          "token_fcm": fcmId,
          "avatar_name": "1"
        });
      } catch (e) {
        dev.log(e.toString());
      }

      isLoading = false;
      emit(RegisterSuccessState());

      CacheHelper.setString(key: "uId", value: user.uid);
      CacheHelper.setString(key: "username", value: username);
      CacheHelper.setString(key: "avatarName", value: "1");
      CacheHelper.setString(key: "code", value: code.toString());

      NavigatorOffAll(context, ChoiceAvatarScreen());
    }).catchError((err) {
      isLoading = false;
      if (err.code == 'weak-password') {
        showToast(msg: "كلمة السر ضعيفة", color: MyColors.mainColor);
      } else if (err.code == 'email-already-in-use') {
        showToast(msg: "اسم المستخدم مسجل من قبل", color: MyColors.mainColor);
      } else {
        showToast(msg: err.toString(), color: MyColors.mainColor);
      }
      emit(RegisterErrorState(err.toString()));
    });
  }

  void SignUpWithEmailAndPassword({
    required String username,
    required String password,
    required BuildContext context,
  }) {
    isLoading = true;
    emit(SignUpLoadingState());

    // signIn Email Account
    firebaseAuth
        .signInWithEmailAndPassword(
      email: username.trim() + "@gwia.com",
      password: password,
    )
        .then((value) async {
      var user = await DioHelper.dio.get(EndPoints.getUser + username);

      UserModel userModel = UserModel.fromJson(user.data);

      CacheHelper.setString(key: "uId", value: value.user!.uid);
      CacheHelper.setString(key: "username", value: userModel.username!);
      CacheHelper.setString(key: "avatarName", value: userModel.avatarName!);
      CacheHelper.setString(key: "code", value: userModel.code.toString());

      // update fcm
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
        dev.log(err.toString());
      });

      isLoading = false;
      emit(SignUpSuccessState());

      NavigatorOffAll(context, LayoutScreen());
    }).catchError((err) {
      if (err.code == 'wrong-password') {
        showToast(msg: "كلمة السر غير صحيحة", color: MyColors.mainColor);
      } else if (err.code == 'user-not-found') {
        showToast(msg: "الحساب غير موجود", color: MyColors.mainColor);
      } else if (err.code == 'too-many-requests') {
        showToast(
            msg: "الرجاء المحاولة لاحقا ، لقد تعديت الحد الاقصى للمحاولات",
            color: MyColors.mainColor);
      } else {
        showToast(msg: err.toString(), color: MyColors.mainColor);
      }
      print(err.toString());
      isLoading = false;
      emit(SignUpErrorState(err.toString()));
    });
  }

  changeAvatarImage(BuildContext context) async {
    isLoading = true;
    emit(ChangeAvatarLoadingState());
    try {
      await DioHelper.dio.put(
        EndPoints.getUser + CacheHelper.getString(key: "username"),
        data: {
          "username": CacheHelper.getString(key: "username"),
          "code": CacheHelper.getString(key: "code"),
          "avatar_name": chooseAvatar,
        },
      );

      CacheHelper.setString(key: "avatarName", value: chooseAvatar);

      isLoading = false;
      emit(ChangeAvatarSuccessState());
      NavigatorOffAll(context, LayoutScreen());
    } catch (e) {
      isLoading = false;
      emit(ChangeAvatarErrorState(e.toString()));
    }
  }

  void logOut(BuildContext context) async {
    isLoadingSignOut = true;
    emit(SignOutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeKey(key: "uId");
      CacheHelper.removeKey(key: "username");
      CacheHelper.removeKey(key: "avatarName");
      CacheHelper.removeKey(key: "code");

      NavigatorOffAll(context, SignUpScreen());
      isLoadingSignOut = false;
      emit(SignOutSuccessState());
    }).catchError((e) {
      isLoadingSignOut = false;
      print(e.toString());
      emit(SignOutErrorState(e.toString()));
    });
  }
}
