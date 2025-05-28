import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/model/user_model.dart';

class UserService extends ChangeNotifier{
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<void> addUser(String firstName, String lastName,int age, String condition)async{
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    //create a new user
    UserModel nuser = UserModel(
      userId: currentUserId, 
      userFirstName: firstName, 
      userLastName: lastName,
      userAge: age,
      condition: condition
    );
    //create new user
    await _firestore
          .collection('client')
          .doc(currentUserId)
          .collection('form')
          .add(nuser.toMap());
  }

  

}