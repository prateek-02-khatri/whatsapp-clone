import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/utils/utils.dart';

import '../model/user_model.dart';
import '../utils/routes/routes.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  });

  Future<Map<String, dynamic>> getUserPresenceStatus({required String userId}) async {
    var snapshot = await realtime.ref().child(userId).get();
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, Object?>?;
    return {
      'active': data!['active'],
      'lastSeen': data['lastSeen'],
    };
  }

  void updateUserPresence({required bool isConnected}) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> online = {
      'active': true,
      'lastSeen': time
    };
    Map<String, dynamic> offline = {
      'active': false,
      'lastSeen': time
    };
    String userId = auth.currentUser!.uid;
    if (isConnected) {
      await realtime.ref().child(userId).update(online);
      await firestore.collection('users').doc(userId).update({
        'active': true
      });
    } else {
      await realtime.ref().child(userId).update(offline);
      await firestore.collection('users').doc(userId).update({
        'active': false
      });
    }
  }

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user;
    final userInfo = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    if (userInfo.data() == null) return user;
    user = UserModel.fromMap(userInfo.data()!);
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      Utils.showLoadingDialog(context: context, message: 'Saving user info...');
      String userId = auth.currentUser!.uid;
      String profileImageUrl = profileImage is String ? profileImage : '';
      if (profileImage != null && profileImage is! String) {
        profileImageUrl = await storeFileToFirebase('profileImage/$userId', profileImage);
      }
      UserModel user = UserModel(
        username: username,
        userId: userId,
        profileUrl: profileImageUrl,
        active: true,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(userId).set(user.toMap());
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (routes) => false);
    } catch (e) {
      Navigator.pop(context);
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  Future<String> storeFileToFirebase(String ref, var file) async {
    UploadTask? uploadTask;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    if (file is File) {
      uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    }
    if (file is Uint8List) {
      uploadTask = firebaseStorage.ref().child(ref).putData(file);
    }

    TaskSnapshot? snapshot = await uploadTask;
    String imageUrl = await snapshot!.ref.getDownloadURL();
    return imageUrl;
  }

  void logout(context) async {
    updateUserPresence(isConnected: false);
    await auth.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, Routes.welcome);
  }

  void verifySMSCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted
  }) async {
    try {
      Utils.showLoadingDialog(context: context, message: 'Verifying code...');
      final credential = PhoneAuthProvider.credential(
          verificationId: smsCodeId, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      UserModel? user = await getCurrentUserInfo();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.userInfo, (routes) => false,
          arguments: user?.profileUrl);
    } on FirebaseAuth catch (e) {
      Navigator.pop(context);
      Utils.showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendSMSCode({
    required BuildContext context,
    required String phoneNumber
  }) async {
    try {
      Utils.showLoadingDialog(
          context: context,
          message: 'Sending a verification code to $phoneNumber');
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            Utils.showAlertDialog(context: context, message: e.toString());
          },
          codeSent: (smsCodeId, resendSMSCodeId) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.verification, (route) => false,
                arguments: {
                  'phoneNumber': phoneNumber,
                  'smsCodeId': smsCodeId,
                });
          },
          codeAutoRetrievalTimeout: (String smsCodeId) {
            Navigator.pop(context);
          });
    } on FirebaseAuth catch (e) {
      Utils.showAlertDialog(context: context, message: e.toString());
      Navigator.pop(context);
    }
  }
}
