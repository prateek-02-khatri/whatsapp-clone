
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:whatsapp_clone/repository/contact_repository.dart';

class ContactProvider with ChangeNotifier {
  ContactsRepository contactsRepository = ContactsRepository(firestore: FirebaseFirestore.instance);

  List<List> _allContacts = [];
  List<List> get allContacts => _allContacts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;


  Future<void> getAllContacts() async {
    List<List> allContacts = await contactsRepository.getAllContacts();
    _allContacts = allContacts;
    _isLoading = false;
    notifyListeners();
  }
}