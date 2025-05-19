import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/screens/chat_page.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class FindCoach extends StatefulWidget {
  const FindCoach({super.key});

  @override
  State<FindCoach> createState() => _FindCoachState();
}

class _FindCoachState extends State<FindCoach> {

  //instance of auth
  final FirebaseAuth _auth =FirebaseAuth.instance;

  //sign out
  void signOut(){
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUserList(),
    );
  }

  /// build a list of users
  /// expect for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots() ,
      builder: (context, snapshot){
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }
        return ListView(
          children: snapshot.data!.docs
                .map<Widget>((doc)=> _buildUserListItem(doc))
                .toList(),
        );

      },
    );
  }



  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //pass the user to the chat page
          Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context)=>ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUserID: data['uid'],
                  )
                ),
          );
        },
      );
    }else{
      return Container();
    }
  }
}