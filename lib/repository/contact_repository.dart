import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../model/user_model.dart';

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});


  Future<List<List>> getAllContacts() async {
    List<UserModel> firebaseContacts = []; // those have account
    List<UserModel> phoneContacts = []; // those does not have account

    try {
      if (await FlutterContacts.requestPermission()) {
        final userCollection = await firestore.collection('users').get();
        final allContactsInThePhone = await FlutterContacts.getContacts(withProperties: true);

        bool isContactFound = false;

        for (var contact in allContactsInThePhone) {
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact = UserModel.fromMap(firebaseContactData.data());
            if (contact.phones[0].number.replaceAll(' ', '') == firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            phoneContacts.add(UserModel(
                username: contact.displayName,
                userId: '',
                profileUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: contact.phones[0].number.replaceAll(' ', ''),
                groupId: [])
            );
          }
          isContactFound = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    return [firebaseContacts, phoneContacts];
  }
}
