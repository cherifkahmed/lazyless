import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getUserInfo() async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('coach')
      .doc(_firebaseAuth.currentUser!.uid)
      .collection('form')
      .doc(_firestore.app.name)
      .get();

  if (userDoc.exists) {
    var data = userDoc.data() as Map<String, dynamic>;
    print('Name: ${data['name']}');
    print('Last Name: ${data['lastName']}');
  } else {
    print('User not found');
  }
}
  
}