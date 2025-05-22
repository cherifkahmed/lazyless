import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lazyless/screens/coach/clients_page.dart';
import 'package:lazyless/screens/coach/coach_profile.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomeCoach extends StatefulWidget {
  const HomeCoach({super.key});

  @override
  State<HomeCoach> createState() => _HomeCoachState();
}

class _HomeCoachState extends State<HomeCoach> {



  //sign out
  void signOut(){
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

   //Navbar
  int _currentPageIndex = 0;
  final List<Widget> _pages = [
    CoachProfile(),
    
    ClientsPage(),
  ];


Future<String?> getUserFirstname() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return null;

  final formSnapshot = await FirebaseFirestore.instance
      .collection('coach')
      .doc(currentUser.uid)
      .collection('form')
      .get();

  if (formSnapshot.docs.isNotEmpty) {
    final data = formSnapshot.docs.first.data();
    return data['coachFirstName'] as String?;
  }

  return null;
}






  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * .1,
        title: Text('Coach'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff328E6E),
        actions: [
          IconButton(onPressed: 
          signOut,  
          icon: const Icon(Icons.logout))
        ],
      ),
      
      body:  _pages[_currentPageIndex],
        bottomNavigationBar: Container(
          color: Color(0xff328E6E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0,vertical: 20.0),
            child: GNav(
              backgroundColor: Color(0xff328E6E),
              color:Colors.white ,
              activeColor: Colors.white,
              tabBackgroundColor: Color(0xff90C67C),
              gap: 8,
              onTabChange: (value) {
                print(value);
                setState(() {
                  _currentPageIndex = value;
                });
                
              },
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(icon: Icons.home,text: 'Home'),
                GButton(
                  icon: Icons.supervised_user_circle_sharp,
                  text: 'Clients',
                  ),
                
                
              ]
            ),
          ),
        )
    );
  }

 

  
}