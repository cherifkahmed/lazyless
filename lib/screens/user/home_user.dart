import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lazyless/component/my_list_tile.dart';
import 'package:lazyless/screens/user/daily_habit/habit_screen.dart';
import 'package:lazyless/screens/user/find_coach.dart';
import 'package:lazyless/screens/user/focus/focus_history.dart';
import 'package:lazyless/screens/user/focus/timer_screen.dart';
import 'package:lazyless/screens/user/personal/user_profile.dart';
import 'package:lazyless/screens/user/phone_usage/list_apps.dart';
import 'package:lazyless/screens/user/phone_usage/list_marked_apps.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {



  //sign out
  void signOut(){
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

   //Navbar
  int _currentPageIndex = 0;
  final List<Widget> _pages = [
    TimerScreen(),
    HabitScreen(),
    
    FindCoach(),
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * .1,
        title: Text('Lazyless'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff328E6E),
        actions: [
          IconButton(onPressed: 
          signOut,  
          icon: const Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: screenHeight * 0.3,
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF67AE6E),Color(0xFF328E6E),]
                  )
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * .2,
                      backgroundImage: AssetImage('lib/assets/images/solo-levling.png'),
                    ),
                    FutureBuilder<String?>(
        future: getUserFirstname(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.white);
          } else if (snapshot.hasData && snapshot.data != null) {
            return Text(
              snapshot.data!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            );
          } else {
            return const Text(
              "Unknown User",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            );
          }
        },
      ),
                  ],
                )
              ),
            ),
             MyListTile(
              title: 'Profile', 
              onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile()
                      )
                    );
              }
            ),
            MyListTile(
              title: 'Focus History', 
              onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FocusHistory()
                      )
                    );
              }
            ),
            MyListTile(
              title: 'Check apps', 
              onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListApps()
                      )
                    );
              }
            ),
            MyListTile(
              title: 'Check usage stats', 
              onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListMarkedApps()
                      )
                    );
              }
            ),
          ],
        ),
      ),
      body:  _pages[_currentPageIndex],
        bottomNavigationBar: Container(
          color: Color(0xff328E6E),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
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
                GButton(icon: Icons.hourglass_top,text: 'Focus'),
                GButton(
                  icon: Icons.loop,
                  text: 'Daily routine',
                  ),
                
                GButton(icon: Icons.emoji_people,text: 'Coach',),
                
              ]
            ),
          ),
        )
    );
  }

 

  
}