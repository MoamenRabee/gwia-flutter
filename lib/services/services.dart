import 'package:dio/dio.dart';

class DioHelper {
  static String url = 'http://192.168.1.5:8000/';

  static String base_link = url.endsWith("/")
      ? DioHelper.url.substring(0, DioHelper.url.length - 1)
      : DioHelper.url;

  static BaseOptions baseOptions = BaseOptions(baseUrl: url, headers: {
    "Authorization": "Token 6940618232895d2f512e85775c62c2c168a1a0a0",
    "Content-Type": "application/json"
  });

  static Dio dio = Dio();

  static init() {
    dio.options = baseOptions;
  }
}
