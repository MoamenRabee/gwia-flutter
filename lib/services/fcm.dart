import 'dart:developer';

import 'package:dio/dio.dart';

class FcmHelper {
  static BaseOptions baseOptions = BaseOptions(
    headers: {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAAig0o8WY:APA91bGvHLAp7gtaBrVY8HGYRypv2ZNgeY2ONPS6irT29D1AhTwuahL1k82_QFZChIBoMF3lORlRulogsc9G9Vefekm-sndGI1Z5IPefKDKDy-YlgEpYCIIxq22NcdIMiN6VGR5dUzO4",
    },
  );

  static Dio dio = Dio(baseOptions);

  static sendFCM({required String receiverToken}) {
    print(receiverToken);

    dio.options = baseOptions;

    dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: {
        'notification': {
          'body': 'رسالة GWIA جديدة',
          'title': 'أضغط للدخول للبرنامج'
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': receiverToken
      },
    ).then((value) {
      log("FCM SENT");
    }).catchError((e) {
      log(e.toString());
    });
  }
}
