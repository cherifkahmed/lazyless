import 'package:flutter/material.dart';

class Roots {
  static Route<dynamic> rootsList(RouteSettings settings) {
    switch (settings.name) {
    

      // case '/focus_history':
      //   return MaterialPageRoute(builder: (context) => FocusHistory());

      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
