import '../data/message_type.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String textMessage;
  final MessageType type;
  final DateTime timeSend;
  final String messageId;
  bool isSeen;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.textMessage,
    required this.type,
    required this.timeSend,
    required this.messageId,
    required this.isSeen
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map["senderId"],
      receiverId: map["receiverId"],
      textMessage: map["textMessage"],
      type: (map["type"] as String).toEnum(),
      timeSend: DateTime.fromMillisecondsSinceEpoch(map["timeSend"]),
      messageId: map["messageId"],
      isSeen: map["isSeen"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "textMessage": textMessage,
      "type": type.type,
      "timeSend": timeSend.millisecondsSinceEpoch,
      "messageId": messageId,
      "isSeen": isSeen,
    };
  }
}
