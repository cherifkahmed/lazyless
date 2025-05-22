import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/client_or_coach.dart';
//import 'package:lazyless/screens/user/home_user.dart';
import 'package:lazyless/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

Future<bool> getIsCoach(String uid) async {
  try {
    // Query the 'form' subcollection under the coach's UID
    final QuerySnapshot formSnapshot = await FirebaseFirestore.instance
        .collection('coach')
        .doc(uid)
        .collection('form')
        .get();

    if (formSnapshot.docs.isNotEmpty) {
      // Assuming only one form per user
      final data = formSnapshot.docs.first.data() as Map<String, dynamic>;
      return data['isCoach'] ?? false;
    }
  } catch (e) {
    print('Error fetching isCoach: $e');
  }

  return false;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authSnapshot.hasData && authSnapshot.data != null) {
            String uid = authSnapshot.data!.uid;

            // Now fetch isCoach before navigating
            return FutureBuilder<bool>(
              future: getIsCoach(uid),
              builder: (context, coachSnapshot) {
                if (coachSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (coachSnapshot.hasError) {
                  return Center(child: Text("Error: ${coachSnapshot.error}"));
                }

                bool isCoach = coachSnapshot.data ?? false;
                return ClientOrCoach(isCoach: isCoach);
              },
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
