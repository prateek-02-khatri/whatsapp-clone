import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp_clone/repository/auth_repository.dart';

import '../model/user_model.dart';


class AuthProvider with ChangeNotifier {

  bool _isFetching = true;
  bool get isFetching => _isFetching;

  bool _active = false;
  bool get active => _active;

  int _lastSeen = 0;
  int get lastSeen => _lastSeen;

  void setFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  AuthRepository authRepository = AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    realtime: FirebaseDatabase.instance
  );

  void getUserPresenceStatus({required String userId}) async {
    Map<String, dynamic> map = await authRepository.getUserPresenceStatus(userId: userId);
    _active = map['active'];
    _lastSeen = map['lastSeen'];
    setFetching(false);
  }

  void updateUserPresence({required bool isConnected}) {
    return authRepository.updateUserPresence(isConnected: isConnected);
  }

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user = await authRepository.getCurrentUserInfo();
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required BuildContext context,
    required bool mounted,
  }) {
    authRepository.saveUserInfoToFirestore(username: username, profileImage: profileImage, context: context, mounted: mounted);
  }

  void verifySMSCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted
  }) {
    authRepository.verifySMSCode(context: context, smsCodeId: smsCodeId, smsCode: smsCode, mounted: mounted);
  }

  void sendSMSCode({
    required BuildContext context,
    required String phoneNumber
  }) {
    authRepository.sendSMSCode(context: context, phoneNumber: phoneNumber);
  }

  void logout(context) {
    authRepository.logout(context);
  }
}