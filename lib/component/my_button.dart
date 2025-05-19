import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const MyButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * .08,
      width: screenWidth ,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFFFDF6),Color(0xff9EBC8A),Color(0xffFFFDF6)]
        ),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all()
      ),
      child: ElevatedButton(
        
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0, // remove shadow
          backgroundColor: Colors.transparent, // transparent background
          shadowColor: Colors.transparent, // remove shadow color
          
        ),
        child: Text(title,style: TextStyle(color: Color(0xffEF9651),fontSize: screenHeight * .05))
      ),
    );
  }
}