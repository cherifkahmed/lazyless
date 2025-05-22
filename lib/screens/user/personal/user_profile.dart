import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userProfileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoachFormData();
  }

  Future<void> fetchCoachFormData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("User not logged in");
      return;
    }

    try {
      final formSnapshot = await FirebaseFirestore.instance
          .collection('coach')
          .doc(currentUser.uid)
          .collection('form')
          .get();

      if (formSnapshot.docs.isNotEmpty) {
        // Get the first document's data (assuming only one form per user)
        setState(() {
          userProfileData = formSnapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        print("No form data found");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching form data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("User Profile"),
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Color(0xff328E6E),
    ),
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : userProfileData == null
            ? const Center(child: Text("No profile data available"))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: userProfileData!.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    );
                  }).toList(),
                ),
              ),
  );
}

}
