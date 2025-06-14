import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailandPassord(String email, String password)async{
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      // create new document 
          _firestore.collection('users').doc(userCredential.user!.uid).set({
              'uid': userCredential.user!.uid,
              'email': email,
          },SetOptions(merge: true));
      return userCredential;
    }on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  //create new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, password)async{
        try {
          UserCredential userCredential =
              await _firebaseAuth.createUserWithEmailAndPassword(
                email: email, 
                password: password
              );

              // create new document 
              _firestore.collection('users').doc(userCredential.user!.uid).set({
                'uid': userCredential.user!.uid,
                'email': email,
              });


              return userCredential;
        }on FirebaseAuthException catch (e) {
          throw Exception(e.code);
        }
      }



  // signout user
  Future<void> signOut()async{
    return await FirebaseAuth.instance.signOut();
  }
}