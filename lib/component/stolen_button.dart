import 'package:flutter/material.dart';

class StolenButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const StolenButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * .8,
        height: screenHeight * .08,
        padding: EdgeInsets.all(screenHeight * .02),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            
            fontSize: 20
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}