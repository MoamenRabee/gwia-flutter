class ChatModel {
  String? myUId;
  String? userUId;
  String? myName;
  String? userName;
  String? lastMessage;

  ChatModel({
    required this.myUId,
    required this.userUId,
    required this.myName,
    required this.userName,
    required this.lastMessage,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    myUId = json["myUId"];
    userUId = json["userUId"];
    myName = json["myName"];
    userName = json["userName"];
    lastMessage = json["lastMessage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "myUId": myUId,
      "userUId": userUId,
      "myName": myName,
      "userName": userName,
      "lastMessage": lastMessage,
    };
  }
}
