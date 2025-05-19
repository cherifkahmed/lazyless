import 'package:flutter/material.dart';
import 'package:lazyless/screens/user/daily_habit/habit_screen.dart';
import 'package:lazyless/screens/user/find_coach.dart';
import 'package:lazyless/screens/user/focus/timer_screen.dart';
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
  int _currentPageIndex = 1;
  final List<Widget> _pages = [
    HabitScreen(),
    TimerScreen(),
    FindCoach(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazyless'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: 
          signOut,  
          icon: const Icon(Icons.logout))
        ],
      ),
      body:  _pages[_currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF3FA2F6),
          fixedColor: Colors.black,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.router_outlined), label: 'Habit tracker'),
            BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Focus'),
            
            BottomNavigationBarItem(icon: Icon(Icons.route_outlined), label: 'Events'),
          ],
          currentIndex: _currentPageIndex,
          onTap: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
    );
  }

  
}