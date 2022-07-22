class UserModel {
  String? username;
  String? uId;
  String? avatarName;
  int? code;
  String? fcmId;

  UserModel({
    required this.username,
    required this.uId,
    required this.avatarName,
    required this.code,
    required this.fcmId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json["username"];
    uId = json["u_id"];
    avatarName = json["avatar_name"];
    code = json["code"];
    fcmId = json["token_fcm"];
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "u_id": uId,
      "avatar_name": avatarName,
      "code": code,
      "token_fcm": fcmId,
    };
  }
}
