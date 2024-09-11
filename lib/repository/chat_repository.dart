import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/data/message_type.dart';
import 'package:whatsapp_clone/model/last_message_model.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/repository/auth_repository.dart';
import 'package:whatsapp_clone/utils/utils.dart';

import '../model/user_model.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<MessageModel>> getAllOneToOneMessage(String receiverId) {
    return firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('chats')
      .doc(receiverId)
      .collection('messages')
      .orderBy('timeSend')
      .snapshots()
      .map((event) {
        List<MessageModel> messages = [];
        try {
          for (var message in event.docs) {
            messages.add(MessageModel.fromMap(message.data()));
          }
        } catch (e) {
          log(e.toString());
        }
        return messages;
      });
  }

  Stream<List<LastMessageModel>> getAllLastMessageList() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<LastMessageModel> contacts = [];
      for (var document in event.docs) {
        final lastMessage = LastMessageModel.fromMap(document.data());
        final userData = await firestore.collection('users').doc(
            lastMessage.contactId).get();
        final user = UserModel.fromMap(userData.data()!);
        contacts.add(
          LastMessageModel(
            username: user.username,
            profileImageUrl: user.profileUrl,
            contactId: lastMessage.contactId,
            timeSend: lastMessage.timeSend,
            lastMessage: lastMessage.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required var file,
    required String receiverId,
    required UserModel senderData,
    required MessageType messageType,
    required AuthRepository auth
  }) async {
    try {
      final timeSend = DateTime.now();
      final messageId = const Uuid().v1();

      final imageUrl = await auth.storeFileToFirebase(
          'chats/${messageType.type}/${senderData
              .userId}/$receiverId/$messageId',
          file
      );

      final userMap = await firestore.collection('users').doc(receiverId).get();
      final receiverUserData = UserModel.fromMap(userMap.data()!);

      String lastMessage;

      switch (messageType) {
        case MessageType.image:
          lastMessage = '📸 Photo message';
          break;
        case MessageType.audio:
          lastMessage = '🎤 Voice message';
          break;
        case MessageType.video:
          lastMessage = '🎥 Video message';
          break;
        case MessageType.gif:
          lastMessage = '📦 GIF message';
          break;
        default:
          lastMessage = '📸 Photo message';
          break;
      }

      saveToMessageCollection(
          receiverId: receiverId,
          textMessage: imageUrl,
          timeSent: timeSend,
          textMessageId: messageId,
          senderUsername: senderData.username,
          receiverUsername: receiverUserData.username,
          messageType: messageType
      );

      saveAsLastMessage(
          senderUserData: senderData,
          receiverUserData: receiverUserData,
          lastMessage: lastMessage,
          timeSent: timeSend,
          receiverId: receiverId
      );
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverId,
    required UserModel senderData,
  }) async {
    try {
      final timeSent = DateTime.now();
      final receiverDataMap = await firestore.collection('users').doc(
          receiverId).get();
      final receiverData = UserModel.fromMap(receiverDataMap.data()!);
      final textMessageId = const Uuid().v1();

      saveToMessageCollection(
        receiverId: receiverId,
        textMessage: textMessage,
        timeSent: timeSent,
        textMessageId: textMessageId,
        senderUsername: senderData.username,
        receiverUsername: receiverData.username,
        messageType: MessageType.text,
      );

      saveAsLastMessage(
        senderUserData: senderData,
        receiverUserData: receiverData,
        lastMessage: textMessage,
        timeSent: timeSent,
        receiverId: receiverId,
      );
    } catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  void saveToMessageCollection({
    required String receiverId,
    required String textMessage,
    required DateTime timeSent,
    required String textMessageId,
    required String senderUsername,
    required String receiverUsername,
    required MessageType messageType,
  }) async {
    final message = MessageModel(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      textMessage: textMessage,
      type: messageType,
      timeSend: timeSent,
      messageId: textMessageId,
      isSeen: false,
    );

    // sender
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());

    // receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(textMessageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    final receiverLastMessage = LastMessageModel(
      username: senderUserData.username,
      profileImageUrl: senderUserData.profileUrl,
      contactId: senderUserData.userId,
      timeSend: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverLastMessage.toMap());

    final senderLastMessage = LastMessageModel(
      username: receiverUserData.username,
      profileImageUrl: receiverUserData.profileUrl,
      contactId: receiverUserData.userId,
      timeSend: timeSent,
      lastMessage: lastMessage,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderLastMessage.toMap());
  }
}
