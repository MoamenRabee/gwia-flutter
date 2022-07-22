import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwia/functions/functions.dart';
import 'package:gwia/models/user_model.dart';
import 'package:gwia/modules/home/cubit/states.dart';
import 'package:gwia/services/endpoints.dart';
import 'package:gwia/services/fcm.dart';
import 'package:gwia/services/services.dart';
import 'package:gwia/shared/local/cache_helper.dart';
import 'package:gwia/shared/themes/colors.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/message_model.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitState());

  static HomeCubit get(context) => BlocProvider.of(context);

  String mycode = CacheHelper.getString(key: "code");
  String myusername = CacheHelper.getString(key: "username");
  bool isLoading = false;
  bool isLoadingGetMessages = false;
  bool isLoadingGetSendMessages = false;
  bool isSelectedImage = false;
  File? selectedImage;

  void selectImage() async {
    ImagePicker imagePacker = ImagePicker();

    XFile? image = await imagePacker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      isSelectedImage = true;
    } else {
      selectedImage = null;
    }

    emit(HomeSelectImageSuccessState());
  }

  void removeSelectedImage() async {
    selectedImage = null;
    isSelectedImage = false;
    emit(HomeSelectImageSuccessState());
  }

  void sendNewMessage({
    required String code,
    required String message,
    required BuildContext context,
  }) async {
    isLoading = true;
    emit(HomeSendMessageLoadingState());
    try {
      if (code == mycode) {
        showToast(msg: "لا يمكنك ارسال رسالة لنفسك", color: MyColors.mainColor);
      } else {
        try {
          var user = await DioHelper.dio.get(EndPoints.getUserByCode + code);
          UserModel receiver_user = UserModel.fromJson(user.data);

          FormData formdata;
          if (selectedImage != null) {
            String fileName = selectedImage!.path.split('/').last;

            formdata = FormData.fromMap({
              "sender_username": myusername,
              "receiver_username": receiver_user.username,
              "sender_code": mycode,
              "receiver_code": receiver_user.code,
              "message": message,
              "image": await MultipartFile.fromFile(
                selectedImage!.path,
                filename: fileName,
              ),
            });
          } else {
            formdata = FormData.fromMap({
              "sender_username": myusername,
              "receiver_username": receiver_user.username,
              "sender_code": mycode,
              "receiver_code": receiver_user.code,
              "message": message,
            });
          }

          DioHelper.dio
              .post(EndPoints.NewMessage, data: formdata)
              .then((value) async {
            showToast(msg: "تم إرسال الرسالة", color: Colors.blue);

            // SEND FCM
            FcmHelper.sendFCM(receiverToken: receiver_user.fcmId!);
            get_send_messages();

            NavigatorBack(context);
          }).catchError((e) {
            log(e.toString());
            showToast(
                msg: "حدث خطأ أثناء ارسال الرسالة", color: MyColors.mainColor);
          });
        } catch (e) {
          showToast(
              msg: "لا يوجد مستخدم بهذا الكود", color: MyColors.mainColor);
        }
      }

      isLoading = false;
      emit(HomeSendMessageSuccessState());
    } catch (e) {
      isLoading = false;
      emit(HomeSendMessageErrorState(e.toString()));
      log(e.toString());
    }
  }

  List<MessageModel> messages = [];
  void get_messages() async {
    messages.clear();
    isLoadingGetMessages = true;
    emit(HomeGetMessagesLoadingState());

    try {
      var all_messages = await DioHelper.dio
          .get(EndPoints.messages + CacheHelper.getString(key: "username"));
      all_messages.data.forEach((element) {
        messages.add(MessageModel.fromJson(element));
      });

      isLoadingGetMessages = false;
      emit(HomeGetMessagesSuccessState());
    } catch (e) {
      isLoadingGetMessages = false;
      emit(HomeGetMessagesErrorState(e.toString()));
    }
  }

  List<MessageModel> send_messages = [];
  void get_send_messages() async {
    send_messages.clear();
    isLoadingGetSendMessages = true;
    emit(HomeGetSendMessagesLoadingState());

    try {
      var all_messages = await DioHelper.dio
          .get(EndPoints.messagesSend + CacheHelper.getString(key: "username"));
      all_messages.data.forEach((element) {
        send_messages.add(MessageModel.fromJson(element));
      });

      isLoadingGetSendMessages = false;
      emit(HomeGetSendMessagesSuccessState());
    } catch (e) {
      isLoadingGetSendMessages = false;
      emit(HomeGetSendMessagesErrorState(e.toString()));
    }
  }

  void add_remove_favorate({required String messageId}) {
    List<String> favorates = CacheHelper.getList(key: "favorates");
    if (favorates.contains(messageId) == false) {
      favorates.add(messageId);
      CacheHelper.setList(key: "favorates", value: favorates);
    } else {
      favorates.remove(messageId);
      CacheHelper.setList(key: "favorates", value: favorates);
    }
    emit(HomeFavorateSuccessState());
  }

  List<MessageModel> favorate_messages = [];
  void get_favorates() {
    favorate_messages.clear();

    List<String> favorates = CacheHelper.getList(key: "favorates");
    for (var message in messages) {
      if (favorates.contains(message.id.toString())) {
        favorate_messages.add(message);
      }
    }

    emit(HomeGetFavoratesSuccessState());
  }

  //end
}
