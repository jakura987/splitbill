import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userName;
  String? _userEmail;

  String get userName => _userName ?? '';
  String get userEmail => _userEmail ?? '';

  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (userDoc.size == 0) return;

    _userName = userDoc.docs.first['name'];
    _userEmail = userDoc.docs.first['email'];

    notifyListeners(); // Don't forget to notify listeners
  }

}



