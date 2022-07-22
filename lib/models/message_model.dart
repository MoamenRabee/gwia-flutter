class MessageModel {
  int? id;
  String? sender_username;
  String? sender_code;
  String? receiver_username;
  String? receiver_code;
  String? created_date;
  String? message;
  String? image;

  MessageModel({
    required this.id,
    required this.sender_username,
    required this.sender_code,
    required this.receiver_username,
    required this.receiver_code,
    this.created_date,
    required this.message,
    this.image,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    sender_username = json["sender_username"];
    sender_code = json["sender_code"];
    receiver_username = json["receiver_username"];
    receiver_code = json["receiver_code"];
    created_date = json["created_date"].toString();
    message = json["message"];
    image = json["image"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sender_username": sender_username,
      "sender_code": sender_code,
      "receiver_username": receiver_username,
      "receiver_code": receiver_code,
      "created_date": created_date,
      "message": message,
      "image": image,
    };
  }
}
