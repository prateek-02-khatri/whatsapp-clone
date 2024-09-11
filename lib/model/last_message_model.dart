import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  final String username;
  final String profileImageUrl;
  final String contactId;
  final DateTime timeSend;
  final String lastMessage;

  LastMessageModel({
    required this.username,
    required this.profileImageUrl,
    required this.contactId,
    required this.timeSend,
    required this.lastMessage
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImageUrl': profileImageUrl,
      'contactId': contactId,
      'timeSend': timeSend,
      'lastMessage': lastMessage,
    };
  }

  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSend: (map['timeSend'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
