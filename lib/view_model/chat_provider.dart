import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp_clone/data/message_type.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import '../model/last_message_model.dart';
import '../model/message_model.dart';
import 'auth_provider.dart' as authProvider;
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/repository/chat_repository.dart';

class ChatProvider with ChangeNotifier {

  ChatRepository chatRepository = ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance
  );

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return chatRepository.getAllOneToOneMessage(receiverId);
  }

  Stream<List<LastMessageModel>> getAllLastMessageList() {
    return chatRepository.getAllLastMessageList();
  }

  void sendFileMessage({
    required BuildContext context,
    required var file,
    required String receiverId,
    required MessageType messageType,
  }) async {
    authProvider.AuthProvider auth = authProvider.AuthProvider();
    UserModel senderData = await auth.getCurrentUserInfo() as UserModel;
    return chatRepository.sendFileMessage(
        context: context,
        file: file,
        receiverId: receiverId,
        senderData: senderData,
        messageType: messageType,
        auth: auth.authRepository
    );
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
  }) async {
    authProvider.AuthProvider auth = authProvider.AuthProvider();
    UserModel senderData = await auth.getCurrentUserInfo() as UserModel;
    chatRepository.sendTextMessage(
      context: context,
      receiverId: receiverId,
      textMessage: textMessage,
      senderData: senderData
    );
  }
}