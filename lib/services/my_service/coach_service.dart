import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/model/coach_model.dart';

class CoachService extends ChangeNotifier{
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCoach(String firstName, String lastName,int age ,String domain)async{
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    //create a new user
    CoachModel newCoach = CoachModel(
      coachId: currentUserId, 
      coachFirstName: firstName, 
      coachLastName: lastName,
      age: age, 
      domain: domain
    );
    await _firestore
          .collection('coach')
          .doc(currentUserId)
          .collection('form')
          .add(newCoach.toMap());
  }
  Future<void> fetchCoachFormData() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    print("User not logged in");
    return;
  }

  final formSnapshot = await FirebaseFirestore.instance
    .collection('coach')
    .doc(currentUser.uid)
    .collection('form')
    .get();

  for (var doc in formSnapshot.docs) {
    print('Form ID: ${doc.id}');
    print('Form Data: ${doc.data()}');
  }
}

  

}