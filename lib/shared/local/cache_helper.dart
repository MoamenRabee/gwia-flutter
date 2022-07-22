import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static void setBool({required String key, required bool value}) async {
    sharedPreferences!.setBool(key, value).then((valueResponse) {
      print("set $key : $value");
    });
  }

  static setString({required String key, required String value}) {
    sharedPreferences!.setString(key, value).then((valueResponse) {
      print("set $key : $value");
    });
  }

  static setList({required String key, required List<String> value}) {
    sharedPreferences!.setStringList(key, value).then((valueResponse) {
      print("set $key : $value");
    });
  }

  static List<String> getList({required String key}) {
    return sharedPreferences!.getStringList(key) ?? [];
  }

  static String getString({required String key}) {
    return sharedPreferences!.getString(key) ?? "";
  }

  static bool getBool({required String key}) {
    return sharedPreferences!.getBool(key) ?? false;
  }

  static removeKey({required String key}) {
    sharedPreferences!.remove(key).then((valueResponse) {
      print("Removed : $key");
    });
  }
}
